// src/app.module.ts
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { createTypeOrmConfig } from './core/database/typeorm.config';
import { CoreModule } from './core/core.module';
import { AuthModule } from './modules/auth/auth.module';
import { CodeProcessorModule } from './modules/code-processor/code-processor.module';
import { DatabaseSeedModule } from './modules/database-seed/database-seed.module';
import { SocialMediaModule } from './modules/social-media/social-media.module';
import { ServeStaticModule } from '@nestjs/serve-static';
import { join } from 'path';

@Module({
	imports: [
		CoreModule,
		AuthModule,
		DatabaseSeedModule,
		SocialMediaModule,
		CodeProcessorModule,
		ConfigModule.forRoot({
			envFilePath: `.env.${process.env.NODE_ENV}`,
			isGlobal: true,
		}),
		TypeOrmModule.forRootAsync({
			imports: [ConfigModule],
			inject: [ConfigService],
			useFactory: createTypeOrmConfig,
		}),
		ServeStaticModule.forRoot({
			rootPath: join(__dirname, '..', 'uploads', 'avatars'),
			serveRoot: '/uploads/avatars',
		}),
	],
})
export class AppModule {}
