import { Body, Controller, Post, HttpCode } from '@nestjs/common';
import { ProcessCodeRequestDto } from '../dtos/request/ProcessCodeRequestDto';
import { CodeProcessorService } from '../services/code-processor.service';
import { CodeResultsResponseDto } from '../dtos/response/CodeResultsResponseDto';

@Controller('/code-processor')
export class CodeProcessingControllerController {
	constructor(private readonly codeProcessorService: CodeProcessorService) {}
	@Post('/run-code')
	@HttpCode(200)
	async processCode(
		@Body() payload: ProcessCodeRequestDto,
	): Promise<CodeResultsResponseDto> {
		const output = await this.codeProcessorService.runCode(
			payload.sourceCode,
			payload.programmingLanguage,
		);
		return output;
	}
}
