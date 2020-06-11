import mongoose from 'mongoose';
import {
    config
} from './index';

export default async () => {
    // For Production Environment, Change mongodb url to mongodb atlas url
    const mongoUrl = config.MONGODB_URL;
    await mongoose
        .connect(mongoUrl, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
            useCreateIndex: true,
            useFindAndModify: false,
        })
        .then(() => {
            console.log('Connection Successful!');
        })
        .catch((err) => console.error('Mongo db connection failed!', err.message));
};