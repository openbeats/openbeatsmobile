// importing required packages
import express from "express";

// creating router instance
const router = express.Router();

// importing required controllers
import getLatestVersionController from "../controllers/getLatestVersion";
import addUpdateController from "../controllers/addUpdate";

// declaring necessary routes
router.get("/getlatestVersion", getLatestVersionController.getLatestVersion);
router.post("/addUpdate", addUpdateController.addUpdate);

// exporting router
export default router;