# pcinfo
Get the basic info about ip, os version, name user, proxy and some installed applications (Virtual Box, Element, FortiClient, GLPI, NoMachinne, Google Chrome, Firefox, Brave, LibreOffice and WPS).

You don't need to be "root" for running this little script, just type: bash pcinfo.sh 

Note 1.- This script send results to remote server automatically, but if you don't want to proceed the step, just comment or remove the last three lines as:

#csv="$USER,$IP_ADDRESS,$sshh,$SSH_STATUS,$prox,$os,$FORTI_STATUS,$GLPI_STATUS,$PC,$ELEMENT_STATUS,$logins,$VIRTUAL_STATUS,$NOMACHINE>
#echo "$csv" >> $fill
#cat $fill | nc -w 3 10.1.4.93 5523 > /dev/null

Note 2.- If you want to get the result in remote server, just allow the last three lines (change the IP and port) as:

csv="$USER,$IP_ADDRESS,$sshh,$SSH_STATUS,$prox,$os,$FORTI_STATUS,$GLPI_STATUS,$PC,$ELEMENT_STATUS,$logins,$VIRTUAL_STATUS,$NOMACHINE>
echo "$csv" >> $fill
cat $fill | nc -w 3 10.1.4.93 5523 > /dev/null

  Details
    - nc = netcat
    - -w 3 = wait 3 seconds if there is no activity occurs.

After that, in remote linux system, allow connection with netcat and change the port:

nc -k -l 5523 > /tmp/prueba.txt

  Details:
    - nc = netcat
    - -k = keep the connect
    - -l = listen
    - 5523 = aleatory port number
    - >/tmp/prueba.txt = destination file, you can change the name and extension
