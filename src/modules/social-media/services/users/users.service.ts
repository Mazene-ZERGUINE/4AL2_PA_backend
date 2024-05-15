import { Injectable, UnauthorizedException } from '@nestjs/common';
import { UserEntity } from '../../entities/user.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateUserDto } from '../../dtos/create-user.dto';
import { LoginDTO } from '../../../auth/dtos/login.dto';
import { AccessTokenDto } from '../../../auth/dtos/access-token.dto';
import { genSalt, hash } from 'bcrypt';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class UsersService {
	constructor(
		private readonly jwtService: JwtService,
		@InjectRepository(UserEntity) private readonly userRepository: Repository<UserEntity>,
	) {}

	async create(userDto: CreateUserDto): Promise<AccessTokenDto> {
		const newUser = this.userRepository.create(userDto);
		newUser.password = await hash(newUser.password, await genSalt());

		await this.userRepository.save(newUser);

		return {
			accessToken: await this.jwtService.signAsync({
				email: newUser.email,
				sub: newUser.userId,
				username: newUser.userName,
			}),
		};
	}

	async find(login: LoginDTO): Promise<null | UserEntity> {
		const foundUser = await this.userRepository.findOneBy({ email: login.email });
		if (!foundUser) {
			throw new UnauthorizedException('Mauvais identifiants.');
		}

		return foundUser;
	}

	async testGetUser(email: string): Promise<UserEntity> {
		const foundUser = await this.userRepository.findOneBy({ email });
		if (!foundUser) {
			throw new UnauthorizedException('🤌');
		}

		return foundUser;
	}
}
