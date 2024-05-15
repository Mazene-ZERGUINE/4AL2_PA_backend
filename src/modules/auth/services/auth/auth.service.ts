import { Injectable, UnauthorizedException } from '@nestjs/common';
import { compare } from 'bcrypt';

import { UsersService } from '../../../social-media/services/users/users.service';
import { LoginDTO } from '../../dtos/login.dto';
import { JwtService } from '@nestjs/jwt';
import { AccessTokenDto } from '../../dtos/access-token.dto';

@Injectable()
export class AuthService {
	constructor(
		private readonly userService: UsersService,
		private readonly jwtService: JwtService,
	) {}

	async generateJsonWebToken(loginDTO: LoginDTO): Promise<AccessTokenDto> {
		const user = await this.userService.find(loginDTO);

		if (!(await this.isPasswordMatching(loginDTO.password, user.password))) {
			throw new UnauthorizedException('Mauvais identifiants.');
		}

		// return {
		// 	accessToken: await this.jwtService.signAsync({
		// 		email: user.email,
		// 		sub: user.userId,
		// 		username: user.userName,
		// 	}),
		// };
		return {
			accessToken: this.jwtService.sign({
				email: user.email,
				sub: user.userId,
				username: user.userName,
			}),
		};
	}

	private async isPasswordMatching(
		password: string,
		hashedPassword: string,
	): Promise<boolean> {
		return await compare(password, hashedPassword);
	}
}
