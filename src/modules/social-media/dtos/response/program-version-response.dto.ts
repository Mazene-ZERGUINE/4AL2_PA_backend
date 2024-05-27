import { ProgrammingLanguageEnum } from '../../enums/programming-language.enum';
import { ProgramVersionEntity } from '../../entities/program-version.entity';
import { GetProgramDto } from './get-program.dto';

export class ProgramVersionResponseDto {
	program: GetProgramDto;
	versions: VersionsDto[];

	constructor(program: GetProgramDto, versions: VersionsDto[]) {
		this.program = program;
		this.versions = versions;
	}
}

export class VersionsDto {
	programVersionId: string;
	version: string;
	programmingLanguage: ProgrammingLanguageEnum;
	sourceCode: string;
	createdAt: Date;
	constructor(programVersion: ProgramVersionEntity) {
		this.programVersionId = programVersion.programVersionId;
		this.version = programVersion.version;
		this.sourceCode = programVersion.sourceCode;
		this.programmingLanguage = programVersion.programmingLanguage;
		this.createdAt = programVersion.createdAt;
	}
}
