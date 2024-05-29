import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { createCorsConfig } from './core/config/cors.config';
import { validationPipeOptions } from './core/config/validation-pipe.config';
import { GlobalExceptionHandler } from './core/middleware/GlobalExceptionHandler';
import { DocumentBuilder, SwaggerDocumentOptions, SwaggerModule } from '@nestjs/swagger';
import { ConfigService } from '@nestjs/config';

(async function bootstrap(): Promise<void> {
	const app = await NestFactory.create(AppModule);
	const configService = app.get(ConfigService);

	app.setGlobalPrefix('api/v1');
	app.enableCors(createCorsConfig(configService));
	app.useGlobalPipes(new ValidationPipe(validationPipeOptions));
	app.useGlobalFilters(new GlobalExceptionHandler());

	addSwagger(app);

	await app.listen(3000);
})()
	.then(() => console.log('🚀 Server is running'))
	.catch((error) => console.error('❌ Error starting server', error));

function addSwagger(app: INestApplication): void {
	const config = new DocumentBuilder()
		.setTitle('Esgithub')
		.setDescription('Esgithub API')
		.setVersion('1.0')
		.build();

	const options: SwaggerDocumentOptions = {
		operationIdFactory: (controllerKey: string, methodKey: string) => methodKey,
	};

	const document = SwaggerModule.createDocument(app, config, options);
	SwaggerModule.setup('api', app, document);
}
