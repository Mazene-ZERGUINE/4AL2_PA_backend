import { Injectable, UnauthorizedException } from '@nestjs/common';
import { UserEntity } from '../../entities/user.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateUserDto } from '../../dtos/create-user.dto';
import { LoginDTO } from '../../../auth/dtos/login.dto';
import { AccessTokenDto } from '../../../auth/dtos/access-token.dto';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class UsersService {
	constructor(
		private readonly jwtService: JwtService,
		@InjectRepository(UserEntity) private readonly userRepository: Repository<UserEntity>,
	) {}

	async create(userDto: CreateUserDto): Promise<AccessTokenDto> {
		const user = this.userRepository.create(userDto);

		await this.userRepository.save(user);

		return {
			accessToken: await this.jwtService.signAsync({
				email: user.email,
				sub: user.userId,
				username: user.userName,
			}),
		};
	}

	async find(login: LoginDTO): Promise<null | UserEntity> {
		const user = await this.userRepository.findOneBy({ email: login.email });
		if (!user) {
			throw new UnauthorizedException('Mauvais identifiants.');
		}

		return user;
	}
}
