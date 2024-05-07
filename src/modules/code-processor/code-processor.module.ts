import { Module } from '@nestjs/common';
import { CodeProcessingControllerController } from './controllers/code-prossessing-controller.controller';
import { CodeProcessorService } from './services/code-processor.service';
import { HttpService } from './services/http.service';

@Module({
	controllers: [CodeProcessingControllerController],
	providers: [CodeProcessorService, HttpService],
})
export class CodeProcessorModule {}
