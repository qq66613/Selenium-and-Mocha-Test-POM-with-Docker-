FROM node:18-slim

WORKDIR /app

# Make node_modules directory (useful when mounting volume)
RUN mkdir -p /app/node_modules

# Install Chrome dependencies + tools
RUN apt-get update && apt-get install -y \
    wget gnupg unzip curl ca-certificates \
    fonts-liberation libnss3 libxss1 libasound2 libatk-bridge2.0-0 libgtk-3-0 \
  && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' \
  && apt-get update && apt-get install -y google-chrome-stable \
  && rm -rf /var/lib/apt/lists/*

# Install ChromeDriver (chrome-for-testing)
RUN set -eux; \
    DRIVER_VERSION="$(curl -fsSL https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_STABLE)"; \
    wget -q -O /tmp/chromedriver.zip "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${DRIVER_VERSION}/linux64/chromedriver-linux64.zip"; \
    unzip /tmp/chromedriver.zip -d /tmp/chromedriver; \
    mv /tmp/chromedriver/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver; \
    chmod +x /usr/local/bin/chromedriver; \
    rm -rf /tmp/*

#memastikan chromedriver (dan tool lain di /usr/local/bin) bisa dipanggil cukup dengan nama perintahnya aja, tanpa path lengkap.    
ENV PATH="/usr/local/bin:${PATH}" 

# Copy package files and install Node deps
COPY package*.json ./
RUN npm install --no-audit --no-fund

# Copy project files (pages + test)
COPY pages/ pages/
COPY test/ test/
# copy other files if needed (optional)
COPY . .

# Default command runs tests
CMD ["npm", "test"]
