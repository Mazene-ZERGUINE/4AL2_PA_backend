import { Module } from '@nestjs/common';
import { UsersService } from './services/users.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from './entities/user.entity';
import { ProgramsService } from './services/programs.service';
import { ProgramEntity } from './entities/program.entity';
import { ProgramController } from './controllers/program.controller';
import { UsersController } from './controllers/users.controller';

@Module({
	imports: [TypeOrmModule.forFeature([UserEntity, ProgramEntity])],
	exports: [UsersService, TypeOrmModule, ProgramsService],
	providers: [UsersService, ProgramsService],
	controllers: [ProgramController, UsersController],
})
export class SocialMediaModule {}
