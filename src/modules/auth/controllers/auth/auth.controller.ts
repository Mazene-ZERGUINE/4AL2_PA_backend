import { Body, Controller, HttpCode, Post } from '@nestjs/common';
import { AuthService } from '../../services/auth/auth.service';
import { UsersService } from '../../../social-media/services/users/users.service';
import { CreateUserDto } from '../../../social-media/dtos/create-user.dto';
import { LoginDTO } from '../../dtos/login.dto';
import { AccessTokenDto } from '../../dtos/access-token.dto';

@Controller('auth')
export class AuthController {
	constructor(
		private readonly userService: UsersService,
		private readonly authService: AuthService,
	) {}

	// TODO doc
	@HttpCode(200)
	@Post('login')
	async login(@Body() loginDTO: LoginDTO): Promise<void> {
		await this.authService.login(loginDTO);
	}

	// TODO doc
	@Post('sign-up')
	async signUp(@Body() userDTO: CreateUserDto): Promise<AccessTokenDto> {
		return await this.userService.create(userDTO);
	}
}
