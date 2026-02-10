// Merkintöjen reitit (Entry Router)
// Merkintöjen kanssa liittyvien reittien määritys

import express from 'express';
import {
  getEntries,
  getEntryById,
  postEntry,
  putEntry,
  deleteEntryFn,
} from '../controllers/entry-controller.js';

const entryRouter = express.Router();

entryRouter.route('/').get(getEntries).post(postEntry);

entryRouter.route('/:id')
  .get(getEntryById)
  .put(putEntry)
  .delete(deleteEntryFn);

export default entryRouter;
