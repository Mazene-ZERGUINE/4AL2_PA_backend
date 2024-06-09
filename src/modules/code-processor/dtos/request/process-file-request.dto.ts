import { ApiProperty } from '@nestjs/swagger';
import { ProgrammingLanguage } from '../../enums/ProgrammingLanguage';
import { IsArray, IsEnum, IsNotEmpty, IsString } from 'class-validator';
import { FileTypesEnum } from '../../../social-media/enums/file-types.enum';

export class ProcessFileRequestDto {
	@ApiProperty({
		description: 'code programming language',
		enum: ProgrammingLanguage,
		example: 'javascript / php / c++',
	})
	@IsNotEmpty()
	@IsEnum(ProgrammingLanguage)
	readonly programmingLanguage: ProgrammingLanguage;

	@ApiProperty({
		description: 'source code',
		type: String,
		example: 'console.log("ok")',
	})
	@IsString()
	@IsNotEmpty()
	readonly sourceCode: string;

	@ApiProperty({
		description: 'output files formats',
		type: [String],
		isArray: true,
	})
	@IsArray()
	@IsEnum(FileTypesEnum, { each: true })
	@IsNotEmpty()
	outputFilesFormats: FileTypesEnum[];
}
