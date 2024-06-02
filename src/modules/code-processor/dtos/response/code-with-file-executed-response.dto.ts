import { ApiProperty } from '@nestjs/swagger';

export class CodeExecutionResult {
	@ApiProperty({
		description: 'code executed with success result',
	})
	stdout: string;

	@ApiProperty({
		description: 'code executed with failure result',
	})
	stderr: string;

	@ApiProperty({
		description: 'code execution returncode result',
	})
	return_code: number;

	@ApiProperty({
		description: 'output file statuc url',
	})
	output_file_path: string;
}

export class CodeWithFileExecutedResponseDto {
	@ApiProperty({
		description: 'status',
	})
	status: string;
	@ApiProperty({
		description: 'execution result details',
		type: CodeExecutionResult,
	})
	result: CodeExecutionResult;
}
