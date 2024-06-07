import { ApiProperty } from '@nestjs/swagger';
import { ProgrammingLanguage } from '../../enums/ProgrammingLanguage';
import { IsEnum, IsNotEmpty, IsString } from 'class-validator';
import { FileTypesEnum } from '../../../social-media/enums/file-types.enum';

export type FilePaths = {
	input_file_path: string;
	output_file_path: string;
};

export class ExecuteCodeWithFileDto {
	@ApiProperty({
		description: 'programming_language',
		enum: ProgrammingLanguage,
		example: 'python',
	})
	@IsEnum(ProgrammingLanguage)
	@IsNotEmpty()
	programming_language: string;

	@ApiProperty({
		description: 'source_code',
		type: String,
		example: 'print("hello")',
	})
	@IsString()
	@IsNotEmpty()
	source_code: string;

	@ApiProperty({
		description: 'file_paths',
		type: { input_file_path: String, output_file_path: String },
	})
	@IsEnum(FileTypesEnum)
	@IsNotEmpty()
	file_paths: FilePaths;

	@IsString()
	@IsNotEmpty()
	file_output_fromat: string;
}
