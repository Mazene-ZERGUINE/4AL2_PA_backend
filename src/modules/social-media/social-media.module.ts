import { Module } from '@nestjs/common';
import { UsersService } from './services/users.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from './entities/user.entity';
import { ProgramsController } from './controllers/programs.controller';
import { ProgramsService } from './services/programs.service';
import { ProgramEntity } from './entities/program.entity';

@Module({
	imports: [TypeOrmModule.forFeature([UserEntity, ProgramEntity])],
	exports: [UsersService, TypeOrmModule, ProgramsService],
	providers: [UsersService, ProgramsService],
	controllers: [ProgramsController],
})
export class SocialMediaModule {}
