#!/bin/bash

prefix="/usr/local/bro/share/bro/site/botflex/blacklists/"
outfile_cnc_ip=$prefix"cnc_ip.txt"
outfile_cnc_url=$prefix"cnc_url.txt"

outfile_exploit_ip=$prefix"exploit_ip.txt"
outfile_exploit_url=$prefix"exploit_url.txt"
outfile_drive_by_download_url=$prefix"drive_by_download_url.txt"
outfile_bogon_subnet=$prefix"bogon_subnet.txt"

outfile_rbn_ip=$prefix"rbn_ip.txt"
outfile_rbn_subnet=$prefix"rbn_subnet.txt"

outfile_bad_ports=$prefix"bad_ports.txt"

# Empty the directory to create fresh blacklists every time
rm -R $prefix
mkdir $prefix

#CnC
#-----------------------------------------------------------------
# Cnc IP
wget -q -O- "https://spyeyetracker.abuse.ch/blocklist.php?download=ipblocklist" | 
sed '1,6d' >> $outfile_cnc_ip
wget -q -O- "https://palevotracker.abuse.ch/blocklists.php?download=ipblocklist" | 
sed '1d' >> $outfile_cnc_ip
wget -q -O- "https://zeustracker.abuse.ch/blocklist.php?download=ipblocklist" | 
sed '1,6d' >> $outfile_cnc_ip
wget -q -O- "http://www.malwaredomainlist.com/hostslist/ip.txt" | 
cat >> $outfile_cnc_ip

#CnC URL
wget -q -O- "https://spyeyetracker.abuse.ch/blocklist.php?download=domainblocklist" | 
sed '1,6d' >> $outfile_cnc_url
wget -q -O- "https://palevotracker.abuse.ch/blocklists.php?download=domainblocklist" | 
sed '1d' >> $outfile_cnc_url
wget -q -O- "https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist" | 
sed '1,6d' >> $outfile_cnc_url

#Exploit
#----------------------------------------------------------------------------
#Exploit IP's
wget -q -O- "http://www.ciarmy.com/list/ci-badguys.txt" | 
cat >> $outfile_exploit_ip
wget -q -O- "http://feeds.dshield.org/top10-2.txt" |
awk '{print $1}' >> $outfile_exploit_ip
wget -q -O- "http://tcats.stop-spam.org/sibl/sibl.txt" |
awk '{print $1}' >> $outfile_exploit_ip
wget -q -O- "www.openbl.org/lists/base.txt" | 
sed '1,4d' >> $outfile_exploit_ip
wget -q -O- "http://www.malwaredomainlist.com/hostslist/ip.txt" |
cat >> $outfile_exploit_ip
wget -q -O- "http://rules.emergingthreats.net/blockrules/compromised-ips.txt" |
cat >> $outfile_exploit_ip
wget -q -O- "http://rules.emergingthreats.net/blockrules/rbn-malvertisers-ips.txt" |
cat >> $outfile_exploit_ip

#Exploit URL's
wget -q -O- "http://www.malwaredomainlist.com/hostslist/hosts.txt" | 
sed '1,6d' | 
awk '{print $2}' >> $outfile_exploit_url


#Drive by download URL's
wget -q -O- "http://www.blade-defender.org/eval-lab/blade.csv" | 
cat | 
gawk -F',' '{print substr($9,9,length($9)-9)}' >> $outfile_drive_by_download_url

#BOGON SUBNETS
wget -q -O- "http://www.team-cymru.org/Services/Bogons/fullbogons-ipv4.txt" | 
sed '/^\#/d' >> $outfile_bogon_subnet

#RBN
#-----------------------------------------------------------------------
#RBN IP
wget -q -O- "http://doc.emergingthreats.net/pub/Main/RussianBusinessNetwork/RussianBusinessNetworkIPs.txt" | 
cat |
awk -v of1=$outfile_rbn_subnet -v of2=$outfile_rbn_ip '{if ( $1~/\// ) print $1 >> of1; else print $1 >> of2;}'

#Ports
#-----------------------------------------------------------------------
#Bad ports
wget -q -O- "http://feeds.dshield.org/topports.txt" |
awk '{print $2}' >> $outfile_bad_ports

#echo "First wget at: "`date()` 
#wget -i $infile_cnc_urls -O $outfile_cnc_urls
#echo "Second wget at: "`date()` 
