import { Injectable } from '@nestjs/common';
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

@Injectable()
export class CodeProcessorService {
	private readonly codeInputPath: string;
	private readonly codeOutputPath: string;
	private readonly outpuUploadPath = join(
		__dirname,
		'../../../../',
		'uploads',
		'code',
		'output',
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

	async checkTaskStatus(
		taskId: string,
	): Promise<CodeResultsResponseDto | CodeWithFileExecutedResponseDto> {
		for (let i = 0; i < 2; i++) {
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

	async runCodeWithFile(
		file: Express.Multer.File,
		processFileDto: ProcessFileRequestDto,
	): Promise<any> {
		const files = this.processFilePath(file.filename);
		const payload: ExecuteCodeWithFileDto = {
			source_code: processFileDto.sourceCode,
			file_paths: {
				input_file_path: files.inputFilePath,
				output_file_path: files.outputFilePath,
			},
			programming_language: processFileDto.programmingLanguage,
			file_output_fromat: processFileDto.outputFormat,
		};
		const response: CodeExecutedResponseDto = await this.httpService.post(
			'file/execute',
			payload,
		);
		const taskResult: CodeWithFileExecutedResponseDto = (await this.checkTaskStatus(
			response.task_id,
		)) as CodeWithFileExecutedResponseDto;

		if (taskResult.result.stderr || taskResult.result.output_file_path === null) {
			return taskResult;
		}

		let newFilePath = await this.httpService.downloadFile(
			taskResult.result.output_file_path,
			this.outpuUploadPath,
		);
		const pathSegments = newFilePath.split('/');
		newFilePath = `${this.codeOutputPath}/${pathSegments[pathSegments.length - 1]}`;
		taskResult.result.output_file_path = newFilePath;
		return taskResult;
	}

	private processFilePath(fileName: string): {
		inputFilePath: string;
		outputFilePath: string;
	} {
		return {
			inputFilePath: this.codeInputPath + '/' + fileName,
			outputFilePath: this.codeOutputPath + '/' + fileName,
		};
	}
}
