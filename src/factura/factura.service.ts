import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ConflictException,
  Inject,
  forwardRef,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { randomUUID } from 'crypto';
import { Factura } from './entities/factura.entity';
import { DetalleFactura } from './entities/detalle-factura.entity';
import { CreateFacturaDto } from './dto/create-factura.dto';
import { UpdateFacturaDto } from './dto/update-factura.dto';
import { ReservaService } from '../reserva/reserva.service';
import { Reserva } from '../reserva/entities/reserva.entity';
import { Pedido } from '../servicio/entities/pedido.entity';
import { PedidoItem } from '../servicio/entities/pedido-item.entity';
import { Servicio } from '../servicio/entities/servicio.entity';

@Injectable()
export class FacturaService {
  constructor(
    @InjectRepository(Factura)
    private facturaRepository: Repository<Factura>,
    @InjectRepository(DetalleFactura)
    private detalleFacturaRepository: Repository<DetalleFactura>,
    @InjectRepository(Pedido)
    private pedidoRepository: Repository<Pedido>,
    @InjectRepository(PedidoItem)
    private pedidoItemRepository: Repository<PedidoItem>,
    @InjectRepository(Servicio)
    private servicioRepository: Repository<Servicio>,
    private dataSource: DataSource,
    @Inject(forwardRef(() => ReservaService))
    private reservaService: ReservaService,
  ) {}

  /**
   * Generar número de factura secuencial
   * Formato: FAC-{AÑO}-{SECUENCIA_5_DÍGITOS}
   * Ejemplo: FAC-2026-00001
   */
  private async generarNumeroFactura(): Promise<string> {
    const año = new Date().getFullYear();

    // Buscar la última factura creada usando find() en lugar de findOne()
    const facturasUltimas = await this.facturaRepository.find({
      order: { id: 'DESC' },
      take: 1,
    });

    const ultimaFactura = facturasUltimas[0];
    const siguiente = (ultimaFactura?.id ?? 0) + 1;
    return `FAC-${año}-${String(siguiente).padStart(5, '0')}`;
  }

  /**
   * Generar factura desde una reserva completada
   * Calcula:
   *  - Línea de habitación (noches * precio/noche)
   *  - Líneas de servicios entregados (items de pedidos entregados)
   * Retorna la factura con detalles y cálculos de IVA
   * 
   * @param reserva - Reserva completada
   * @param existingQueryRunner - QueryRunner existente para evitar transacciones anidadas (opcional)
   */
  async generarDesdeReserva(reserva: Reserva, existingQueryRunner?: any): Promise<Factura> {
    // Validar que no exista ya una factura para esta reserva
    const facturaExistente = await this.facturaRepository.findOne({
      where: { idReserva: reserva.id },
    });

    if (facturaExistente) {
      throw new ConflictException(
        `Ya existe una factura para la reserva ${reserva.id}`,
      );
    }

    // Usar queryRunner existente o crear uno nuevo
    const queryRunner = existingQueryRunner || this.dataSource.createQueryRunner();
    const debeIniciarTransaccion = !existingQueryRunner; // Solo iniciar si es nuestro queryRunner

    if (debeIniciarTransaccion) {
      await queryRunner.connect();
      await queryRunner.startTransaction();
    }

    try {
      // Generar número de factura dentro de la transacción
      const numeroFactura = await this.generarNumeroFactura();

      // Calcular número de noches
      const checkin = reserva.checkinReal || reserva.checkinPrevisto;
      const checkout = reserva.checkoutReal || reserva.checkoutPrevisto;
      const numeroNoches = Math.ceil(
        (new Date(checkout).getTime() - new Date(checkin).getTime()) /
          (1000 * 60 * 60 * 24),
      );

      // Preparar arreglo de detalles
      const detalles: Partial<DetalleFactura>[] = [];

      // 1. Línea por habitación
      const subtotalHabitacion =
        numeroNoches * Number(reserva.precioNocheSnapshot);
      const formatCheckin = new Date(checkin).toLocaleDateString('es-CO');
      const formatCheckout = new Date(checkout).toLocaleDateString('es-CO');

      detalles.push({
        tipoConcepto: 'habitacion',
        descripcion: `Habitación ${reserva.habitacion?.numeroHabitacion || 'N/A'} - ${numeroNoches} noche(s) (${formatCheckin} al ${formatCheckout})`,
        cantidad: numeroNoches,
        precioUnitario: Number(reserva.precioNocheSnapshot),
        subtotal: subtotalHabitacion,
        descuento: 0,
        total: subtotalHabitacion,
        idReferencia: reserva.idHabitacion,
      });

      // 2. Líneas por servicios entregados (con INC para alcohólicos)
      const pedidosEntregados = await this.pedidoRepository.find({
        where: {
          idReserva: reserva.id,
          estadoPedido: 'entregado',
        },
        relations: ['items'],
      });

      // Cargar información de servicios para detectar alcohólicos
      const idsServicios = new Set<number>();
      for (const pedido of pedidosEntregados) {
        for (const item of pedido.items) {
          idsServicios.add(item.idServicio);
        }
      }

      const serviciosMap = new Map<number, Servicio>();
      if (idsServicios.size > 0) {
        const servicios = await this.servicioRepository.findByIds(Array.from(idsServicios));
        servicios.forEach(s => serviciosMap.set(s.id, s));
      }

      // Procesar items con detección de INC
      for (const pedido of pedidosEntregados) {
        for (const item of pedido.items) {
          const subtotalServicio =
            Number(item.cantidad) * Number(item.precioUnitarioSnapshot);
          
          const servicio = serviciosMap.get(item.idServicio);
          const esAlcoholico = servicio?.esAlcoholico || false;
          const porcentajeInc = esAlcoholico ? 8 : undefined; // INC 8% solo para alcohólicos
          const montoInc = esAlcoholico ? (subtotalServicio * 0.08) : 0;

          detalles.push({
            tipoConcepto: esAlcoholico ? 'servicio_alcoholico' : 'servicio',
            descripcion: `${item.nombreServicioSnapshot} (${new Date(pedido.fechaPedido).toLocaleDateString('es-CO')})`,
            cantidad: item.cantidad,
            precioUnitario: Number(item.precioUnitarioSnapshot),
            subtotal: subtotalServicio,
            descuento: 0,
            total: subtotalServicio,
            porcentajeInc,
            montoInc,
            idReferencia: item.id,
          });
        }
      }

      // 3. Calcular totales (subtotal + INC + IVA)
      const subtotal = detalles.reduce((sum, d) => sum + Number(d.total), 0);
      const montoInc = detalles.reduce((sum, d) => sum + (d.montoInc || 0), 0);
      const subtotalConInc = subtotal + montoInc; // Base gravable para IVA
      const porcentajeIva = 19; // IVA estándar Colombia
      const montoIva = subtotalConInc * (porcentajeIva / 100);
      const total = subtotalConInc + montoIva;

      // 4. Crear factura
      const factura = new Factura();
      factura.numeroFactura = numeroFactura;
      factura.uuid = randomUUID();
      factura.idReserva = reserva.id;
      factura.idCliente = reserva.idCliente;
      factura.nombreCliente = reserva.nombreCliente;
      factura.cedulaCliente = reserva.cedulaCliente;
      factura.emailCliente = reserva.emailCliente;
      factura.idHotel = reserva.idHotel;
      factura.subtotal = subtotal;
      factura.montoInc = montoInc;
      factura.porcentajeInc = montoInc > 0 ? 8 : undefined; // 8% INC si hay items alcohólicos
      factura.porcentajeIva = porcentajeIva;
      factura.montoIva = montoIva;
      factura.total = total;
      factura.estado = 'pendiente';
      factura.observaciones = '';
      factura.fechaEmision = new Date();
      
      // Preparar datos JSON (simulado)
      factura.jsonData = JSON.stringify({
        numeroFactura,
        uuid: factura.uuid,
        cliente: {
          nombre: reserva.nombreCliente,
          cedula: reserva.cedulaCliente,
          email: reserva.emailCliente,
        },
        detalles,
        montos: { 
          subtotal, 
          montoInc,
          porcentajeIncAplicado: montoInc > 0 ? 8 : null,
          porcentajeIva, 
          montoIva, 
          total 
        },
        fechaEmision: new Date().toISOString(),
      });
      
      // Preparar datos XML (simulado para preparación DIAN)
      factura.xmlData = this.construirXmlUBL(numeroFactura, factura.uuid, reserva, detalles, { subtotal, porcentajeIva, montoIva, total });

      // 5. Guardar factura y detalles
      const facturaGuardada = await queryRunner.manager.save(factura);

      const detallesConFactura = detalles.map((d) => ({
        ...d,
        idFactura: facturaGuardada.id,
      }));

      await queryRunner.manager.save(DetalleFactura, detallesConFactura);

      // Recargar factura con detalles
      const facturaCompleta = await queryRunner.manager.findOne(Factura, {
        where: { id: facturaGuardada.id },
        relations: ['detalles'],
      });

      // Solo hacer commit si fue nuestra transacción
      if (debeIniciarTransaccion) {
        await queryRunner.commitTransaction();
      }

      return facturaCompleta || new Factura();
    } catch (error) {
      // Solo hacer rollback si fue nuestra transacción
      if (debeIniciarTransaccion) {
        await queryRunner.rollbackTransaction();
      }
      throw error;
    } finally {
      // Solo liberar si fue nuestro queryRunner
      if (debeIniciarTransaccion) {
        await queryRunner.release();
      }
    }
  }

  /**
   * Obtener todas las facturas con filtros opcionales
   */
  async findAll(filters?: {
    idHotel?: number;
    estado?: string;
    idCliente?: number;
  }): Promise<Factura[]> {
    let query = this.facturaRepository.createQueryBuilder('f');

    if (filters?.idHotel) {
      query = query.where('f.idHotel = :idHotel', { idHotel: filters.idHotel });
    }

    if (filters?.estado) {
      if (filters?.idHotel) {
        query = query.andWhere('f.estado = :estado', { estado: filters.estado });
      } else {
        query = query.where('f.estado = :estado', { estado: filters.estado });
      }
    }

    if (filters?.idCliente) {
      if (filters?.idHotel || filters?.estado) {
        query = query.andWhere('f.idCliente = :idCliente', { idCliente: filters.idCliente });
      } else {
        query = query.where('f.idCliente = :idCliente', { idCliente: filters.idCliente });
      }
    }

    query = query.leftJoinAndSelect('f.detalles', 'detalles');
    query = query.leftJoinAndSelect('f.pagos', 'pagos');
    query = query.leftJoinAndSelect('f.reserva', 'reserva');
    query = query.orderBy('f.createdAt', 'DESC');

    return query.getMany();
  }

  /**
   * Obtener una factura por ID
   */
  async findOne(id: number): Promise<Factura> {
    const factura = await this.facturaRepository.findOne({
      where: { id },
      relations: ['detalles', 'pagos', 'reserva'],
    });

    if (!factura) {
      throw new NotFoundException(`Factura con ID ${id} no encontrada`);
    }

    return factura;
  }

  /**
   * Obtener factura por ID de reserva
   */
  async findByReserva(idReserva: number): Promise<Factura> {
    const factura = await this.facturaRepository.findOne({
      where: { idReserva },
      relations: ['detalles', 'pagos', 'reserva'],
    });

    if (!factura) {
      throw new NotFoundException(
        `No se encontró factura para la reserva ${idReserva}`,
      );
    }

    return factura;
  }

  /**
   * Obtener todas las facturas de un cliente
   */
  async findByCliente(idCliente: number): Promise<Factura[]> {
    return this.facturaRepository.find({
      where: { idCliente },
      relations: ['detalles', 'pagos', 'reserva'],
      order: { createdAt: 'DESC' },
    });
  }

  /**
   * Obtener todas las facturas de un cliente filtradas por hotel
   */
  async findByClienteAndHotel(
    idCliente: number,
    idHotel: number,
  ): Promise<Factura[]> {
    return this.facturaRepository.find({
      where: { idCliente, idHotel },
      relations: ['detalles', 'pagos', 'reserva'],
      order: { createdAt: 'DESC' },
    });
  }

  /**
   * Emitir factura (cambiar estado a 'emitida')
   */
  async emitir(id: number): Promise<Factura> {
    const factura = await this.findOne(id);

    if (!['pendiente', 'pagada'].includes(factura.estado)) {
      throw new BadRequestException(
        `No se puede emitir una factura en estado ${factura.estado}`,
      );
    }

    factura.estado = 'emitida';
    factura.fechaEmision = new Date();
    factura.fechaVencimiento = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000); // 30 días

    return this.facturaRepository.save(factura);
  }

  /**
   * Anular factura
   */
  async anular(id: number, motivo: string): Promise<Factura> {
    const factura = await this.findOne(id);

    // No se puede anular si ya tiene pagos completados
    const pagosCompletados = factura.pagos?.filter(
      (p) => p.estado === 'completado',
    );

    if (pagosCompletados && pagosCompletados.length > 0) {
      throw new BadRequestException(
        'No se puede anular una factura que ya tiene pagos registrados',
      );
    }

    factura.estado = 'anulada';
    factura.observaciones = `ANULADA: ${motivo}`;

    return this.facturaRepository.save(factura);
  }

  /**
   * Actualizar factura (datos globales, no detalles)
   */
  async update(id: number, dto: UpdateFacturaDto): Promise<Factura> {
    const factura = await this.findOne(id);

    if (dto.estado) {
      factura.estado = dto.estado;
    }
    if (dto.observaciones) {
      factura.observaciones = dto.observaciones;
    }
    if (dto.cufe) {
      factura.cufe = dto.cufe;
    }

    return this.facturaRepository.save(factura);
  }

  /**
   * Construir XML en formato UBL 2.1 (simulado para preparación DIAN)
   * Nota: Esta es una simulación. La DIAN requiere firma digital y validación específica.
   */
  private construirXmlUBL(
    numeroFactura: string,
    uuid: string,
    reserva: Reserva,
    detalles: Partial<any>[],
    montos: { subtotal: number; porcentajeIva: number; montoIva: number; total: number },
  ): string {
    const fecha = new Date().toISOString().split('T')[0];
    const hora = new Date().toISOString().split('T')[1].split('.')[0];

    // Formatear número de factura con serie
    const seriePrefix = 'FV'; // FV = Factura de Venta
    const numeroFormateado = `${seriePrefix}-${String(numeroFactura).padStart(8, '0')}`;

    const detallesXml = detalles
      .map(
        (d, idx) => `
    <cac:InvoiceLine>
      <cbc:ID>${idx + 1}</cbc:ID>
      <cbc:InvoicedQuantity unitCode="EA">${d.cantidad}</cbc:InvoicedQuantity>
      <cbc:LineExtensionAmount currencyID="COP">${Number(d.total).toFixed(2)}</cbc:LineExtensionAmount>
      <cac:Item>
        <cbc:Description>${d.descripcion || 'Servicio de hospedaje'}</cbc:Description>
      </cac:Item>
      <cac:Price>
        <cbc:PriceAmount currencyID="COP">${Number(d.precioUnitario).toFixed(2)}</cbc:PriceAmount>
      </cac:Price>
    </cac:InvoiceLine>`,
      )
      .join('\n');

    return `<?xml version="1.0" encoding="UTF-8"?>
<Invoice xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
         xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
         xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
         xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">
  <!-- METADATOS DIAN -->
  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>
  <cbc:CustomizationID>05</cbc:CustomizationID>
  <cbc:ProfileID>dian</cbc:ProfileID>
  <cbc:ID>${numeroFormateado}</cbc:ID>
  <cbc:UUID>${uuid}</cbc:UUID>
  <cbc:IssueDate>${fecha}</cbc:IssueDate>
  <cbc:IssueTime>${hora}</cbc:IssueTime>
  <cbc:InvoiceTypeCode listID="DIAN 1.0">01</cbc:InvoiceTypeCode>
  <cbc:DocumentCurrencyCode>COP</cbc:DocumentCurrencyCode>
  
  <!-- PERÍODO -->
  <cac:InvoicePeriod>
    <cbc:StartDate>${fecha}</cbc:StartDate>
    <cbc:EndDate>${fecha}</cbc:EndDate>
  </cac:InvoicePeriod>
  
  <!-- REFERENCIA A ORDEN -->
  <cac:OrderReference>
    <cbc:ID>${numeroFormateado}</cbc:ID>
  </cac:OrderReference>
  
  <!-- PROVEEDOR (Hotel Sena) -->
  <cac:AccountingSupplierParty>
    <cac:Party>
      <cbc:Name>HOTEL SENA 2026</cbc:Name>
      <cac:PartyIdentification>
        <cbc:ID schemeID="NIT">9001234567-1</cbc:ID>
      </cac:PartyIdentification>
      <cac:PostalAddress>
        <cbc:StreetName>Carrera 5 No. 26-50</cbc:StreetName>
        <cbc:CityName>Bogotá</cbc:CityName>
        <cbc:CountrySubentity>Bogotá D.C.</cbc:CountrySubentity>
        <cac:Country>
          <cbc:IdentificationCode>CO</cbc:IdentificationCode>
        </cac:Country>
      </cac:PostalAddress>
      <cac:PartyTaxScheme>
        <cbc:RegistrationName>HOTEL SENA 2026</cbc:RegistrationName>
        <cbc:CompanyID schemeID="NIT">9001234567-1</cbc:CompanyID>
        <cbc:TaxTypeCode>01</cbc:TaxTypeCode>
        <cac:TaxScheme>
          <cbc:ID>01</cbc:ID>
          <cbc:Name>IVA</cbc:Name>
        </cac:TaxScheme>
      </cac:PartyTaxScheme>
    </cac:Party>
  </cac:AccountingSupplierParty>
  
  <!-- CLIENTE (Huésped) -->
  <cac:AccountingCustomerParty>
    <cac:Party>
      <cbc:Name>${reserva.nombreCliente}</cbc:Name>
      <cac:PartyIdentification>
        <cbc:ID schemeID="CC">${reserva.cedulaCliente}</cbc:ID>
      </cac:PartyIdentification>
      <cac:Contact>
        <cbc:ElectronicMail>${reserva.emailCliente}</cbc:ElectronicMail>
      </cac:Contact>
    </cac:Party>
  </cac:AccountingCustomerParty>
  
  <!-- TOTALES IMPUESTOS -->
  <cac:TaxTotal>
    <cbc:TaxAmount currencyID="COP">${Number(montos.montoIva).toFixed(2)}</cbc:TaxAmount>
    <cac:TaxSubtotal>
      <cbc:TaxableAmount currencyID="COP">${Number(montos.subtotal).toFixed(2)}</cbc:TaxableAmount>
      <cbc:TaxAmount currencyID="COP">${Number(montos.montoIva).toFixed(2)}</cbc:TaxAmount>
      <cbc:CalculationSequenceNumeric>1</cbc:CalculationSequenceNumeric>
      <cac:TaxCategory>
        <cbc:ID>S</cbc:ID>
        <cbc:Name>IVA</cbc:Name>
        <cbc:Percent>${montos.porcentajeIva}</cbc:Percent>
        <cbc:TaxExemptionReasonCode>VAT_EXEMPT</cbc:TaxExemptionReasonCode>
        <cac:TaxScheme>
          <cbc:ID>01</cbc:ID>
          <cbc:Name>IVA</cbc:Name>
        </cac:TaxScheme>
      </cac:TaxCategory>
    </cac:TaxSubtotal>
  </cac:TaxTotal>
  
  <!-- TOTALES MONETARIOS -->
  <cac:LegalMonetaryTotal>
    <cbc:LineExtensionAmount currencyID="COP">${Number(montos.subtotal).toFixed(2)}</cbc:LineExtensionAmount>
    <cbc:TaxExclusiveAmount currencyID="COP">${Number(montos.subtotal).toFixed(2)}</cbc:TaxExclusiveAmount>
    <cbc:TaxInclusiveAmount currencyID="COP">${Number(montos.total).toFixed(2)}</cbc:TaxInclusiveAmount>
    <cbc:PrepaidAmount currencyID="COP">0.00</cbc:PrepaidAmount>
    <cbc:PayableAmount currencyID="COP">${Number(montos.total).toFixed(2)}</cbc:PayableAmount>
  </cac:LegalMonetaryTotal>
  
  <!-- LÍNEAS DE FACTURA -->
  ${detallesXml}
  
  <!-- NOTAS -->
  <cbc:Note>Documento generado electrónicamente según resolución DIAN</cbc:Note>
  <cbc:Note>⚠️ DOCUMENTO SIMULADO - No es válido fiscalmente sin Firma Digital XMLDSIG y certificado DIAN</cbc:Note>
</Invoice>`;
  }
}

