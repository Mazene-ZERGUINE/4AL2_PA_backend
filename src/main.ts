import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { corsConfig } from './core/config/cors.config';
import { validationPipeOptions } from './core/config/validation-pipe.config';
import { GlobalExceptionHandler } from './core/middleware/GlobalExceptionHandler';

async function bootstrap(): Promise<void> {
	const app = await NestFactory.create(AppModule);
	app.setGlobalPrefix('api/v1');
	app.enableCors(corsConfig);
	app.useGlobalPipes(new ValidationPipe(validationPipeOptions));
	app.useGlobalFilters(new GlobalExceptionHandler());
	await app.listen(3000);
}

bootstrap().then(() => console.log('🚀 server is running on port 3000'));
