import { Module } from '@nestjs/common';
import { ScheduleModule } from '@nestjs/schedule';
import { CronService } from './utils/cron.service';
import { PopulateDatabaseService } from './database/populate-database.service';

@Module({
	imports: [ScheduleModule.forRoot()],
	providers: [CronService, PopulateDatabaseService],
})
export class CoreModule {}
