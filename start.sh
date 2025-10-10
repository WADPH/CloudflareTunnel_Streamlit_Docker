#!/bin/bash
#Uncomment this If you have requierement.txt
#pip install --no-cache-dir -r requirements.txt 
streamlit run /app/app.py --server.port=8502 --server.address=0.0.0.0 &
nginx -g 'daemon off;' &
cloudflared tunnel --no-autoupdate run --token Your_CloudflareTunnel_Token &
wait -n
