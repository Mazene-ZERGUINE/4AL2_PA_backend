import { Body, Controller, Get, HttpCode, Post, Query } from '@nestjs/common';
import { AuthService } from '../../services/auth/auth.service';
import { UsersService } from '../../../social-media/services/users/users.service';
import { CreateUserDto } from '../../../social-media/dtos/create-user.dto';
import { LoginDTO } from '../../dtos/login.dto';
import { AccessTokenDto } from '../../dtos/access-token.dto';
import { UserEntity } from '../../../social-media/entities/user.entity';

@Controller('auth')
export class AuthController {
	constructor(
		private readonly userService: UsersService,
		private readonly authService: AuthService,
	) {}

	// TODO doc
	@HttpCode(200)
	@Post('login')
	async login(@Body() loginDTO: LoginDTO): Promise<AccessTokenDto> {
		return this.authService.generateJsonWebToken(loginDTO);
	}

	// TODO doc
	@Post('sign-up')
	async signUp(@Body() userDTO: CreateUserDto): Promise<AccessTokenDto> {
		return await this.userService.create(userDTO);
	}

	@Get('user-test')
	async testGetUser(@Query('email') email: string): Promise<UserEntity> {
		return await this.userService.testGetUser(email);
	}
}
