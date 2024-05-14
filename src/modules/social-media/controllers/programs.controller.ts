import { Body, Controller, HttpCode, Post } from '@nestjs/common';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { CreateProgramDto } from '../dtos/request/CreateProgramDto';
import { ProgramsService } from '../services/programs.service';

@Controller('/programs')
@ApiTags('Programs')
export class ProgramsController {
  constructor(private readonly programService: ProgramsService) {}
  @Post('')
  @HttpCode(201)
  @ApiOkResponse({
    description: '✅ program created',
  })
  async create(@Body() payload: CreateProgramDto): Promise<void> {
    await this.programService.saveProgram(payload);
  }
}
