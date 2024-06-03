import { Response } from 'express';
import {
	BadRequestException,
	Body,
	Controller,
	Get,
	HttpCode,
	InternalServerErrorException,
	Post,
	Query,
	Res,
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
	ApiInternalServerErrorResponse,
	ApiOkResponse,
	ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { ThrottlerGuard } from '@nestjs/throttler';
import { codeExecutionsMulterOption } from '../../../core/middleware/multer.config';
import { FileInterceptor } from '@nestjs/platform-express';
import { ProcessFileRequestDto } from '../dtos/request/process-file-request.dto';
import { Express } from 'express';
import { FilesHandlerUtils } from '../utils/files-handler.utils';
import * as path from 'node:path';
import * as fs from 'node:fs';

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

	//@UseGuards(JwtAuthGuard)
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
	async executeCodeWithFile(
		@Body() payload: ProcessFileRequestDto,
		@UploadedFile() file: Express.Multer.File,
	): Promise<any> {
		if (file === undefined && file === null)
			throw new BadRequestException('no file was provided');
		return await this.codeProcessorService.runCodeWithFile(file, payload);
	}

	@UseGuards(ThrottlerGuard)
	//@UseGuards(JwtAuthGuard)
	@Get('/file/output-file')
	@HttpCode(200)
	@ApiOkResponse({
		description: 'download the output file and return 200 http status',
	})
	@ApiInternalServerErrorResponse({
		description:
			'return 500 http error whene erroer occure while downloading the output file',
	})
	async downloadOutputFile(
		@Query('filepath') filePath: string,
		@Res() response: Response,
	): Promise<void> {
		if (FilesHandlerUtils.checkFileIfExists(filePath)) {
			throw new InternalServerErrorException('file path does not exist');
		}
		try {
			response.setHeader(
				'Content-Disposition',
				`attachment; filename=${path.basename(filePath)}`,
			);
			const fileStream = fs.createReadStream(filePath);
			fileStream.pipe(response);
		} catch (error) {
			throw new InternalServerErrorException('Failed to download the file');
		}
	}
}
