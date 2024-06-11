import { Module } from '@nestjs/common';
import { ScheduleModule } from '@nestjs/schedule';
import { CronService } from './utils/cron.service';

@Module({
	imports: [ScheduleModule.forRoot()],
	providers: [CronService],
})
export class CoreModule {}
