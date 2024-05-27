import { Body, Controller, Get, HttpCode, Param, Post, UseGuards } from '@nestjs/common';
import {
	ApiBadRequestResponse,
	ApiCreatedResponse,
	ApiNotFoundResponse,
	ApiOkResponse,
	ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { VersionsService } from '../services/versions.service';
import { CreateVersionDto } from '../dtos/request/create-version.dto';
import { ProgramVersionResponseDto } from '../dtos/response/program-version-response.dto';

@ApiTags('versions')
@Controller('versions')
export class VersionsController {
	constructor(private readonly versionsService: VersionsService) {}

	@UseGuards(JwtAuthGuard)
	@Post('')
	@HttpCode(201)
	@ApiCreatedResponse({
		description: 'returns 2O1 code when new code version is created',
	})
	@ApiBadRequestResponse({
		description: 'returns 400 code when a param is messing from request body',
	})
	async create(@Body() payload: CreateVersionDto): Promise<void> {
		await this.versionsService.addNewVersion(payload);
	}

	@UseGuards(JwtAuthGuard)
	@Get('/all/:programId')
	@HttpCode(200)
	@ApiOkResponse({
		description: 'returns a list of all program versions',
		type: ProgramVersionResponseDto,
		isArray: true,
	})
	@ApiNotFoundResponse({
		description: 'returns 400 code when program does not exists',
	})
	async getAllByProgram(
		@Param('programId') programId: string,
	): Promise<ProgramVersionResponseDto> {
		return await this.versionsService.getProgramVersion(programId);
	}
}
