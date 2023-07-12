import chromium from 'chrome-aws-lambda';

export class Test {
    constructor() {
        this.testBot();
    }
    async testBot(isHeadless: boolean = true) {
        try {
            console.log('Starting test');
            let execPath: any =  await chromium.executablePath;
            console.log(`Executable path is: ${execPath}`);
            // const browser = await playwright.launchChromium({ headless: isHeadless, args: ['--no-sandbox', '--disable-setuid-sandbox']});
            const browser = await chromium.puppeteer.launch({
                args: chromium.args,
                defaultViewport: chromium.defaultViewport,
                executablePath: execPath,
                headless: chromium.headless,
                ignoreHTTPSErrors: true,
            });
            console.log(`Browser is: ${browser}`);
            const page = await browser.newPage();
            console.log('Calling google.com');
            await page.goto('https://www.google.com');
            console.log('Taking screenshot');
            await page.screenshot({ path: 'google.png' });
            console.log('Took a screenshot of google.com');
            await browser.close();
            console.log('Test complete');
            console.log('Quit browser');
        } catch (err) {
            console.log(err);
        }
    }
}