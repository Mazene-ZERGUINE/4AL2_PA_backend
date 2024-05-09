import { Entity, PrimaryGeneratedColumn, Column, ManyToMany, OneToMany } from 'typeorm';
import { UserEntity } from './user.entity';
import { ProgrammingLanguageEnum } from '../enums/programming-language.enum';
import { ProgramVisibilityEnum } from '../enums/program-visibility.enum';
import { ProgramVersionEntity } from './program-version.entity';
import { FileTypesEnum } from '../enums/file-types.enum';

@Entity('program')
export class ProgramEntity {
	@PrimaryGeneratedColumn('uuid')
	programId: string;

	@Column({ nullable: true, length: 255 })
	description?: string;

	@Column({ nullable: false, enum: ProgrammingLanguageEnum })
	programmingLanguage: string;

	@Column({ nullable: false })
	sourceCode: string;

	@Column({ nullable: false, enum: ProgramVisibilityEnum })
	visibility: string;

	@Column({ type: 'simple-array', nullable: false, enum: FileTypesEnum })
	inputTypes: FileTypesEnum[];

	@Column({ type: 'simple-array', nullable: false, enum: FileTypesEnum })
	outputTypes: FileTypesEnum[];

	@Column({ nullable: false })
	userId: string;

	@OneToMany(
		() => ProgramVersionEntity,
		(version: ProgramVersionEntity) => version.program,
	)
	versions: ProgramVersionEntity[];

	@ManyToMany(() => UserEntity, (user: UserEntity) => user.programmes)
	user: UserEntity;

	@Column('timestamp', { default: () => 'CURRENT_TIMESTAMP' })
	createdAt: Date;

	@Column('timestamp', {
		default: () => 'CURRENT_TIMESTAMP',
		onUpdate: 'CURRENT_TIMESTAMP',
	})
	updatedAt: Date;
}
