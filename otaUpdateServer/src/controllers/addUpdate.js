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
const responseSendHandler = (responseBody, responseType) => {
    if (!globalRes.headersSent) {
        switch (responseType) {
            case 1:
                globalRes.send({
                    status: false,
                    message: "Please send updated version information"
                });
                break;
            case 2:
                globalRes.send({
                    status: true
                });
                break;
        }
    } else
        consoleLogHandler("Attempted to send response multiple times");
}

// inserts the data into the database
const insertData = async (vCode1, vCode2, vCode3, buildNumber, accessLink, changeLog, OTAUpdate) => {
    // creating object to insert into database
    const documentObj = {
        versionCode: {
            vCode1: vCode1,
            vCode2: vCode2,
            vCode3: vCode3,
            buildNumber: buildNumber
        },
        accessLink: accessLink,
        changeLog: changeLog
    };
    // inserting data into database
    const otaUpdateDoc = new OTAUpdate(documentObj);
    await otaUpdateDoc.save();
};

exports.addUpdate = async (req, res) => {

    try {
        // initiating global response instance
        globalRes = res;

        // getting parameters from request
        const versionCode = req.body.versionCode;
        const accessLink = req.body.accessLink;
        const changeLog = req.body.changeLog;

        // processing version code
        const versionCodeSplit = versionCode.split(".");
        const vCode1 = parseInt(versionCodeSplit[0]);
        const vCode2 = parseInt(versionCodeSplit[1]);
        const vCode3 = parseInt(versionCodeSplit[2].split('+')[0]);
        const buildNumber = parseInt(versionCodeSplit[2].split('+')[1]);

        // getting the latest update from the database
        const latestUpdate = await OTAUpdate.findOne().sort({
            _id: -1
        }).limit(1).exec();

        // checking if there are any records in database
        if (latestUpdate === null) {

            await insertData(vCode1, vCode2, vCode3, buildNumber, accessLink, changeLog, OTAUpdate);
            responseSendHandler({}, 2);
        } else {
            // checking if the update meets the required parameters
            if (vCode1 > latestUpdate.versionCode.vCode1 && accessLink !== latestUpdate.accessLink) {
                await insertData(vCode1, vCode2, vCode3, buildNumber, accessLink, changeLog, OTAUpdate);
                responseSendHandler({}, 2);
            } else if (vCode2 > latestUpdate.versionCode.vCode2 && accessLink !== latestUpdate.accessLink) {
                if (vCode1 === latestUpdate.versionCode.vCode1) {
                    await insertData(vCode1, vCode2, vCode3, buildNumber, accessLink, changeLog, OTAUpdate);
                    responseSendHandler({}, 2);
                } else
                    responseSendHandler({}, 1);
            } else if (vCode3 > latestUpdate.versionCode.vCode3 && accessLink !== latestUpdate.accessLink) {
                if (vCode1 === latestUpdate.versionCode.vCode1 && vCode2 === latestUpdate.versionCode.vCode2) {
                    await insertData(vCode1, vCode2, vCode3, buildNumber, accessLink, changeLog, OTAUpdate);
                    responseSendHandler({}, 2);
                } else
                    responseSendHandler({}, 1);
            } else if (buildNumber > latestUpdate.versionCode.buildNumber && accessLink !== latestUpdate.accessLink) {
                if (vCode1 === latestUpdate.versionCode.vCode1 && vCode2 === latestUpdate.versionCode.vCode2 && vCode3 === latestUpdate.versionCode.vCode3) {
                    await insertData(vCode1, vCode2, vCode3, buildNumber, accessLink, changeLog, OTAUpdate);
                    responseSendHandler({}, 2);
                } else
                    responseSendHandler({}, 1);
            } else
                responseSendHandler({}, 1);
        }

    } catch (error) {
        consoleLogHandler("Fatal error in main Try/Catch: " + error, true);
        responseSendHandler({
            status: false,
            Error: error
        });
    }

};