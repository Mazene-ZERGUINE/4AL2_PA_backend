import { ProgramVisibilityEnum } from '../../enums/program-visibility.enum';
import { ProgrammingLanguageEnum } from '../../enums/programming-language.enum';
import { ProgramEntity } from '../../entities/program.entity';
import { FileTypesEnum } from '../../enums/file-types.enum';
import { UserDataDto } from './user-data.dto';

export class GetProgramDto {
	programId: string;
	description?: string;
	programmingLanguage: ProgrammingLanguageEnum;
	sourceCode: string;
	visibility: ProgramVisibilityEnum;
	inputTypes: FileTypesEnum[];
	outputTypes: FileTypesEnum[];
	user: UserDataDto;
	createdAt: Date;
	updatedAt: Date;

	constructor(program: ProgramEntity) {
		this.programId = program.programId;
		this.description = program.description;
		this.programmingLanguage = program.programmingLanguage;
		this.sourceCode = program.sourceCode;
		this.inputTypes = program.inputTypes;
		this.outputTypes = program.outputTypes;
		this.createdAt = program.createdAt;
		this.updatedAt = program.updatedAt;
		this.visibility = program.visibility;
		this.user = program.user ? program.user.toUserDataDto() : null;
	}
}
