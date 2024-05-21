import { Module } from '@nestjs/common';
import { UsersService } from './services/users.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from './entities/user.entity';
import { ProgramsService } from './services/programs.service';
import { ProgramEntity } from './entities/program.entity';
import { ProgramController } from './controllers/program.controller';
import { UsersController } from './controllers/users.controller';
import { FollowController } from './controllers/follow.controller';
import { FollowService } from './services/follow.service';
import { FollowEntity } from './entities/follow.entity';

@Module({
	imports: [TypeOrmModule.forFeature([UserEntity, ProgramEntity, FollowEntity])],
	exports: [UsersService, TypeOrmModule, ProgramsService],
	providers: [UsersService, ProgramsService, FollowService],
	controllers: [ProgramController, UsersController, FollowController],
})
export class SocialMediaModule {}
