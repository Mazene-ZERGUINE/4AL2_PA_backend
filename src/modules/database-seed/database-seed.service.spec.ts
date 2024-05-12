import { Test, TestingModule } from '@nestjs/testing';
import { DatabaseSeedService } from './database-seed.service';

describe('DatabaseSeedService', () => {
	let service: DatabaseSeedService;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			providers: [DatabaseSeedService],
		}).compile();

		service = module.get<DatabaseSeedService>(DatabaseSeedService);
	});

	it('should be defined', () => {
		expect(service).toBeDefined();
	});
});
