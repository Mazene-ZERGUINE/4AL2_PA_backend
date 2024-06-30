import {
	WebSocketGateway,
	WebSocketServer,
	OnGatewayConnection,
	OnGatewayDisconnect,
	SubscribeMessage,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

@WebSocketGateway({
	namespace: '/collaboratif-coding',
	cors: {
		origin: 'http://localhost:4200',
		methods: ['GET', 'POST'],
		credentials: true,
	},
})
export class CollaborativeCodingGateway
	implements OnGatewayConnection, OnGatewayDisconnect
{
	@WebSocketServer() server: Server;
	private sessions: Map<string, string> = new Map();

	handleConnection(client: Socket) {
		console.log(`Client connected: ${client.id}`);
	}

	handleDisconnect(client: Socket) {
		console.log(`Client disconnected: ${client.id}`);
	}

	@SubscribeMessage('joinSession')
	handleJoinSession(client: Socket, sessionId: string): void {
		try {
			client.join(sessionId);
			if (this.sessions.has(sessionId)) {
				client.emit('loadCode', { code: this.sessions.get(sessionId) });
			} else {
				this.sessions.set(sessionId, '');
			}
		} catch (error) {
			console.error('Error joining session:', error);
			client.emit('error', 'Failed to join session');
		}
	}

	@SubscribeMessage('codeChange')
	handleCodeChange(
		client: Socket,
		payload: {
			sessionId: string;
			code: string;
		},
	): void {
		try {
			this.sessions.set(payload.sessionId, payload.code);
			client.to(payload.sessionId).emit('codeUpdate', payload);
		} catch (error) {
			client.emit('error', 'Failed to update code');
		}
	}

	@SubscribeMessage('cursorChange')
	handleCursorChange(
		client: Socket,
		payload: {
			sessionId: string;
			cursor: { row: number; column: number };
		},
	): void {
		try {
			client.emit('cursorUpdate', payload);
		} catch (error) {
			client.emit('error', 'Failed to update cursor');
		}
	}
}
