import {
	Body,
	Controller,
	Get,
	HttpCode,
	Post,
	Request,
	UseGuards,
} from '@nestjs/common';
import { AuthService } from '../services/auth/auth.service';
import { UsersService } from '../../social-media/services/users.service';
import { CreateUserDto } from '../dtos/request/create-user.dto';
import { LoginDTO } from '../dtos/request/login.dto';
import { AccessTokenDto } from '../dtos/response/access-token.dto';
import {
	ApiBadRequestResponse,
	ApiCreatedResponse,
	ApiNotFoundResponse,
	ApiOkResponse,
	ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { UserDataDto } from '../../social-media/dtos/response/user-data.dto';

@ApiTags('auth')
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

	@UseGuards(JwtAuthGuard)
	@ApiOkResponse({
		description: 'returns authenticated user data',
	})
	@ApiNotFoundResponse({
		description: 'user not found',
	})
	@HttpCode(200)
	@Get('get_info')
	// eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
	async getUserInfo(@Request() request: any): Promise<UserDataDto> {
		const userEmail = request.user.email;
		const user = await this.userService.findByEmail(userEmail);
		return user.toUserDataDto();
	}
}
