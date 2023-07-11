import * as puppeteer from 'puppeteer';

export class Test {
    constructor() {
        this.testBot();
    }
    async testBot(isHeadless: boolean = false) {
        const browser = await puppeteer.launch({ headless: isHeadless, args: ['--no-sandbox', '--disable-setuid-sandbox']});
        const page = await browser.newPage();
        console.log('Invoking google.com');
        await page.goto('https://www.google.com');
        console.log('Taking screenshot');
        await page.screenshot({ path: 'google.png' });
        await browser.close();
    }
}