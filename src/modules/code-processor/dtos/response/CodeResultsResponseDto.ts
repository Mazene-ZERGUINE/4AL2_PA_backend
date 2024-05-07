export type CodeResultsResponseDto = {
	status: string;
	result: {
		stdout: string;
		stderr: string;
		returncode: number;
	};
};
