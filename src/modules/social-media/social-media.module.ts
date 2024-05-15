import { forwardRef, Module } from '@nestjs/common';
import { UsersService } from './services/users/users.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from './entities/user.entity';
import { AuthModule } from '../auth/auth.module';

@Module({
	imports: [forwardRef(() => AuthModule), TypeOrmModule.forFeature([UserEntity])],
	exports: [UsersService, TypeOrmModule],
	providers: [UsersService],
})
export class SocialMediaModule {}
