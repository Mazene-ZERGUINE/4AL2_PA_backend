import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { seedDatabase } from '../../core/database/seeds/seed-database';

@Injectable()
export class DatabaseSeedService {
	constructor(private readonly connection: DataSource) {}

	async seed(): Promise<void> {
		const queryRunner = this.connection.createQueryRunner();
		await queryRunner.connect();
		await queryRunner.startTransaction();

		try {
			const entityManager = queryRunner.manager;

			await seedDatabase(entityManager);
			await queryRunner.commitTransaction();
		} catch (err) {
			// eslint-disable-next-line no-console
			console.log('Error during database seeding: ', err);
			await queryRunner.rollbackTransaction();
		} finally {
			await queryRunner.release();
		}
	}
}
