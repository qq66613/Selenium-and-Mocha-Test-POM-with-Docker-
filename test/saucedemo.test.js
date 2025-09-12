// test/saucedemo.test.js
import { expect } from "chai";
import { By } from "selenium-webdriver";
import LoginPage from "../pages/login.page.js";
import { initDriver, quitDriver } from "./setup.js";

let driver;
let loginPage;

describe("SauceDemo - Login (POM)", function () {
  this.timeout(30000);

  before(async () => {
    driver = await initDriver();
  });

  after(async () => {
    await quitDriver();
  });

  beforeEach(async () => {
    loginPage = new LoginPage(driver);
    await loginPage.open();
  });

  it("should login successfully with valid credentials", async () => {
    await loginPage.login("standard_user", "secret_sauce");
    const inventoryTitle = await loginPage.getText(By.className("title"));
    expect(inventoryTitle).to.equal("Products");
  });

  
});
