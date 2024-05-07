import { Injectable } from '@nestjs/common';
import { HttpService } from './http.service';
import { CodeResultsResponseDto } from '../dtos/response/CodeResultsResponseDto';
import { CodeExecutedResponse } from '../dtos/response/CodeExecutedResponse';
import { ProgrammingLanguage } from '../enums/ProgrammingLanguage';
import { TimeoutException } from '../../../core/exceptions/TimeoutException';

@Injectable()
export class CodeProcessorService {
	constructor(private httpService: HttpService) {}

	async runCode(
		sourceCode: string,
		programmingLanguage: ProgrammingLanguage,
	): Promise<CodeResultsResponseDto> {
		const data = {
			programming_language: programmingLanguage,
			source_code: sourceCode,
		};
		const response: CodeExecutedResponse = await this.httpService.post('execute/', data);
		const taskResult = await this.checkTaskStatus(response.task_id);
		return taskResult;
	}

	async checkTaskStatus(taskId: string): Promise<CodeResultsResponseDto> {
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
}
