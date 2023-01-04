#!/bin/bash

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y git
sudo apt-get install renameutils
sudo apt-get install -y python3-pip
sudo apt-get install python-dnspython
apt-get install dnsutils -y
gem install colorize
sudo apt-get install -y libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
sudo apt-get install -y build-essential libssl-dev libffi-dev python-dev
sudo apt-get install -y python-setuptools
apt install curl
sudo apt-get install git gcc make libpcap-dev
apt-get install ruby-full
pip install feedparser
pip install awscli
pip3 install fierce
sudo pip install pyopenssl
sudo apt-get install pigz

mkdir tools
cd tools


#httprobe

echo "Installing httprobe"
GO111MODULE=on go install github.com/tomnomnom/httprobe@latest
echo "Httprobe Done."


#Sublister

echo "Installing Sublister"
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r*
sudo pip install -r requirements.txt
echo "Sublist3r Done."

#Assetfinder

echo "Installing Assetfinder"
cd ..
GO111MODULE=on go install github.com/tomnomnom/assetfinder@latest
echo "Done setting UP the Assetfinder"

#Subfinder

echo "Installing Subfinder"
GO111MODULE=on go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
echo "Subfinder Done"

#Censys

echo "Installing Censys"
cd ..
git clone https://github.com/appsecco/bugcrowd-levelup-subdomain-enumeration.git
echo "Censys Done"

#Amass

echo "Installing Amass"
GO111MODULE=on go get -u github.com/OWASP/Amass/...
echo "Amass Done"

#AltDNS

echo "Installing AltDNS"
cd Tools/
git clone https://github.com/infosec-au/altdns.git
cd altdns
pip install -r requirements.txt
echo "AltDNS Done"


#CTFR

echo "Installing CTFR"
cd ..
git clone https://github.com/UnaPibaGeek/ctfr.git
cd ctfr
pip3 install -r requirements.txt
echo "CTFR Done"


#Censys

echo "Installing Censys"
git clone https://github.com/christophetd/censys-subdomain-finder.git
cd censys-subdomain-finder
pip install -r requirements.txt
echo "Censys Done"

#FDNS

echo "Downloading FDNS dataset"
cd ..
wget https://opendata.rapid7.com/sonar.fdns_v2/2019-10-27-1572199582-fdns_cname.json.gz


#Nuclei

echo "Installing Nuclei"
GO111MODULE=on go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
echo "Done setting UP the Nuclei"

#Feroxbuster

echo "Installing Feroxbuster"
sudo apt install -y feroxbuster
echo "Done feroxbuster"
