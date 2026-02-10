// Merkinnän käsittelijä (Entry Controller)
// Pyyntöjen käsittely merkintöihin liittyvistä toiminnoista

import { addEntry, findEntryById, listAllEntries, updateEntry, deleteEntry as deleteEntryModel } from "../models/entry-model.js";

const getEntries = async (req, res) => {
  const result = await listAllEntries();
  if (!result.error) {
    res.json(result);
  } else {
    res.status(500);
    res.json(result);
  }
};

const getEntryById = async (req, res) => {
  const entry = await findEntryById(req.params.id);
  if (entry && !entry.error) {
    res.json(entry);
  } else if (entry?.error) {
    res.status(500);
    res.json(entry);
  } else {
    res.sendStatus(404);
  }
};

const postEntry = async (req, res) => {
  const { user_id, entry_date, mood, weight, sleep_hours, notes } = req.body;
  if (entry_date && (weight || mood || sleep_hours || notes) && user_id) {
    const result = await addEntry(req.body);
    if (result.entry_id) {
      res.status(201);
      res.json({ message: 'Uusi merkintä lisätty.', ...result });
    } else {
      res.status(500);
      res.json(result);
    }
  } else {
    res.sendStatus(400);
  }
};

const putEntry = async (req, res) => {
  const { user_id, entry_date, mood, weight, sleep_hours, notes } = req.body;
  if (entry_date && (weight || mood || sleep_hours || notes) && user_id) {
    const result = await updateEntry(req.params.id, req.body);
    if (result.affectedRows > 0) {
      res.status(200);
      res.json({ message: 'Merkintä päivitetty onnistuneesti.', ...result });
    } else if (result.error) {
      res.status(500);
      res.json(result);
    } else {
      res.sendStatus(404);
    }
  } else {
    res.sendStatus(400);
  }
};

const deleteEntryFn = async (req, res) => {
  const result = await deleteEntryModel(req.params.id);
  if (result.affectedRows > 0) {
    res.status(200);
    res.json({ message: 'Merkintä poistettu onnistuneesti.', ...result });
  } else if (result.error) {
    res.status(500);
    res.json(result);
  } else {
    res.sendStatus(404);
  }
};

export { getEntries, getEntryById, postEntry, putEntry, deleteEntryFn };
