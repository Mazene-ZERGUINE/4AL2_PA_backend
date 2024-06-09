import { Module } from '@nestjs/common';
import { CodeProcessingControllerController } from './controllers/code-prossessing-controller.controller';
import { CodeProcessorService } from './services/code-processor.service';
import { HttpService } from './services/http.service';
import { FilesHandlerUtils } from './utils/files-handler.utils';

@Module({
	controllers: [CodeProcessingControllerController],
	providers: [CodeProcessorService, HttpService, FilesHandlerUtils],
})
export class CodeProcessorModule {}
