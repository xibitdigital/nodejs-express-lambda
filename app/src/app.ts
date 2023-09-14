import express, { Application, Request, Response } from 'express';
import serverless from 'serverless-http';

const app: Application = express();

const PORT: number = 3001;

app.use('/', (req: Request, res: Response): void => {
  res.send('Hello world!');
});

app.listen(PORT, (): void => {
  console.log('SERVER IS UP ON PORT:', PORT);
});

export const handler = serverless(app);
