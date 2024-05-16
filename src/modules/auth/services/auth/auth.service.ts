import { Injectable } from '@nestjs/common';
import { compare } from 'bcrypt';

import { UsersService } from '../../../social-media/services/users.service';
import { LoginDTO } from '../../dtos/request/login.dto';
import { JwtService } from '@nestjs/jwt';
import { AccessTokenDto } from '../../dtos/response/access-token.dto';
import { ConfigService } from '@nestjs/config';
import { HttpNotFoundException } from '../../../../core/exceptions/HttpNotFoundException';

@Injectable()
export class AuthService {
	constructor(
		private readonly configService: ConfigService,
		private readonly userService: UsersService,
		private readonly jwtService: JwtService,
	) {}

	async generateJsonWebToken(loginDTO: LoginDTO): Promise<AccessTokenDto> {
		const user = await this.userService.findByEmail(loginDTO.email);

		if (!(await this.isPasswordMatching(loginDTO.password, user.password))) {
			throw new HttpNotFoundException('Bad credentials');
		}
		return {
			accessToken: await this.jwtService.signAsync(
				{
					email: user.email,
					sub: user.userId,
					username: user.userName,
				},
				// { secret: process.env.JWT_SECRET },
			),
		};
	}

	private async isPasswordMatching(
		password: string,
		hashedPassword: string,
	): Promise<boolean> {
		return await compare(password, hashedPassword);
	}
}
