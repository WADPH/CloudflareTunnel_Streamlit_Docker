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
