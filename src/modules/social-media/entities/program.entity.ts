import { Entity, PrimaryGeneratedColumn, Column, ManyToMany, OneToMany } from 'typeorm';
import { UserEntity } from './user.entity';
import { ProgrammingLanguageEnum } from '../enums/programming-language.enum';
import { ProgramVisibilityEnum } from '../enums/program-visibility.enum';
import { ProgramVersionEntity } from './program-version.entity';
import { FileTypesEnum } from '../enums/file-types.enum';
import { ReactionEntity } from './reaction.entity';
import { CommentEntity } from './comment.entity';

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

	@OneToMany(() => ProgramVersionEntity, (version) => version.program, {
		cascade: ['remove'],
	})
	versions: ProgramVersionEntity[];

	@ManyToMany(() => UserEntity, (user: UserEntity) => user.programs)
	user: UserEntity;

	@OneToMany(() => ReactionEntity, (reaction) => reaction.program, {
		cascade: ['remove'],
	})
	reactions: ReactionEntity[];

	@OneToMany(() => CommentEntity, (comment) => comment.program, {
		cascade: ['remove'],
	})
	comments: CommentEntity[];

	@Column('timestamp', { default: () => 'CURRENT_TIMESTAMP' })
	createdAt: Date;

	@Column('timestamp', {
		default: () => 'CURRENT_TIMESTAMP',
		onUpdate: 'CURRENT_TIMESTAMP',
	})
	updatedAt: Date;

	constructor(
		description: string,
		programmingLanguage: string,
		sourceCode: string,
		visibility: string,
		inputTypes: FileTypesEnum[],
		userId: string,
		outputTypes: FileTypesEnum[],
	) {
		this.description = description;
		this.programmingLanguage = programmingLanguage;
		this.sourceCode = sourceCode;
		this.visibility = visibility;
		this.inputTypes = inputTypes;
		this.userId = userId;
		this.outputTypes = outputTypes;
	}
}
