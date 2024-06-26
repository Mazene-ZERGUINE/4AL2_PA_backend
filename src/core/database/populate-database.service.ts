import { Injectable, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectConnection } from '@nestjs/typeorm';
import { Connection } from 'typeorm';
import { exec } from 'child_process';
import { join } from 'path';
import { existsSync } from 'fs';

@Injectable()
export class PopulateDatabaseService implements OnModuleInit {
	private readonly pgFilePath: string;

	constructor(
		private readonly configService: ConfigService,
		@InjectConnection() private readonly connection: Connection,
	) {
		const srcPath = join(__dirname, '..', '..', '..', 'database', 'sql', 'dump.sql');
		const distPath = join(__dirname, '..', 'database', 'sql', 'dump.sql');

		// Determine the correct path based on existence
		this.pgFilePath = existsSync(srcPath) ? srcPath : distPath;
	}

	async onModuleInit(): Promise<void> {
		if (this.configService.get('NODE_ENV') === 'development') {
			await this.resetDatabase();
		}
	}

	private async resetDatabase(): Promise<void> {
		try {
			await this.connection.query('DROP SCHEMA public CASCADE;');
			await this.connection.query('CREATE SCHEMA public;');
			await this.executePgDump();
		} catch (error) {
			// eslint-disable-next-line no-console
			console.error('Error resetting database:', error);
		}
	}

	private executePgDump(): Promise<void> {
		return new Promise((resolve, reject) => {
			const dbUser = this.configService.get('DATABASE_USER');
			const dbName = this.configService.get('DATABASE_NAME');
			const dbHost = this.configService.get('DATABASE_HOST');
			const dbPort = this.configService.get<number>('DATABASE_PORT', 5432);

			const command = `PGPASSWORD=${this.configService.get(
				'DATABASE_PASSWORD',
			)} psql -U ${dbUser} -h ${dbHost} -p ${dbPort} -d ${dbName} -f ${this.pgFilePath}`;

			exec(command, (error) => {
				if (error) {
					// eslint-disable-next-line no-console
					console.error('Error executing pg_dump:', error);
					reject(error);
				} else {
					// eslint-disable-next-line no-console
					console.log('Database populated successfully');
					resolve();
				}
			});
		});
	}
}
