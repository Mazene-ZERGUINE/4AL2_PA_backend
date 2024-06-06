import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { HttpService } from './http.service';
import { CodeResultsResponseDto } from '../dtos/response/code-results-response.dto';
import { CodeExecutedResponseDto } from '../dtos/response/code-executed-response.dto';
import { ProgrammingLanguage } from '../enums/ProgrammingLanguage';
import { TimeoutException } from '../../../core/exceptions/TimeoutException';
import { ProcessFileRequestDto } from '../dtos/request/process-file-request.dto';
import { ConfigService } from '@nestjs/config';
import { Express } from 'express';
import { ExecuteCodeWithFileDto } from '../dtos/request/execute-code-with-file.dto';
import { CodeWithFileExecutedResponseDto } from '../dtos/response/code-with-file-executed-response.dto';
import { join } from 'path';
import { FilesHandlerUtils } from '../utils/files-handler.utils';
import * as path from 'node:path';

@Injectable()
export class CodeProcessorService {
	private readonly codeInputPath: string;
	private readonly codeOutputPath: string;
	private inputFileUploadPath: string;
	private readonly outpuUploadPath = join(
		__dirname,
		'../../../../',
		'uploads',
		'code',
		'output',
	);
	private readonly inputUploadPath = path.join(
		__dirname,
		'../../../../',
		'uploads',
		'code',
		'input',
	);

	constructor(private httpService: HttpService, configService: ConfigService) {
		this.codeInputPath = configService.get('STATIC_INPUT_CODE_URL');
		this.codeOutputPath = configService.get('STATIC_OUTPUT_CODE_URL');
	}

	async runCode(
		sourceCode: string,
		programmingLanguage: ProgrammingLanguage,
	): Promise<CodeResultsResponseDto> {
		const data = {
			programming_language: programmingLanguage,
			source_code: sourceCode,
		};
		const response: CodeExecutedResponseDto = await this.httpService.post(
			'execute/',
			data,
		);
		const taskResult = await this.checkTaskStatus(response.task_id);
		return taskResult as CodeResultsResponseDto;
	}

	async runCodeWithFile(
		file: Express.Multer.File,
		processFileDto: ProcessFileRequestDto,
	): Promise<any> {
		try {
			const { inputFilePath, outputFilePath } = FilesHandlerUtils.processFilePath(
				file.filename,
				this.codeInputPath,
				this.codeOutputPath,
			);
			this.inputFileUploadPath = this.inputUploadPath + '/' + file.filename;
			const payload: ExecuteCodeWithFileDto = {
				source_code: processFileDto.sourceCode,
				file_paths: {
					input_file_path: inputFilePath,
					output_file_path: outputFilePath,
				},
				programming_language: processFileDto.programmingLanguage,
				file_output_fromat: processFileDto.outputFormat,
			};

			const response: CodeExecutedResponseDto = await this.httpService.post(
				'file/execute',
				payload,
			);
			if (!response.task_id) {
				throw new InternalServerErrorException(
					'Failed to create celery task to execute the code',
				);
			}

			const taskResult: CodeWithFileExecutedResponseDto = (await this.checkTaskStatus(
				response.task_id,
			)) as CodeWithFileExecutedResponseDto;
			if (taskResult.result.stderr || !taskResult.result.output_file_path) {
				return taskResult;
			}

			let newFilePath = await this.httpService.downloadFile(
				taskResult.result.output_file_path,
				this.outpuUploadPath,
			);
			if (!newFilePath) {
				throw new InternalServerErrorException('Failed to download output result file');
			}

			const pathSegments = newFilePath.split('/');
			const newFileName = pathSegments[pathSegments.length - 1];
			newFilePath = `${this.codeOutputPath}/${newFileName}`;
			const deleteFileUrl = `file/delete?file=${newFileName}`;
			const deleteResult = await this.httpService.delete<{
				status: number;
				success: boolean;
			}>(deleteFileUrl);
			if (deleteResult.status !== 200 || !deleteResult.success) {
				throw new InternalServerErrorException('Failed to delete the file');
			}
			taskResult.result.output_file_path = newFilePath;

			return taskResult;
		} catch (error: unknown) {
			throw new InternalServerErrorException(error);
		} finally {
			FilesHandlerUtils.removeTmpFiles(this.inputFileUploadPath);
		}
	}

	private async checkTaskStatus(
		taskId: string,
	): Promise<CodeResultsResponseDto | CodeWithFileExecutedResponseDto> {
		for (let i = 0; i < 5; i++) {
			const taskResult = await this.httpService.get<CodeResultsResponseDto>(
				`result/${taskId}`,
			);
			if (taskResult.status !== 'Pending') {
				return taskResult;
			}
			await new Promise((resolve) => setTimeout(resolve, 2000));
		}
		throw new TimeoutException('request timeout');
	}
}
