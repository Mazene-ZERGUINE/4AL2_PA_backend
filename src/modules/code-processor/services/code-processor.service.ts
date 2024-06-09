import {
	BadRequestException,
	Injectable,
	InternalServerErrorException,
} from '@nestjs/common';
import { HttpService } from './http.service';
import { CodeResultsResponseDto } from '../dtos/response/code-results-response.dto';
import { CodeExecutedResponseDto } from '../dtos/response/code-executed-response.dto';
import { ProgrammingLanguage } from '../enums/ProgrammingLanguage';
import { TimeoutException } from '../../../core/exceptions/TimeoutException';
import { ProcessFileRequestDto } from '../dtos/request/process-file-request.dto';
import { Express } from 'express';
import { CodeWithFileExecutedResponseDto } from '../dtos/response/code-with-file-executed-response.dto';
import { FilesHandlerUtils } from '../utils/files-handler.utils';
import { ExecuteCodeWithFileDto } from '../dtos/request/execute-code-with-file.dto';

@Injectable()
export class CodeProcessorService {
	constructor(
		private readonly httpService: HttpService,
		private readonly fileUtils: FilesHandlerUtils,
	) {}

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

	async runCodeWithFiles(
		files: Express.Multer.File[],
		processCodeDto: ProcessFileRequestDto,
	): Promise<any> {
		this.validateFiles(files);
		let staticOutputFilePaths: string[] = [];
		try {
			const processFilePaths = this.fileUtils.processFilePath(files);
			const executeCodeWithFilesDto = this.createExecuteCodeWithFileDto(
				processCodeDto,
				processFilePaths,
			);
			const taskCreationRequest = await this.createTask(executeCodeWithFilesDto);
			let taskResult = await this.getTaskResult(taskCreationRequest.task_id);
			taskResult = this.validateTaskResult(taskResult);
			staticOutputFilePaths = await this.downloadAndTransformFiles(
				taskResult.result.output_file_paths,
			);
			await this.deleteOutputFiles(staticOutputFilePaths);
			taskResult.result.output_file_paths = staticOutputFilePaths;
			return taskResult;
		} finally {
			this.cleanupFiles(files);
		}
	}

	private validateFiles(files: Express.Multer.File[]): void {
		if (!files || files.length === 0) {
			throw new BadRequestException('No files were provided');
		}
	}

	private createExecuteCodeWithFileDto(
		processCodeDto: ProcessFileRequestDto,
		processFilePaths: string[],
	): ExecuteCodeWithFileDto {
		return new ExecuteCodeWithFileDto(
			processCodeDto.programmingLanguage,
			processCodeDto.sourceCode,
			processFilePaths,
			processCodeDto.outputFilesFormats,
		);
	}

	private async createTask(
		executeCodeWithFilesDto: ExecuteCodeWithFileDto,
	): Promise<CodeExecutedResponseDto> {
		const taskCreationRequest: CodeExecutedResponseDto = await this.httpService.post(
			'file/execute',
			executeCodeWithFilesDto,
		);

		if (!taskCreationRequest.task_id) {
			throw new InternalServerErrorException(
				'Failed to create new Celery task to execute code',
			);
		}
		return taskCreationRequest;
	}

	private async getTaskResult(taskId: string): Promise<CodeWithFileExecutedResponseDto> {
		const taskResult = await this.checkTaskStatus(taskId);
		return taskResult as CodeWithFileExecutedResponseDto;
	}

	private validateTaskResult(
		taskResult: CodeWithFileExecutedResponseDto,
	): CodeWithFileExecutedResponseDto {
		return taskResult;
	}

	private async downloadAndTransformFiles(outputFilePaths: string[]): Promise<string[]> {
		const staticOutputFilePaths: string[] = [];
		const downloadPromises = outputFilePaths.map(async (filePath) => {
			const newFilePath = await this.httpService.downloadFile(filePath);
			if (!newFilePath) {
				throw new InternalServerErrorException('Failed to download output result file');
			}
			const fileName = this.extractFileName(newFilePath);
			const transformedFilePath = this.fileUtils.transformToStaticFile(fileName);
			staticOutputFilePaths.push(transformedFilePath);
			return transformedFilePath;
		});
		await Promise.all(downloadPromises);
		return staticOutputFilePaths;
	}

	private async deleteOutputFiles(staticOutputFilePaths: string[]): Promise<void> {
		const deletePromises = staticOutputFilePaths.map(async (filePath) => {
			const newFileName = this.extractFileName(filePath);
			const deleteFileUrl = `file/delete?file=${newFileName}`;
			const deleteResult = await this.httpService.delete<{
				status: number;
				success: boolean;
			}>(deleteFileUrl);
			if (deleteResult.status !== 200 || !deleteResult.success) {
				throw new InternalServerErrorException('Failed to delete the file');
			}
		});
		await Promise.all(deletePromises);
	}

	private cleanupFiles(files: Express.Multer.File[]): void {
		files.forEach((file) => {
			this.fileUtils.checkFileIfExists(file.path);
			this.fileUtils.removeTmpFiles(file.path);
		});
	}

	private extractFileName(filePath: string): string {
		const pathSegments = filePath.split('/');
		return pathSegments[pathSegments.length - 1];
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
