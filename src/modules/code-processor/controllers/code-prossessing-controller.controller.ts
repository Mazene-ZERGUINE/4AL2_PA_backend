import { Body, Controller, Post } from '@nestjs/common';
import { ProcessCodeRequestDto } from '../dtos/request/ProcessCodeRequestDto';
import { CodeProcessorService } from '../services/code-processor.service';
import { CodeResultsResponseDto } from '../dtos/response/CodeResultsResponseDto';
import { ApiTags } from '@nestjs/swagger';

@Controller('/code-processor')
@ApiTags('Code processor')
export class CodeProcessingControllerController {
	constructor(private readonly codeProcessorService: CodeProcessorService) {}
	@Post('/run-code')
	// @HttpCode(200)
	// @ApiResponse({status: 200,description: 'Code processed successfully',})
	// @ApiBadRequestResponse({ description: 'Bad request' })
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
