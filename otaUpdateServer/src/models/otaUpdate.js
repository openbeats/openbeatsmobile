// importing required modules
import mongoose from "mongoose";

// creating schema instance
const Schema = mongoose.Schema;

// creating model structure
const otaUpdateSchema = new Schema({
    versionCode: {
        type: String,
        required: true,
        unique: true
    },
    accessLink: {
        type: String,
        required: true,
        unique: true
    },
    changeLog: {
        type: Schema.Types.Array,
        required: true
    }
}, {
    timestamps: true,
}, );

// exporting model based on the current schema
module.exports = mongoose.model("otaUpdate", otaUpdateSchema);