import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { UserEntity } from './user.entity';
import { ProgramEntity } from './program.entity';

@Entity('comment')
export class CommentEntity {
	@PrimaryGeneratedColumn('uuid')
	commentId: string;

	@Column({ nullable: false, type: 'text' })
	content: string;

	@ManyToOne(() => UserEntity, (user) => user.comments)
	@JoinColumn({ name: 'userId' })
	user: UserEntity;

	@ManyToOne(() => ProgramEntity, (program) => program.comments)
	@JoinColumn({ name: 'programId' })
	program: ProgramEntity;

	@Column('timestamp', { default: () => 'CURRENT_TIMESTAMP' })
	createdAt: Date;

	@Column('timestamp', {
		default: () => 'CURRENT_TIMESTAMP',
		onUpdate: 'CURRENT_TIMESTAMP',
	})
	updatedAt: Date;
}
