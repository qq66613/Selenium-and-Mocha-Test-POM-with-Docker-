// pages/base.pages.js
import { until } from "selenium-webdriver";

export default class BasePage {
  constructor(driver) {
    this.driver = driver;
  }

  async open(url) {
    await this.driver.get(url);
  }

  async find(locator, timeout = 10000) {
    await this.driver.wait(until.elementLocated(locator), timeout);
    return await this.driver.findElement(locator);
  }

  async type(locator, text) {
    const el = await this.find(locator);
    await el.clear();
    await el.sendKeys(text);
  }

  async click(locator) {
    const el = await this.find(locator);
    await el.click();
  }

  async getText(locator) {
    const el = await this.find(locator);
    return await el.getText();
  }
}
