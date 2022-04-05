#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
echo -e "${RED}Enter domain name${NC}"

#Storing the domain name to a variable
read domain
#Creating a directory with the entered domain name
mkdir $domain

#keys for censys (add api key and secret key in the variables below)  
API_key=''
S_key=''

#Running Sublister
echo "+--------------------------------Subdomains By Sublister-------------------------------------+"
python3 tools/Sublist3r/sublist3r.py -d $domain -o $domain/sublister$domain.txt
echo -e  "\n\n ${RED}Sublister Ended..${NC}"

#Running Assetfinder
echo "+--------------------------------Subdomains By Assetfinder-------------------------------------+"

assetfinder -subs-only $domain >> $domain/assetfinder$domain.txt
echo -e "\n\n ${RED}Assetfinder Ended..${NC}"


#Running Censys 
echo "+--------------------------------Subdomains By Censys-------------------------------------+"
export CENSYS_API_ID=$API_key
export CENSYS_API_SECRET=$S_key
python3 tools/censys-subdomain-finder/censys-subdomain-finder.py $domain -o $domain/censys$domain.txt
echo -e "\n\n ${RED}Censys Ended..${NC}"

#Running Amass
echo "+--------------------------------Subdomains By Amass-------------------------------------+"
amass enum -passive -d $domain -o $domain/amass$domain.txt
echo -e "\n\n ${RED}Amass Ended..${NC}"

#Running SubFinder
echo "+--------------------------------Subdomains By SubFinder-------------------------------------+"
subfinder -d $domain -o $domain/subfinder$domain.txt
echo -e "\n\n ${RED}Subfinder Ended..${NC}"

#Running CT
echo "+--------------------------------Subdomains By CT-------------------------------------+"
python3 tools/bugcrowd-levelup-subdomain-enumeration/subdomain_enum_crtsh.py --domains $domain >> $domain/ct$domain.txt
echo -e "\n\n ${RED}CT Ended..${NC}"

#Running CTFR
echo "+--------------------------------Subdomains By CTFR-------------------------------------+"
python3 tools/ctfr/ctfr.py -d $domain -o $domain/ctfr$domain.txt
echo -e "\n\n ${RED}CTFR Ended..${NC}"

#Running Wayback
echo "+--------------------------------Subdomains By Wayback-------------------------------------+"
curl -s "http://web.archive.org/cdx/search/cdx?url=*.$domain/*&output=text&fl=original&collapse=urlkey" |sort| sed -e 's_https*://__' -e "s/\/.*//" -e 's/:.*//' -e 's/^www\.//' | uniq >> $domain/wayback$domain.txt
echo -e "\n\n ${RED}Wayback Ended..${NC}"


#Running FDNS
echo "+--------------------------------Subdomains By Rapid7 FDNS-------------------------------------+"
cat tools/2019-10-27-1572199582-fdns_cname.json.gz | pigz -dc | grep -E "\.$domain" | jq .name | uniq > $domain/fdns$domain.txt
sed 's/\"//g' $domain/fdns$domain.txt > $domain/fdns_new$domain.txt
echo -e "\n\n ${RED}Rapid7 FDSN Ended..${NC}"

echo "Combining all the Files"
cd $domain
cat sublister$domain.txt fdns_new$domain.txt assetfinder$domain.txt censys$domain.txt amass$domain.txt subfinder$domain.txt ct$domain.txt ctfr$domain.txt wayback$domain.txt > all.txt
sort all.txt | uniq > all2.txt
sed 's/*//g' all2.txt > all3.txt
sed 's/^\.//' all3.txt > finalsub.txt
rm -f all.txt all2.txt all3.txt


#Checking for live hosts
echo "+--------------------------------Check for live hosts-------------------------------------+"
cat finalsub.txt | sort -u | httprobe | tee live.txt
sort live.txt | uniq > live1.txt
sed 's/*//g' live1.txt > live2.txt
sed 's/^\.//' live2.txt > live$domain.txt 


#Running Nuclie
echo "+--------------------------------Nuclie-------------------------------------+"
mkdir nuclie
cd ..
nuclei -list $domain/live$domain.txt -o $domain/nuclie/nuclei$domain.txt
