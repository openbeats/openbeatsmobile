// importing required packages
import express from "express";

// creating router instance
const router = express.Router();

// importing required controllers
import getLatestVersionController from "../controllers/getLatestVersion";

// declaring necessary routes
router.get("/getlatestVersion", getLatestVersionController.getLatestVersion);

// exporting router
export default router;