import {
	BadRequestException,
	Body,
	Controller,
	Get,
	HttpCode,
	Post,
	UseGuards,
} from '@nestjs/common';
import {
	ApiBadRequestResponse,
	ApiCreatedResponse,
	ApiNotFoundResponse,
	ApiOkResponse,
	ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { CreateCommentDto } from '../dtos/request/create-comment.dto';
import { CommentsService } from '../services/comments.service';
import { GetCommentsDto } from '../dtos/response/get-comments.dto';

@ApiTags('comments')
@Controller('comment')
export class CommentsController {
	constructor(private readonly commentService: CommentsService) {}
	@UseGuards(JwtAuthGuard)
	@Post('')
	@HttpCode(201)
	@ApiCreatedResponse({
		description: 'returns 201 http code when comments is saved',
		type: null,
	})
	@ApiBadRequestResponse({
		description: 'returns 400 response code when a param is missing',
		type: BadRequestException,
	})
	async create(@Body() payload: CreateCommentDto): Promise<void> {
		await this.commentService.saveComment(payload);
	}

	@UseGuards(JwtAuthGuard)
	@Get('')
	@HttpCode(200)
	@ApiOkResponse({
		description: 'returns a list of comments and thier responses when',
		isArray: true,
		type: GetCommentsDto,
	})
	@ApiNotFoundResponse({
		description: 'returns http 404 code when comment not foudn',
	})
	async getAll(): Promise<void> {
		//todo
		//return await this.commentService.getCommentResponses(commentId);
	}
}
