## Deploy the nodejs application manually
Clone the repository and build a docker image from it using following commands. This assumes that you're using an Ubuntu operating system.

```
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce


git clone https://github.com/npsoni88/devops-monitoring.git

cd devops-monitoring/forethought-app
docker build . -t IMAGE-NAME (replace image name with your name)
docker run -d --name my-container -p 80:8080 IMAGE-NAME (replace image name with your name)

```
