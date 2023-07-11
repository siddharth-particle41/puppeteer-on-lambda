import Chromium from 'chrome-aws-lambda';
import * as playwright from 'playwright-aws-lambda';

export class Test {
    constructor() {
        this.testBot();
    }
    async testBot(isHeadless: boolean = false) {
        console.log('Starting test');
        const browser = await playwright.launchChromium();
        console.log(`Browser is: ${browser}`);
        // const browser = await Chromium.puppeteer.launch({
        //     args: Chromium.args,
        //     defaultViewport: Chromium.defaultViewport,
        //     executablePath: await Chromium.executablePath,
        //     headless: Chromium.headless,
        // });
        const page = await browser.newPage({ strictSelectors: false });
        console.log('Calling google.com');
        await page.goto('https://www.google.com');
        console.log('Taking screenshot');
        await page.screenshot({ path: 'google.png' });
        console.log('Took a screenshot of google.com');
        await browser.close();
        console.log('Test complete');
        console.log('Quit browser');
    }
}