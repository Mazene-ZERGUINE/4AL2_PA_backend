import {
	Entity,
	PrimaryGeneratedColumn,
	Column,
	OneToOne,
	JoinColumn,
	ManyToMany,
} from 'typeorm';
import { UserEntity } from './user.entity';

@Entity('group')
export class GroupEntity {
	@PrimaryGeneratedColumn('uuid')
	groupId: string;

	@Column({ nullable: false, length: 60 })
	name: string;

	@Column({ nullable: true, type: 'text' })
	description?: string;

	@OneToOne(() => UserEntity)
	@JoinColumn()
	owner: UserEntity;

	@ManyToMany(() => UserEntity, (user) => user.groups)
	members: UserEntity[];

	@Column('timestamp', { default: () => 'CURRENT_TIMESTAMP' })
	createdAt: Date;

	@Column('timestamp', {
		default: () => 'CURRENT_TIMESTAMP',
		onUpdate: 'CURRENT_TIMESTAMP',
	})
	updatedAt: Date;
}
