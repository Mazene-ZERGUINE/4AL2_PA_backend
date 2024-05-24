import { EntityManager } from 'typeorm';
import { UserEntity } from '../../../modules/social-media/entities/user.entity';
import { fakerFR } from '@faker-js/faker';
import { genSalt, hash } from 'bcrypt';

export async function seedDatabase(entityManager: EntityManager): Promise<void> {
	await seedUsers(entityManager, 50);
}

async function seedUsers(entityManager: EntityManager, count: number): Promise<void> {
	for (let i = 1; i <= count; i++) {
		const user = new UserEntity();
		user.userName = fakerFR.internet.userName();
		user.firstName = fakerFR.person.firstName();
		user.lastName = fakerFR.person.lastName();
		user.email = fakerFR.internet.email();
		user.password = await hash('123456789', await genSalt());
		user.avatarUrl = fakerFR.image.avatar();
		user.bio = `${fakerFR.commerce.product()} fan`;
		user.isVerified = true;

		await entityManager.getRepository(UserEntity).save(user);
	}
}
