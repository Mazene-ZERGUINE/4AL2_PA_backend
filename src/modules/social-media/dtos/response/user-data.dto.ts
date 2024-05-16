export class UserDataDto {
	userId: string;
	userName: string;
	firstName: string;
	lastName: string;
	email: string;
	bio?: string;
	avatarUrl?: string;
	constructor(
		userId: string,
		userName: string,
		firstName: string,
		lastName: string,
		email: string,
		bio: string,
		avatarUrl: string,
	) {
		this.userId = userId;
		this.userName = userName;
		this.firstName = firstName;
		this.lastName = lastName;
		this.email = email;
		this.bio = bio;
		this.avatarUrl = avatarUrl;
	}
}
