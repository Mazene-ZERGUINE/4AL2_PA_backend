import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';

export function createTypeOrmConfig(configService: ConfigService): TypeOrmModuleOptions {
	return {
		type: 'postgres',
		host: configService.get<string>('DATABASE_HOST'),
		port: configService.get<number>('DATABASE_PORT', 5432),
		username: configService.get<string>('DATABASE_USER'),
		password: configService.get<string>('DATABASE_PASSWORD'),
		database: configService.get<string>('DATABASE_NAME'),
		entities: [__dirname + '/../../**/*.entity.{js,ts}'],
		synchronize: configService.get<boolean>('TYPEORM_SYNC', true), // désactiver en prod //
	};
}
