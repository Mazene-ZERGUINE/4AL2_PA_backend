import { Injectable } from '@nestjs/common';
import { CreateProgramDto } from '../dtos/request/CreateProgramDto';
import { InjectRepository } from '@nestjs/typeorm';
import { ProgramEntity } from '../entities/program.entity';
import { Repository } from 'typeorm';
import { InternalServerErrorException } from '@nestjs/common';
import { ProgramVisibilityEnum } from '../enums/program-visibility.enum';
import { GetProgramDto } from '../dtos/response/GetProgramDto';

@Injectable()
export class ProgramsService {
	constructor(
		@InjectRepository(ProgramEntity)
		private readonly programRepository: Repository<ProgramEntity>,
	) {}
	async saveProgram(payload: CreateProgramDto): Promise<void> {
		try {
			const program = new ProgramEntity(
				payload.description,
				payload.programmingLanguage,
				payload.sourceCode,
				payload.visibility,
				payload.inputTypes,
				payload.userId,
				payload.outputTypes,
			);
			await this.programRepository.save(program);
		} catch (error) {
			throw new InternalServerErrorException('Failed to save the program.');
		}
	}

	async getProgramByVisibility(
		visibility: ProgramVisibilityEnum,
	): Promise<GetProgramDto[]> {
		const visiblePrograms: ProgramEntity[] = await this.programRepository.findBy({
			visibility: visibility,
		});

		return visiblePrograms.map((entity) => entity.toGetProgramDto());
	}
}
