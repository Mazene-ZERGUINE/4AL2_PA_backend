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
	groupName: string;

	@Column({ nullable: true, length: 255 })
	groupDescription: string;

	@OneToOne(() => UserEntity)
	@JoinColumn()
	groupCreator: UserEntity;

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
