// Lääkkeiden reitit (Medication Router)
// Lääkkeiden kanssa liittyvien reittien määritys

import express from 'express';
import {
  getMedications,
  getMedicationById,
  getMedicationsByUser,
  postMedication,
  putMedication,
  deleteMedicationFn,
} from '../controllers/medication-controller.js';

const medicationRouter = express.Router();

// Kaikki lääkkeet ja uuden lisääminen
medicationRouter.route('/').get(getMedications).post(postMedication);

// Käyttäjän lääkkeet
medicationRouter.get('/user/:userId', getMedicationsByUser);

// Yksittäisen lääkkeen haku, päivitys ja poisto
medicationRouter.route('/:id')
  .get(getMedicationById)
  .put(putMedication)
  .delete(deleteMedicationFn);

export default medicationRouter;
