import { Body, Controller, HttpCode, Param, Post, Get } from '@nestjs/common';
import { ApiBadRequestResponse, ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { CreateProgramDto } from '../dtos/request/CreateProgramDto';
import { ProgramsService } from '../services/programs.service';
import { ProgramVisibilityEnum } from '../enums/program-visibility.enum';
import { GetProgramDto } from '../dtos/response/GetProgramDto';

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

  @Get('')
  @HttpCode(200)
  @ApiOkResponse({
    description: 'program created',
  })
  @ApiBadRequestResponse({
    description: 'bad params sent',
  })
  async findBy(
    @Param() params: { type: ProgramVisibilityEnum },
  ): Promise<GetProgramDto[]> {
    return await this.programService.getProgramByVisibility(params.type);
  }
}
