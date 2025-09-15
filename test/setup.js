// test/setup.js
import { Builder } from "selenium-webdriver";
import { Options , ServiceBuilder } from "selenium-webdriver/chrome.js";

let driver;

export async function initDriver() {
  if (!driver) {
    const options = new Options()
      .addArguments("--headless=new")
      .addArguments("--no-sandbox")
      .addArguments("--disable-dev-shm-usage")
      .addArguments("--disable-gpu")
      .addArguments("--remote-debugging-port=9222")
      .addArguments(`--user-data-dir=/tmp/chrome-profile-${Date.now()}`);


    const service = new ServiceBuilder(
      process.env.CHROMEDRIVER_PATH || "/usr/local/bin/chromedriver"
    );

    driver = await new Builder()
      .forBrowser("chrome")
      .setChromeOptions(options)
      .setChromeService(service)
      .build();
  }
  return driver;
}

export async function quitDriver() {
  if (driver) {
    await driver.quit();
    driver = null;
  }
}

export { driver };
