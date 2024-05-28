import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { CommentEntity } from '../entities/comment.entity';
import { EntityNotFoundError, Repository } from 'typeorm';
import { ProgramEntity } from '../entities/program.entity';
import { CreateCommentDto } from '../dtos/request/create-comment.dto';
import { UserEntity } from '../entities/user.entity';
import { HttpNotFoundException } from '../../../core/exceptions/HttpNotFoundException';
import { EditCommentDto } from '../dtos/request/edit-comment.dto';

@Injectable()
export class CommentsService {
	constructor(
		@InjectRepository(CommentEntity)
		private readonly commentsRepository: Repository<CommentEntity>,
		@InjectRepository(ProgramEntity)
		private readonly programsRepository: Repository<ProgramEntity>,
		@InjectRepository(UserEntity)
		private readonly userRepository: Repository<UserEntity>,
	) {}

	async saveComment(commentDto: CreateCommentDto): Promise<void> {
		try {
			const userRef = await this.userRepository.findOneByOrFail({
				userId: commentDto.userId,
			});
			const programRef = await this.programsRepository.findOneByOrFail({
				programId: commentDto.programId,
			});
			const commentEntity = this.commentsRepository.create({
				...commentDto,
				user: userRef,
				program: programRef,
			});
			await this.commentsRepository.save(commentEntity);
		} catch (error: unknown) {
			throw new InternalServerErrorException(`internal server error ${error}`);
		}
	}

	async deleteComment(commentId: string): Promise<void> {
		try {
			await this.commentsRepository.delete(commentId);
		} catch (error: unknown) {
			if (error instanceof EntityNotFoundError)
				throw new HttpNotFoundException('comment ');
			else throw new InternalServerErrorException(`internal server error ${error}`);
		}
	}

	async editComment(commentId: string, editCommentDto: EditCommentDto): Promise<void> {
		try {
			const commentEntity = await this.commentsRepository.findOneByOrFail({
				commentId: commentId,
			});
			commentEntity.content = editCommentDto.content;
		} catch (error: unknown) {
			if (error instanceof EntityNotFoundError)
				throw new HttpNotFoundException('comment not found');
			else throw new InternalServerErrorException(`internal server error ${error}`);
		}
	}

	// todo
	async getCommentResponses(): Promise<void> {}

	// todo
	async respondToComment(): Promise<void> {}
}
