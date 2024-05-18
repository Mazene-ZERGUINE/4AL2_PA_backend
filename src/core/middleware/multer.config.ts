// multer.config.ts
import { diskStorage } from 'multer';
import { v4 as uuidv4 } from 'uuid';
import { extname, join } from 'path';

export const multerOptions = {
	storage: diskStorage({
		destination: (req, file, cb) => {
			const uploadPath = join(__dirname, '../../../', 'uploads', 'avatars');
			cb(null, uploadPath);
		},
		filename: (req, file, cb) => {
			const fileExtName = extname(file.originalname);
			const randomName = uuidv4();
			cb(null, `${randomName}${fileExtName}`);
		},
	}),
	fileFilter: (req, file, cb) => {
		if (!file.mimetype.match(/\/(jpg|jpeg|png|gif)$/)) {
			return cb(new Error('Unsupported file type'), false);
		}
		cb(null, true);
	},
};