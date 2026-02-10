// Käyttäjien reitit (User Router)
// Käyttäjien kanssa liittyvien reittien määritys

import express from 'express';
import {
  getUsers,
  getUserById,
  postUser,
  putUser,
  deleteUserFn,
} from '../controllers/user-controller.js';

const userRouter = express.Router();

// Reititys
userRouter.route('/').get(getUsers).post(postUser);

userRouter.route('/:id')
  .get(getUserById)
  .put(putUser)
  .delete(deleteUserFn);

export default userRouter;
