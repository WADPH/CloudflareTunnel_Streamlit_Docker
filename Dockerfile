FROM ubuntu:22.04

# Base ENV
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    python3 python3-pip nginx curl \
    && rm -rf /var/lib/apt/lists/*

# streamlit
RUN pip3 install streamlit

# cloudflared
RUN mkdir -p /usr/share/keyrings && \
    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
      -o /usr/share/keyrings/cloudflare-main.gpg && \
    echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main' \
      > /etc/apt/sources.list.d/cloudflared.list && \
    apt-get update && apt-get install -y cloudflared && \
    rm -rf /var/lib/apt/lists/*

# nginx config
COPY nginx.conf /etc/nginx/sites-available/streamlit.conf
RUN rm /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/streamlit.conf /etc/nginx/sites-enabled/streamlit.conf

# app.py mounts from host, set  -v "C:\Path\To\File:/app"
WORKDIR /app

# entrypoint: Starting all 
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80
CMD ["/start.sh"]
