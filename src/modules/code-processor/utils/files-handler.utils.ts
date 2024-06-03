import { ConfigService } from '@nestjs/config';
import * as fs from 'node:fs';
import { InternalServerErrorException } from '@nestjs/common';

export class FilesHandlerUtils {
	readonly codeInputPath: string;
	readonly codeOutputPath: string;

	constructor(configService: ConfigService) {
		this.codeInputPath = configService.get('STATIC_INPUT_CODE_URL');
		this.codeOutputPath = configService.get('STATIC_OUTPUT_CODE_URL');
	}

	static removeTmpFiles(filePath: string): void {
		if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
		else throw new InternalServerErrorException('error while removing tmp files');
	}

	static processFilePath(
		fileName: string,
		codeInputPath: string,
		codeOutputPath: string,
	): {
		inputFilePath: string;
		outputFilePath: string;
	} {
		return {
			inputFilePath: codeInputPath + '/' + fileName,
			outputFilePath: codeOutputPath + '/' + fileName,
		};
	}

	static checkFileIfExists(filePath: string): boolean {
		return fs.existsSync(filePath);
	}
}
