# FetchAI Mainnet Node Setup


### Install Prerequisites
```
sudo apt update && sudo apt upgrade -y  
sudo apt-get install -y make gcc lz4  
wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz  
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz  
rm go1.23.4.linux-amd64.tar.gz  
```

### Create a user and login to run the setup script
```
useradd -U -m -d /home/fetch -s /bin/bash fetch
su fetch && cd ~
```
