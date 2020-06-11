// importing packages
import express from "express";

// importing function files
import dbconfig from './config/db';
import {
    config
} from "./config";

// importing required routes
import otaUpdateRoute from "./routes/otaUpdate";

// creating middleware instances
const app = express();
app.use(express.json());

// initiating database connection 
dbconfig();

// declaring major routes
app.use("/obsmobileserver", otaUpdateRoute);

// start listening on port
app.listen(process.env.PORT || config.PORT, () => {
    console.log(`OBS Mobile Update Server is running on ${process.env.PORT || config.PORT}!`);
});