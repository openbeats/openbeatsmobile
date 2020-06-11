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
exports.getLatestVersion = (req, res) => {
    try {

        // initiating global response instance
        globalRes = res;

        responseSendHandler({
            status: true,
            message: "Hi there!"
        });

    } catch (error) {
        consoleLogHandler("Fatal error in main Try/Catch: " + error, true);
        responseSendHandler({
            status: false,
            error: error
        });
    }
};

// handling promise rejection errors
process.on("unhandledRejection", (error) => {
    logConsole("Error: " + error, true);
});