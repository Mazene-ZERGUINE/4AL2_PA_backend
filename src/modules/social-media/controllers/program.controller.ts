import { Body, Controller, Get, HttpCode, Post, Query } from '@nestjs/common';
import { ApiBadRequestResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { ProgramsService } from '../services/programs.service';
import { CreateProgramDto } from '../dtos/request/create-program.dto';
import { ProgramVisibilityEnum } from '../enums/program-visibility.enum';
import { GetProgramDto } from '../dtos/response/get-program.dto';

@Controller('/programs')
@ApiTags('Programs')
export class ProgramController {
	constructor(private readonly programService: ProgramsService) {}

	@Post()
	@HttpCode(201)
	@ApiOkResponse()
	async create(@Body() payload: CreateProgramDto): Promise<void> {
		// throw NotImplementedException();
		await this.programService.saveProgram(payload);
	}

	@Get()
	@HttpCode(200)
	@ApiOkResponse()
	@ApiBadRequestResponse()
	async findBy(@Query('type') type: ProgramVisibilityEnum): Promise<GetProgramDto[]> {
		// throw NotImplementedException();
		return await this.programService.getProgramByVisibility(type);
	}
}
