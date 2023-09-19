import express, { Application, Request, Response } from 'express';
// import { initialize } from 'express-openapi';
import serverless from 'serverless-http';

// import { v4 as uuidv4 } from 'uuid';
// import { Post, PostInput } from './types/api';

const app: Application = express();

const PORT: number = 3001;

app.use('/', (req: Request, res: Response): void => {
  res.send('Hello world!');
});

// const posts: Post[] = [];

// app.get('/posts', (req: Request, res: Response): void => {
//   res.json(posts);
// });

// app.post('/posts', (req: Request, res: Response): void => {
//   const postInput: PostInput = req.body;
//   const newPost: Post = { ...postInput, id: uuidv4() };

//   posts.push(newPost);
//   res.status(201).json(newPost);
// });

// const openappi = await initialize({
//   app,
//   docsPath: '/api-definition',
//   exposeApiDocs: ENV['NODE_ENV'] !== 'production',
//   apiDoc: './openapi/spec.yml',
// });

const handler = serverless(app);

const startServer = async () => {
  app.listen(PORT, (): void => {
    console.log('SERVER IS UP ON PORT:', PORT);
  });
};

startServer();
