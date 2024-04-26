// src/app.module.ts
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { createTypeOrmConfig } from './core/database/typeorm.config';
import { CoreModule } from './core/core.module';
import { AuthModule } from './modules/auth/auth.module';
import { CodeProcessorModule } from './modules/code-processor/code-processor.module';
import { SocialMediaModule } from './modules/social-media/social-media.module';

@Module({
	imports: [
		CoreModule,
		AuthModule,
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
	],
})
export class AppModule {}
