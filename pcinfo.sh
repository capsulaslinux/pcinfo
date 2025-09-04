#!/bin/bash

INTERFACE=$(ip route | grep "default" | awk '{print $5}')
USER=$(whoami)
HOST=$(hostname)
PC=$(hostname | grep "ipa")
fil="/home/$USER/$USER.txt"
fill="/home/$USER/$USER.csv"
prox=$(sed -n "3p" /etc/environment)
os=$(head -n 3 /etc/os-release)
SEARCH_DIR="/home/$USER/.mozilla/firefox"
search=$(find "$SEARCH_DIR" -type f -name "logins.json")
sshh=$(ls -lh "/var/log/auth.log")
logins=""


if [ -z "$INTERFACE" ]; then
    echo "Error en obtención de interfaz de red :(, realizar las comprobaciones manualmente"
    exit 1
fi

IP_ADDRESS=$(ip a show $INTERFACE | grep "inet " | awk '{print $2}')

FORTI_STATUS="No instalado"
GLPI_STATUS="No instalado"
VIRTUAL_STATUS="No instalado"
GOOGLE_STATUS="Sin Google Chrome"
FIREFOX_STATUS="Sin Firefox"
BRAVE_STATUS="Sin Brave"
ELEMENT_STATUS="Sin Element"
SSH_STATUS="SSH sin ejecucion"


if pidof element-desktop > /dev/null; then
   ELEMENT_STATUS="Element instalado"
fi


if pidof ssh > /dev/null; then
    SSH_STATUS="SSH en ejecución"
fi


if pidof firefox > /dev/null; then
    FIREFOX_STATUS="Firefox instalado"
fi


if pidof brave > /dev/null; then
    BRAVE_STATUS="Brave instalado"
fi





if systemctl is-active --quiet forticlient; then
    FORTI_STATUS="Corriendo"
fi

if systemctl is-active --quiet glpi; then
    GLPI_STATUS="Corriendo"
fi


if systemctl is-active --quiet virtualbox;then
    VIRTUAL_STATUS="Corriendo"
fi

GOOGLE=$(dpkg -l | grep chrome)
if [[ $GOOGLE != ""  ]]; then
   GOOGLE_STATUS="Existe Google Chrome en el ordenador"
else
   GOOGLE_STATUS="No existe instalación de Google Chrome en el ordenador"
fi

NOMACHINE=$(dpkg -l | grep nomachine)
if [[ $NOMACHINE != ""  ]]; then
   NOMACHINE_STATUS="Existe NoMachine en el ordenador"
else
   NOMACHINE_STATUS="No existe NoMachine en el ordenador"
fi


LIBREOFFICE=$(dpkg -l | grep libreoffice)
if [[ $LIBREOFFICE != ""  ]]; then
   LIBREOFFICE_STATUS="Libreoffice instalado"
else
   LIBREOFFICE_STATUS="No se halla Libreoffice en el ordenador"
fi


WPS=$(dpkg -l | grep wps)
if [[ $WPS != ""  ]]; then
   WPS_STATUS="WPS con: $WPS"
else
   WPS_STATUS="No se halla WPS en el ordenador"
fi








if [[ $search == "" ]]; then
    logins="sin datos"
else
    logins="con datos: $search"
fi

echo "* Usuari@: $USER" >> $fil
echo "* Dirección IP de la interfaz $INTERFACE es: $IP_ADDRESS" >> $fil
echo "* Dirección Proxy: $prox" >> $fil
echo "* S.O Utilizado: $os" >> $fil
echo "* Servicio FortiClient: $FORTI_STATUS" >> $fil
echo "* Servicio GLPI: $GLPI_STATUS" >> $fil
echo "* El host se halla en el dominio: $PC" >> $fil
echo "* Mensajeria Element: $ELEMENT_STATUS" >> $fil
echo "* Usuarios almacenados en navegador Firefox: $logins" >> $fil
echo "* Virtual Box: $VIRTUAL_STATUS" >> $fil
echo "* NoMachine: $NOMACHINE_STATUS" >> $fil
echo "* Instalación de Google Chrome: $GOOGLE_STATUS" >> $fil
echo "* Instalación de Firefox: $FIREFOX_STATUS" >> $fil
echo "* Instalación de Brave: $BRAVE_STATUS" >> $fil
echo "* Instalación de Libreoffice: $LIBREOFFICE_STATUS" >> $fil
echo "* Instalación de WPS: $WPS_STATUS" >> $fil
echo "************************" >> $fil

csv="$USER,$IP_ADDRESS,$sshh,$SSH_STATUS,$prox,$os,$FORTI_STATUS,$GLPI_STATUS,$PC,$ELEMENT_STATUS,$logins,$VIRTUAL_STATUS,$NOMACHINE_STATUS,$GOOGLE_STATUS,$FIREFOX_STATUS,$BRAVE_STATUS,$LIBREOFFICE_STATUS,$WPS_STATUS"
echo "$csv" >> $fill

cat $fill | nc -w 3 10.1.4.93 5523 > /dev/null


