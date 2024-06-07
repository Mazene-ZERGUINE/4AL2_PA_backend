import {
	BadRequestException,
	Body,
	Controller,
	HttpCode,
	Post,
	UploadedFile,
	UseGuards,
	UseInterceptors,
} from '@nestjs/common';
import { ProcessCodeRequestDto } from '../dtos/request/process-code-request.dto';
import { CodeProcessorService } from '../services/code-processor.service';
import { CodeResultsResponseDto } from '../dtos/response/code-results-response.dto';
import {
	ApiBadRequestResponse,
	ApiConsumes,
	ApiOkResponse,
	ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { ThrottlerGuard } from '@nestjs/throttler';
import { codeExecutionsMulterOption } from '../../../core/middleware/multer.config';
import { FileInterceptor } from '@nestjs/platform-express';
import { ProcessFileRequestDto } from '../dtos/request/process-file-request.dto';
import { Express } from 'express';

@UseGuards(ThrottlerGuard)
@Controller('/code-processor')
@ApiTags('Code processor')
export class CodeProcessingControllerController {
	constructor(private readonly codeProcessorService: CodeProcessorService) {}

	@UseGuards(JwtAuthGuard)
	@Post('/run-code')
	@HttpCode(200)
	@ApiOkResponse({
		description: '✅ Code processed successfully',
		type: CodeResultsResponseDto,
	})
	@ApiBadRequestResponse({
		description: '❌ Language/code should be provided/correct',
	})
	async processCode(
		@Body() payload: ProcessCodeRequestDto,
	): Promise<CodeResultsResponseDto> {
		return await this.codeProcessorService.runCode(
			payload.sourceCode,
			payload.programmingLanguage,
		);
	}

	@UseGuards(JwtAuthGuard)
	@UseGuards(ThrottlerGuard)
	@Post('file/run-code')
	@HttpCode(200)
	@ApiOkResponse({
		description: '✅ Code processed successfully',
		type: CodeResultsResponseDto,
	})
	@ApiBadRequestResponse({
		description: '❌ Language/code should be provided/correct',
	})
	@ApiBadRequestResponse({
		description: '❌ no file was provided',
	})
	@UseInterceptors(FileInterceptor('file', codeExecutionsMulterOption))
	@ApiConsumes('multipart/form-data')
	async processCodeWithFile(
		@Body() payload: ProcessFileRequestDto,
		@UploadedFile() file: Express.Multer.File,
	): Promise<any> {
		if (file === undefined && file === null)
			throw new BadRequestException('no file was provided');
		return await this.codeProcessorService.runCodeWithFile(file, payload);
	}
}
