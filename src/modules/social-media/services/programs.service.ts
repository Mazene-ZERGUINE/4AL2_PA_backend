import { Injectable } from '@nestjs/common';
import { CreateProgramDto } from '../dtos/request/create-program.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { ProgramEntity } from '../entities/program.entity';
import { Repository } from 'typeorm';
import { InternalServerErrorException } from '@nestjs/common';
import { ProgramVisibilityEnum } from '../enums/program-visibility.enum';
import { GetProgramDto } from '../dtos/response/get-program.dto';
import { UsersService } from './users.service';
import { HttpNotFoundException } from '../../../core/exceptions/HttpNotFoundException';

@Injectable()
export class ProgramsService {
	constructor(
		@InjectRepository(ProgramEntity)
		private readonly programRepository: Repository<ProgramEntity>,
		private readonly userService: UsersService,
	) {}
	async saveProgram(payload: CreateProgramDto): Promise<void> {
		try {
			const user = await this.userService.findById(payload.userId);
			if (!user) {
				throw new HttpNotFoundException('user not found');
			}
			const program = new ProgramEntity(
				payload.description,
				payload.programmingLanguage,
				payload.sourceCode,
				payload.visibility,
				payload.inputTypes,
				user,
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
		const visiblePrograms: ProgramEntity[] = await this.programRepository.find({
			where: { visibility: visibility },
			relations: ['user'],
		});
		return visiblePrograms.map((entity) => entity.toGetProgramDto());
	}

	async getUserPrograms(userId: string): Promise<GetProgramDto[]> {
		const userPrograms: ProgramEntity[] = await this.programRepository.find({
			where: { user: { userId: userId } },
			relations: ['user'],
		});
		return userPrograms.map((program) => program.toGetProgramDto());
	}
}
