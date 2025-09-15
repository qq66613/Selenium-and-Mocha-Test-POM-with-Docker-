FROM node:20

WORKDIR /app

# Install dependencies & Google Chrome
RUN apt-get update && apt-get install -y \
    wget gnupg unzip curl ca-certificates \
    fonts-liberation libnss3 libxss1 libasound2 libatk-bridge2.0-0 libgtk-3-0 \
  && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' \
  && apt-get update && apt-get install -y google-chrome-stable \
  && rm -rf /var/lib/apt/lists/*

# Install ChromeDriver (match with Chrome version)
RUN set -eux; \
    DRIVER_VERSION="$(curl -fsSL https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_STABLE)"; \
    wget -q -O /tmp/chromedriver.zip "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${DRIVER_VERSION}/linux64/chromedriver-linux64.zip"; \
    unzip /tmp/chromedriver.zip -d /tmp/chromedriver; \
    mv /tmp/chromedriver/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver; \
    chmod +x /usr/local/bin/chromedriver; \
    rm -rf /tmp/*

# Tambah path Chrome & Chromedriver
ENV PATH="/usr/local/bin:${PATH}" \
    CHROME_BIN="/usr/bin/google-chrome" \
    CHROMEDRIVER_PATH="/usr/local/bin/chromedriver"

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy project files
COPY . .

# Default command runs tests
CMD ["npm", "test"]
