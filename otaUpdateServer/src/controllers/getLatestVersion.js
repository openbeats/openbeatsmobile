// importing required models
import OTAUpdate from "../models/otaUpdate";

// declating global res instance
let globalRes;

// console log handler
const consoleLogHandler = (message, isErrorLog) => {
    if (isErrorLog)
        console.log(message);
    else
        console.log(message);
};

// response sending handler
const responseSendHandler = (responseBody) => {
    if (!globalRes.headersSent) {
        globalRes.send(responseBody);
    } else
        consoleLogHandler("Attempted to send response multiple times");
}

// declaring main controller function
exports.getLatestVersion = async (req, res) => {
    try {

        // initiating global response instance
        globalRes = res;

        // getting the latest update from the database
        const latestUpdate = await OTAUpdate.findOne().sort({
            _id: -1
        }).limit(1).exec();

        if (latestUpdate !== null) {
            responseSendHandler({
                status: true,
                data: latestUpdate
            });
        } else {
            responseSendHandler({
                status: false,
                message: "No versioning data found on server"
            });
        }



    } catch (error) {
        consoleLogHandler("Fatal error in main Try/Catch: " + error, true);
        responseSendHandler({
            status: false,
            Error: error.toString()
        });
    }
};

// handling promise rejection errors
process.on("unhandledRejection", (error) => {
    logConsole("Error: " + error, true);
});