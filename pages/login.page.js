// pages/login.page.js
import BasePage from "./base.pages.js";
import { By,until } from "selenium-webdriver";

export default class LoginPage extends BasePage {
  constructor(driver) {
    super(driver);
  }

  async usernameInput() {
    return await this.find(By.id("user-name"));
  }

  async passwordInput() {
    return await this.find(By.id("password"));
  }

  async loginButton() {
    return await this.find(By.id("login-button"));
  }

  async login(username, password) {
    await (await this.usernameInput()).sendKeys(username);
    await (await this.passwordInput()).sendKeys(password);
    await (await this.loginButton()).click();
  }

  async getError() {
  const locator = By.css('[data-test="error"]');
  await this.driver.wait(until.elementLocated(locator), 5000);
  await this.driver.wait(until.elementIsVisible(this.driver.findElement(locator)), 5000);
  const el = await this.driver.findElement(locator);
  return await el.getText();
  }

  async open() {
    await super.open("https://www.saucedemo.com/");
  }
}
