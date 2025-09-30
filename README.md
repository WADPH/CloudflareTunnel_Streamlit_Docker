# CloudflareTunnel + Streamlit in Docker

<img width="1536" height="670" alt="scheme" src="https://github.com/user-attachments/assets/e69e7d71-43ff-4cc8-a8fb-6220b46c7495" />


## Quick Start

1. Copy all files from this repository to your host:
```bash
git clone https://github.com/WADPH/CloudflareTunnel_Streamlit_Docker
```` 
2. Go to the copied folder:
```bash
cd CloudflareTunnel_Streamlit_Docker
````
3. Before creating the docker image, be sure to change the tunnel token in the start.sh file! <br>
After run the command:
```bash
docker build -t my-streamlit-nginx .
````
4. Once the image has been built, you can run a container from it with the following parameters:
```bash
docker run -d -v "C:\path\to\file:/app" -p 80:80 my-streamlit-nginx
````
### You can also change the overall configuration of nginx or rewrite start.sh for your own purposes. <br> But in this case, you will need to start again from step 3 (i.e. download the image and run it).

# There are two ways to launch multiple Streamlit apps.
## Two or more Streamlit applications in ONE container (For Example: http:your_domain/app1/ and http:your_domain/app2/ )
### In order to run several applications on ONE container at once, you will need to make several changes.

1. Open start.sh from the copied repository. Now we have one command to run app.py <br>Let's add another one for the second one (be sure to specify a new port for each application):
```bash
streamlit run /app/app2.py --server.port=8503 --server.address=0.0.0.0 &
````
2. Currently, Nginx only proxies / to 8502.<br>Let's add a location for the second application and modify the location for the first application:
```bash
server {
    listen 80;

    if ($http_x_forwarded_proto = "http") {
        return 301 https://$host$request_uri;
    }

    access_log /var/log/nginx/streamlit_access.log;
    error_log /var/log/nginx/streamlit_error.log;

    # Changed ‘/’ to ‘/app1/’
    location /app1/ {
        proxy_pass http://127.0.0.1:8502/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 86400;
        client_max_body_size 100M;
    }

    # Added new app location
    location /app2/ {
        proxy_pass http://127.0.0.1:8503/; # Port for new app
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 86400;
        client_max_body_size 100M;
    }
}
````
3. Build docker image:
```bash
docker build -t my-streamlit-nginx .
````

4. Starting the container <br>
   All applications are located in one folder /app. <br>
   Streamlit listens to different ports, Nginx proxies to different locations.
```bash
docker run -d -v "C:\path\to\all_apps:/app" -p 80:80 my-streamlit-nginx

````


### Now, when you visit "http://your_host/app1/", you will see the first application, and "/app2/" will show the second one.

## Result
### To add another application:

1. Copy the new appX.py to /app (or the mounted folder).

2. Add the line streamlit run /app/appX.py --server.port=85XX ... & to start.sh.

3. Add location /appX/ { proxy_pass http://127.0.0.1:85XX/; ... } to nginx.conf.

4. Rebuild the image and start the container. <br>

This way, you can keep all applications in one container.<br>

## Two or more Streamlit applications in separate containers <br>For Example: <br>http://app1.your_domain.com and<br>http://app2.your_domain.com<br>

1. Simply run every container with specific port
```bash
# For first app (-p 80:... or your own port)
docker run -d -v "C:\path\to\app1:/app" -p 80:80 my-streamlit-nginx

# For second app (-p 81:... or your own port)
docker run -d -v "C:\path\to\app2:/app" -p 81:80 my-streamlit-nginx
````

2. Go to your Cloudflare Tunnel Settings. <br>
Add new Published application Route: <br>
Subdomain: Create new one <br>
Service: http://localhost:81 (or your own port) <br>

_So for "docker run -d -v "C:\path\to\app2:/app" -p 81:80 my-streamlit-nginx" you need set Service: http://localhost:81_ <br>
_And for example for "docker run -d -v "C:\path\to\app3:/app" -p 82:80 my-streamlit-nginx" you need set Service: http://localhost:82_ <br>




