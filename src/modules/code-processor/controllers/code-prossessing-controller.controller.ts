import { Body, Controller, HttpCode, Post } from '@nestjs/common';
import { ProcessCodeRequestDto } from '../dtos/request/ProcessCodeRequestDto';
import { CodeProcessorService } from '../services/code-processor.service';
import { CodeResultsResponseDto } from '../dtos/response/CodeResultsResponseDto';
import { ApiBadRequestResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';

@Controller('/code-processor')
@ApiTags('Code processor')
export class CodeProcessingControllerController {
	constructor(private readonly codeProcessorService: CodeProcessorService) {}

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
}
