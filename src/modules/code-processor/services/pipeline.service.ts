import { Injectable } from '@nestjs/common';
import { CodeProcessorService } from './code-processor.service';
import { Express } from 'express';
import { GetProgramDto } from '../../social-media/dtos/response/get-program.dto';
import { ProcessFileRequestDto } from '../dtos/request/process-file-request.dto';
import { ProgrammingLanguage } from '../enums/ProgrammingLanguage';
import * as fs from 'fs';
import * as path from 'path';
import { join } from 'path';

@Injectable()
export class PipelineService {
	private readonly inputDirPath = join(__dirname, '../../../..');
	private readonly outputDirPath = join(__dirname, '../../../..');

	constructor(private readonly runCodeService: CodeProcessorService) {}

	async runPipelineWithFiles(
		startingFile: Express.Multer.File[],
		programsData: { programs: GetProgramDto[] },
	): Promise<any> {
		const outputFiles = [];
		let error: string = '';
		let success: boolean = true;
		let currentInputFile = startingFile;

		const programs: GetProgramDto[] = programsData.programs;

		for (const program of programs) {
			const processFileRequestDto = new ProcessFileRequestDto(
				program.programmingLanguage as unknown as ProgrammingLanguage,
				program.sourceCode,
				program.outputTypes,
			);

			try {
				const result = await this.runCodeService.runCodeWithFiles(
					currentInputFile,
					processFileRequestDto,
				);
				if (result.result.output_file_paths) {
					result.result.output_file_paths.forEach((outputFilePath) => {
						outputFiles.push(outputFilePath);
					});
					await this.copyFilesToInputDirectory(outputFiles, 'uploads/code/input');
					currentInputFile = outputFiles.map((filePath) =>
						this.createFileObject(
							path.join('uploads/code/input', path.basename(filePath)),
						),
					);
				} else {
					success = false;
					error = 'No output files generated';
					break;
				}
			} catch (err) {
				success = false;
				error = err.message;
				break;
			}
		}

		if (success) {
			return { success, outputFiles };
		} else {
			return { success, error };
		}
	}

	private createFileObject(filePath: string): Express.Multer.File {
		const file = {
			fieldname: 'file',
			originalname: filePath.split('/').pop() || '',
			encoding: '7bit',
			mimetype: 'application/octet-stream',
			destination: filePath,
			filename: filePath.split('/').pop() || '',
			path: filePath,
			size: 0,
		} as Express.Multer.File;
		return file;
	}

	private async copyFilesToInputDirectory(
		filePaths: string[],
		targetDirectory: string,
	): Promise<void> {
		return new Promise((resolve, reject) => {
			filePaths.forEach((filePath, index) => {
				const targetPath =
					this.inputDirPath + '/' + path.join(targetDirectory, path.basename(filePath));
				const fileDir = this.inputDirPath + '/' + filePath.split('3000')[1];
				fs.copyFile(fileDir, targetPath, (err) => {
					if (err) {
						reject(err);
					}
					if (index === filePaths.length - 1) {
						resolve();
					}
				});
			});
		});
	}
}
