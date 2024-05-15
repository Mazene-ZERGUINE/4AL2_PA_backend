import { forwardRef, Module } from '@nestjs/common';
import { AuthController } from './controllers/auth/auth.controller';
import { AuthService } from './services/auth/auth.service';
import { JwtModule, JwtService } from '@nestjs/jwt';
import { JwtStrategy } from './strategies/jwt.strategy';
import { SocialMediaModule } from '../social-media/social-media.module';
import { JwtConfigService } from './services/jwt-config/jwt-config.service';

@Module({
	controllers: [AuthController],
	imports: [
		// JwtModule.registerAsync({
		// 	imports: [ConfigModule],
		// 	useClass: JwtConfigService,
		// }),
		JwtModule.register({
			secret: process.env.JWT_SECRET,
			signOptions: {
				expiresIn: process.env.JWT_EXPIRATION_TIME,
			},
		}),

		forwardRef(() => SocialMediaModule),
	],
	exports: [JwtService],
	providers: [AuthService, JwtStrategy, JwtConfigService, JwtService],
})
export class AuthModule {}
