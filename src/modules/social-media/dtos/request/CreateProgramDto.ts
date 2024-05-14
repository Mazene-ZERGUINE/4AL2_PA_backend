import { ProgrammingLanguageEnum } from '../../enums/programming-language.enum';
import { ProgramVisibilityEnum } from '../../enums/program-visibility.enum';
import { FileTypesEnum } from '../../enums/file-types.enum';
import { IsEnum, IsNotEmpty, IsString, ArrayNotEmpty, IsArray } from 'class-validator';

export class CreateProgramDto {
	@IsString()
	description?: string;

	@IsNotEmpty()
	@IsEnum(ProgrammingLanguageEnum, {
		message: 'This programming language is not supported',
	})
	programmingLanguage: ProgrammingLanguageEnum;

	@IsString()
	@IsNotEmpty()
	sourceCode: string;

	@IsString()
	@IsEnum(ProgramVisibilityEnum, {
		message: 'Not a valid visibility type',
	})
	visibility: ProgramVisibilityEnum;

	@IsArray()
	@ArrayNotEmpty({
		message: 'Input types must contain at least one file type',
	})
	@IsEnum(FileTypesEnum, {
		each: true,
		message: 'Invalid input file type',
	})
	inputTypes: FileTypesEnum[];

	@IsArray()
	@ArrayNotEmpty({
		message: 'Output types must contain at least one file type',
	})
	@IsEnum(FileTypesEnum, {
		each: true,
		message: 'Invalid output file type',
	})
	outputTypes: FileTypesEnum[];

	@IsString()
	@IsNotEmpty()
	userId: string;
}
