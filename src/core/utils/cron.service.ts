import { Injectable } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import * as path from 'node:path';
import * as fs from 'node:fs';
import { join } from 'path';

@Injectable()
export class CronService {
	@Cron('0 0 */5 * * *') // Runs every 5 hours
	handleCron() {
		const inputDir = join(__dirname, '../../../', 'uploads', 'code', 'input');
		const outputDir = join(__dirname, '../../../', 'uploads', 'code', 'output');
		const cronFilePath = join(__dirname, '../../../', 'loggs', 'cron', 'cron-log.txt');

		// Ensure the log file exists
		if (!fs.existsSync(cronFilePath)) {
			fs.mkdirSync(path.dirname(cronFilePath), { recursive: true });
			fs.writeFileSync(cronFilePath, '', { flag: 'a' });
		}

		const logMessage = (message: string) => {
			const timestamp = new Date().toISOString();
			fs.appendFile(cronFilePath, `${timestamp} - ${message}\n`, (err) => {
				if (err) {
					console.error(`Error writing to log file ${cronFilePath}:`, err);
				}
			});
		};

		const deleteFilesInDir = (dir: string) => {
			fs.readdir(dir, (err, files) => {
				if (err) {
					const errorMsg = `Error reading directory ${dir}: ${err}`;
					console.error(errorMsg);
					logMessage(errorMsg);
					return;
				}
				files.forEach((file) => {
					const filePath = path.join(dir, file);
					fs.unlink(filePath, (err) => {
						if (err) {
							const errorMsg = `Error deleting file ${filePath}: ${err}`;
							logMessage(`ERROR: ${errorMsg}`);
						} else {
							const successMsg = `Successfully deleted file ${filePath}`;
							logMessage(`SUCCESS: ${successMsg}`);
						}
					});
				});
			});
		};
		logMessage('Cron job started');
		deleteFilesInDir(inputDir);
		deleteFilesInDir(outputDir);
		logMessage('Cron job completed');
	}
}
