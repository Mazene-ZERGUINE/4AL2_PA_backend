import {
	Body,
	Controller,
	Get,
	HttpCode,
	Param,
	Post,
	Query,
	UseGuards,
} from '@nestjs/common';
import { ApiBadRequestResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { ProgramsService } from '../services/programs.service';
import { CreateProgramDto } from '../dtos/request/create-program.dto';
import { ProgramVisibilityEnum } from '../enums/program-visibility.enum';
import { GetProgramDto } from '../dtos/response/get-program.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';

@Controller('/programs')
@ApiTags('Programs')
export class ProgramController {
	constructor(private readonly programService: ProgramsService) {}

	@UseGuards(JwtAuthGuard)
	@Post()
	@HttpCode(201)
	@ApiOkResponse()
	async create(@Body() payload: CreateProgramDto): Promise<void> {
		// throw NotImplementedException();
		await this.programService.saveProgram(payload);
	}

	@UseGuards(JwtAuthGuard)
	@Get()
	@HttpCode(200)
	@ApiOkResponse()
	@ApiBadRequestResponse()
	async findBy(@Query('type') type: ProgramVisibilityEnum): Promise<GetProgramDto[]> {
		// throw NotImplementedException();
		return await this.programService.getProgramByVisibility(type);
	}
	@UseGuards(JwtAuthGuard)
	@Get('/:userId')
	@HttpCode(200)
	@ApiOkResponse({ description: 'return the list of all user programs' })
	async getByUser(@Param('userId') userId: string): Promise<GetProgramDto[]> {
		return this.programService.getUserPrograms(userId);
	}
}
