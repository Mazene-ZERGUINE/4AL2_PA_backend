import { Injectable, UnauthorizedException } from '@nestjs/common';
import { UserEntity } from '../../entities/user.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateUserDto } from '../../../auth/dtos/request/create-user.dto';
import { LoginDTO } from '../../../auth/dtos/request/login.dto';
import { genSalt, hash } from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { UserExistException } from '../../../../core/exceptions/UserExistException';

@Injectable()
export class UsersService {
	constructor(
		private readonly jwtService: JwtService,
		@InjectRepository(UserEntity) private readonly userRepository: Repository<UserEntity>,
	) {}

	async create(userDto: CreateUserDto): Promise<void> {
		const isUserExist = await this.userRepository.findOneBy({ email: userDto.email });
		if (isUserExist) {
			throw new UserExistException(` user ${userDto.email} already exists`);
		}
		const newUser = this.userRepository.create(userDto);
		newUser.password = await hash(newUser.password, await genSalt());
		await this.userRepository.save(newUser);
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
