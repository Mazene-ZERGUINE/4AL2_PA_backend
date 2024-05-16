import { Body, Controller, HttpCode, Post, Get, Query } from '@nestjs/common';
import { ApiBadRequestResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { CreateProgramDto } from '../dtos/request/create-program.dto';
import { ProgramsService } from '../services/programs.service';
import { ProgramVisibilityEnum } from '../enums/program-visibility.enum';
import { GetProgramDto } from '../dtos/response/get-program.dto';

@Controller('/programs')
@ApiTags('Programs')
export class ProgramsController {
  constructor(private readonly programService: ProgramsService) {}

  @Post('')
  @HttpCode(201)
  @ApiOkResponse({
    description: 'program created',
  })
  @ApiBadRequestResponse({
    description: 'missing field',
  })
  async create(@Body() payload: CreateProgramDto): Promise<void> {
    await this.programService.saveProgram(payload);
  }

  @Get('/')
  @HttpCode(200)
  @ApiOkResponse({
    description: 'program fetched',
  })
  @ApiBadRequestResponse({
    description: 'bad params sent',
  })
  async findBy(@Query('type') type: ProgramVisibilityEnum): Promise<GetProgramDto[]> {
    return await this.programService.getProgramByVisibility(type);
  }
}
