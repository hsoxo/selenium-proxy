FROM python:3.11-slim

# 环境变量设置
ENV DEBIAN_FRONTEND=noninteractive

# 安装 Chrome 所需依赖
RUN apt-get update && apt-get install -y \
    wget gnupg unzip fonts-liberation \
    libnss3 libxss1 libasound2 libatk-bridge2.0-0 \
    libgtk-3-0 libx11-xcb1 libgbm1 libxcomposite1 libxdamage1 libxrandr2 libu2f-udev \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# 安装 Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get update && apt install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

# 安装 Python 依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 拷贝代码
COPY main.py /app/main.py
WORKDIR /app

# 运行 FastAPI 服务
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
