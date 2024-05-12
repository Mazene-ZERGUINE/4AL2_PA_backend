import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { corsConfig } from './core/config/cors.config';
import { validationPipeOptions } from './core/config/validation-pipe.config';
import { GlobalExceptionHandler } from './core/middleware/GlobalExceptionHandler';
import { DocumentBuilder, SwaggerDocumentOptions, SwaggerModule } from '@nestjs/swagger';
import { DatabaseSeedService } from './modules/database-seed/database-seed.service';

(async function bootstrap(): Promise<void> {
	const app = await NestFactory.create(AppModule);
	app.setGlobalPrefix('api/v1');
	app.enableCors(corsConfig);
	app.useGlobalPipes(new ValidationPipe(validationPipeOptions));
	app.useGlobalFilters(new GlobalExceptionHandler());

	addSwagger(app);

	if (process.env.SEED_DATABASE === 'true') {
		await app.get(DatabaseSeedService).seed();
	}

	await app.listen(3000);
})()
	// eslint-disable-next-line no-console
	.then(() => console.log('🚀 Server is running'))
	// eslint-disable-next-line no-console
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
