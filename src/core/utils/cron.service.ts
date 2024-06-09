import { Injectable } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import * as path from 'node:path';
import * as fs from 'node:fs';
import { join } from 'path';

@Injectable()
export class CronService {
	@Cron('0 0 */5 * * *') // Runs every 5 hours
	handleCron() {
		// Define the directories
		const inputDir = join(__dirname, '../../../', 'uploads', 'code', 'input');
		const outputDir = join(__dirname, '../../../', 'uploads', 'code', 'output');

		// Function to delete files in a given directory
		const deleteFilesInDir = (dir: string) => {
			fs.readdir(dir, (err, files) => {
				if (err) {
					console.error(`Error reading directory ${dir}:`, err);
					return;
				}
				files.forEach((file) => {
					const filePath = path.join(dir, file);
					fs.unlink(filePath, (err) => {
						if (err) {
							console.error(`Error deleting file ${filePath}:`, err);
						} else {
							console.log(`Deleted file ${filePath}`);
						}
					});
				});
			});
		};

		deleteFilesInDir(inputDir);
		deleteFilesInDir(outputDir);
	}
}
