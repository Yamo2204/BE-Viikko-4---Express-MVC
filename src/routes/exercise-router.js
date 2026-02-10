// Harjoitusten reitit (Exercise Router)
// Harjoitusten kanssa liittyvien reittien määritys

import express from 'express';
import {
  getExercises,
  getExerciseById,
  getExercisesByUser,
  postExercise,
  putExercise,
  deleteExerciseFn,
} from '../controllers/exercise-controller.js';

const exerciseRouter = express.Router();

// Kaikki harjoitukset ja uuden lisääminen
exerciseRouter.route('/').get(getExercises).post(postExercise);

// Käyttäjän harjoitukset
exerciseRouter.get('/user/:userId', getExercisesByUser);

// Yksittäisen harjoituksen haku, päivitys ja poisto
exerciseRouter.route('/:id')
  .get(getExerciseById)
  .put(putExercise)
  .delete(deleteExerciseFn);

export default exerciseRouter;
