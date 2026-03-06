import { Injectable, BadRequestException } from '@nestjs/common';
import { v2 as cloudinary } from 'cloudinary';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class CloudinaryService {
  private readonly defaultFolder: string;

  constructor(private readonly configService: ConfigService) {
    cloudinary.config({
      cloud_name: this.configService.get<string>('CLOUDINARY_CLOUD_NAME'),
      api_key: this.configService.get<string>('CLOUDINARY_API_KEY'),
      api_secret: this.configService.get<string>('CLOUDINARY_API_SECRET'),
    });
    this.defaultFolder = this.configService.get<string>('CLOUDINARY_FOLDER_NAME', 'imghotel');
  }

  async uploadImage(file: Express.Multer.File, folder?: string): Promise<string> {
    const uploadFolder = folder || this.defaultFolder;
    if (!file) {
      throw new BadRequestException('No se proporcionó archivo');
    }

    return new Promise((resolve, reject) => {
      const upload = cloudinary.uploader.upload_stream(
        {
          folder: uploadFolder,
          resource_type: 'auto',
        },
        (error, result) => {
          if (error) {
            reject(new BadRequestException(`Error al subir archivo a Cloudinary: ${error.message}`));
          } else if (result) {
            resolve(result.secure_url);
          } else {
            reject(new BadRequestException('Error desconocido al subir archivo'));
          }
        },
      );

      upload.end(file.buffer);
    });
  }

  async uploadMultipleImages(
    files: Express.Multer.File[],
    folder?: string,
  ): Promise<string[]> {
    if (!files || files.length === 0) {
      return [];
    }

    const uploadPromises = files.map((file) => this.uploadImage(file, folder));
    return Promise.all(uploadPromises);
  }
}
