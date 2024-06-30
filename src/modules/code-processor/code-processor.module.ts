import { Module } from '@nestjs/common';
import { CodeProcessingControllerController } from './controllers/code-prossessing-controller.controller';
import { CodeProcessorService } from './services/code-processor.service';
import { HttpService } from './services/http.service';
import { FilesHandlerUtils } from './utils/files-handler.utils';
import { CollaboratifCodingController } from './controllers/collaboratif-coding.controller';

@Module({
	controllers: [CodeProcessingControllerController, CollaboratifCodingController],
	providers: [CodeProcessorService, HttpService, FilesHandlerUtils],
})
export class CodeProcessorModule {}
