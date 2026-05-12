import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { applyPercentageAdjustment, roundMoney } from '../utils/money.util';

export interface IpcAdjustmentConfig {
  annualPercent: number;
  referencePeriod?: string;
  sourceUrl?: string;
  updatedAt?: string;
}

@Injectable()
export class RateAdjustmentService {
  constructor(private readonly configService: ConfigService) {}

  getCurrentIpcAdjustment(): IpcAdjustmentConfig {
    const rawPercent = this.configService.get<string>('DANE_IPC_ANNUAL_PERCENT');
    const annualPercent = Number(rawPercent ?? 0);

    return {
      annualPercent: Number.isFinite(annualPercent) ? annualPercent : 0,
      referencePeriod: this.configService.get<string>('DANE_IPC_REFERENCE_PERIOD'),
      sourceUrl: this.configService.get<string>('DANE_IPC_SOURCE_URL'),
      updatedAt: this.configService.get<string>('DANE_IPC_UPDATED_AT'),
    };
  }

  applyIpcAdjustment(amount: unknown, overridePercent?: number): number {
    const percent = overridePercent ?? this.getCurrentIpcAdjustment().annualPercent;
    return applyPercentageAdjustment(amount, percent);
  }

  normalizeCurrency(amount: unknown): number {
    return roundMoney(amount);
  }
}
