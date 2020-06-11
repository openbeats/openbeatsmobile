// importing required modules
import mongoose from "mongoose";

// creating schema instance
const Schema = mongoose.Schema;

// creating model structure
const otaUpdateSchema = new Schema({
    versionCode: {
        vCode1: {
            type: Number,
            required: true,
            unique: false
        },
        vCode2: {
            type: Number,
            required: true,
            unique: false
        },
        vCode3: {
            type: Number,
            required: true,
            unique: false
        },
        buildNumber: {
            type: Number,
            required: true,
            unique: false
        }
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