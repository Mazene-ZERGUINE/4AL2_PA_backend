import { ApiProperty } from '@nestjs/swagger';
import { ProgrammingLanguage } from '../../enums/ProgrammingLanguage';
import { IsEnum, IsNotEmpty, IsString } from 'class-validator';
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
	})
	@IsString()
	@IsNotEmpty()
	readonly sourceCode: string;

	@ApiProperty({
		example: 'json',
		enum: FileTypesEnum,
	})
	@IsNotEmpty()
	@IsEnum(FileTypesEnum)
	readonly outputFormat: FileTypesEnum;
}
