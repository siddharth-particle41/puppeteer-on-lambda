import 'source-map-support/register';
import { Test } from './p41/app/test';

const test = new Test();

export const handler = async (event: any) => {
    console.log(JSON.stringify(event));
    try {
        await test.testBot();
        return {
            statusCode: 200,
            body: JSON.stringify({
                message: 'Test complete'
            })
        };
    } catch (err) {
        console.log(err);
        return {
            statusCode: 500,
            body: JSON.stringify({
                message: 'Test failed'
            })
        };
    }
};

if (process.env.LOCAL) {
    new Test().testBot().then((resp) => { console.log(`Reponse is: ${resp}`) }).catch((err) => { console.log(err); });
}