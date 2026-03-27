// Autentikointireitit (Auth Router)
// Kirjautumiseen liittyvät reitit

import express from 'express';
import { login } from '../controllers/auth-controller.js';

const authRouter = express.Router();

authRouter.post('/login', login);

export default authRouter;
