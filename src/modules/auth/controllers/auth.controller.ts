import { Body, Controller, Get, HttpCode, Post, Query } from '@nestjs/common';
import { AuthService } from '../services/auth/auth.service';
import { UsersService } from '../../social-media/services/users.service';
import { CreateUserDto } from '../dtos/request/create-user.dto';
import { LoginDTO } from '../dtos/request/login.dto';
import { AccessTokenDto } from '../dtos/response/access-token.dto';
import { UserEntity } from '../../social-media/entities/user.entity';
import {
	ApiBadRequestResponse,
	ApiCreatedResponse,
	ApiNotFoundResponse,
	ApiOkResponse,
} from '@nestjs/swagger';

@Controller('auth')
export class AuthController {
	constructor(
		private readonly userService: UsersService,
		private readonly authService: AuthService,
	) {}

	@ApiOkResponse({
		description: 'login',
	})
	@ApiNotFoundResponse({
		description: 'bad credentials (user not found)',
	})
	@HttpCode(200)
	@Post('login')
	async login(@Body() loginDTO: LoginDTO): Promise<AccessTokenDto> {
		return this.authService.generateJsonWebToken(loginDTO);
	}

	@ApiCreatedResponse({
		description: 'no content 201 response',
	})
	@ApiBadRequestResponse({
		description: 'user already exists',
	})
	@Post('sign-up')
	@HttpCode(201)
	async signUp(@Body() userDTO: CreateUserDto): Promise<void> {
		await this.userService.create(userDTO);
	}

	@Get('user-test')
	async testGetUser(@Query('email') email: string): Promise<UserEntity> {
		return await this.userService.testGetUser(email);
	}
}
