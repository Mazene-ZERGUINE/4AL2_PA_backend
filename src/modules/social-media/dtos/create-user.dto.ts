import { IsBoolean, IsEmail, IsOptional, IsString, Length } from 'class-validator';

export class CreateUserDto {
	@IsString()
	@Length(1, 60)
	userName: string;

	@IsString()
	@Length(1, 60)
	firstName: string;

	@IsString()
	@Length(1, 60)
	lastName: string;

	@IsEmail()
	@Length(1, 60)
	email: string;

	@IsString()
	@Length(8, 255)
	password: string;

	@IsOptional()
	@IsString()
	avatarUrl?: string;

	@IsOptional()
	@IsString()
	bio?: string;

	@IsOptional()
	@IsBoolean()
	isVerified = false;
}
