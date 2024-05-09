import { Entity, PrimaryGeneratedColumn, Column, OneToMany, Index } from 'typeorm';
import { ProgramEntity } from './program.entity';

@Entity('user')
export class UserEntity {
	@PrimaryGeneratedColumn('uuid')
	userId: string;

	@Column({ nullable: false, length: 60 })
	userName: string;

	@Column({ nullable: false, length: 60 })
	firstName: string;

	@Column({ nullable: false, length: 60 })
	lastName: string;

	@Column({ nullable: false, length: 60, unique: true })
	@Index()
	email: string;

	@Column({ nullable: false, length: 255 })
	password: string;

	@Column({ nullable: true })
	avatarUrl?: string;

	@Column({ nullable: true })
	bio?: string;

	@Column({ nullable: false, default: false })
	isVerified: boolean = false;

	@OneToMany(() => ProgramEntity, (programme: ProgramEntity) => programme.user, {
		cascade: ['insert', 'update', 'remove'],
	})
	programmes: ProgramEntity[];

	@Column('timestamp', { default: () => 'CURRENT_TIMESTAMP' })
	createdAt: Date;

	@Column('timestamp', {
		default: () => 'CURRENT_TIMESTAMP',
		onUpdate: 'CURRENT_TIMESTAMP',
	})
	updatedAt: Date;
}
