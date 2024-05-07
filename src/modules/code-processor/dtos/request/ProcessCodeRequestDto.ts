import { IsEnum, IsNotEmpty, IsString } from 'class-validator';
import { ProgrammingLanguage } from '../../enums/ProgrammingLanguage';

export class ProcessCodeRequestDto {
	@IsNotEmpty()
	@IsEnum(ProgrammingLanguage, {
		message: `Unsupported programming language. Supported languages are: ${Object.values(
			ProgrammingLanguage,
		).join(', ')}`,
	})
	readonly programmingLanguage: ProgrammingLanguage;

	@IsNotEmpty()
	@IsString()
	readonly sourceCode: string;
}
