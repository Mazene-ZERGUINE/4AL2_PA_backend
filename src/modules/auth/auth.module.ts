import { Module } from '@nestjs/common';
import { AuthController } from './controllers/auth/auth.controller';
import { AuthService } from './services/auth/auth.service';
import { JwtModule } from '@nestjs/jwt';

@Module({
	controllers: [AuthController],
	imports: [
		JwtModule.register({
			secret: process.env.JWT_SECRET,
			signOptions: {
				expiresIn: '1d',
			},
		}),
	],
	providers: [AuthService],
})
export class AuthModule {}
