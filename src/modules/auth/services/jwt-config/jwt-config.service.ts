import { Injectable } from '@nestjs/common';
import { JwtModuleOptions, JwtOptionsFactory } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtConfigService implements JwtOptionsFactory {
	constructor(private readonly configService: ConfigService) {}

	createJwtOptions(): JwtModuleOptions {
		const oneHourInSeconds = '3600s';
		const secret = this.configService.get<string>('JWT_SECRET');
		if (!secret) {
			throw new Error('JWT_SECRET manquant !');
		}

		return {
			secret,
			secretOrPrivateKey: secret,
			signOptions: {
				expiresIn: this.configService.get('JWT_EXPIRATION_TIME', oneHourInSeconds),
			},
		};
	}
}
