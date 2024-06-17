#!/bin/bash

colores(){
    R1=$(tput setaf 201)
    R2=$(tput setaf 200)
    R3=$(tput setaf 199)
    R4=$(tput setaf 198)
    R5=$(tput setaf 197)
    R6=$(tput setaf 196)
    V1=$(tput setaf 34)
    V2=$(tput setaf 70)
    V3=$(tput setaf 106)
    V4=$(tput setaf 142)
    V5=$(tput setaf 178)
    N1=$(tput setaf 214)
    RESET=$(tput sgr0)
}

banner(){
    echo -e "
${R1} @@@@@@@  @@@@@@  @@@@@@@  @@@  @@@  @@@@@@   @@@@@@ @@@@@@@
${R2}   @@!   @@!  @@@ @@!  @@@ @@!  @@@ @@!  @@@ !@@       @@!
${R3}   @!!   @!@  !@! @!@!!@!  @!@!@!@! @!@  !@!  !@@!!    @!!
${R4}   !!:   !!:  !!! !!: :!!  !!:  !!! !!:  !!!     !:!   !!:
${R5}    :     : :. :   :   : :  :   : :  : :. :  ::.: :     :
${RESET}"
}

panel(){
    echo -e "${R5}Parámetros disponibles:\n${V1} - ${V2}install\n - ${V3}start\n - ${V4}stop\n - ${V5}check\n - ${N1}change\n${RESET}"
}

installhs(){
    grep "^HiddenServicePort 80 127.0.0.1:80$" /etc/tor/torrc > /dev/null
    if [ $? -ne 0 ]; then
        echo -e "${R6}[+] Parece que no tienes ningun hidden service configurado en /etc/tor/torrc${RESET}"
        echo -e "${R6}[+] Te lo configuro:${RESET}"
        echo "HiddenServiceDir /var/lib/tor/hidden_service/" >> /etc/tor/torrc
        echo "HiddenServicePort 80 127.0.0.1:80" >> /etc/tor/torrc
    else
        echo -e "${V1}[+] Parece que tienes un hidden service configurado en /etc/tor/torrc${RESET}"
    fi
}

starths(){
    echo -e "${V1}[+] Levantando hidden service.${V3}"
    systemctl restart tor
    status=`systemctl status tor | grep active`
    echo -e "${V4}[+] Levantado. $status${V5}"
    echo -e "${N1}[+] Dirección onion generada:${RESET}"
    sleep 1
    generated_url=`cat /var/lib/tor/hidden_service/hostname`
    echo -e "${R5}$generated_url${RESET}"
}

stophs(){
    echo -e "${R6}[+] Parando hidden service...${RESET}"
    systemctl stop tor
    status=`systemctl status tor | grep active`
    echo -e "${V1}[+] Parado.${RESET}"
}

checkhs(){
    echo -e "${V1}[+] La direccion del hidden service es:"
    generated_url=`cat /var/lib/tor/hidden_service/hostname`
    echo -e "${V3}$generated_url"
    echo -e "\n${V4}[+] Configuración de puertos en /etc/tor/torrc:${V5}"
    grep "HiddenServicePort" /etc/tor/torrc | tail -n 2
}

changehs(){
    echo -e "${V1}[+] Cambiando direccion del hidden service..."
    systemctl stop tor
    rm -rf /var/lib/tor/hidden_service/*
    systemctl start tor
    echo -e "${V3}[+] Tu nueva direccion es:"
    sleep 1
    generated_url=`cat /var/lib/tor/hidden_service/hostname`
    echo -e "${V6}$generated_url${RESET}"
}

listenhs(){
    echo -e "${R6}[+] Configurando el servicio oculto para apuntar al listener de Netcat en el puerto $port...${RESET}"

    if grep -q "HiddenServicePort" /etc/tor/torrc; then
        # Sobrescribir las líneas de configuración
        echo -e "${R6}[+] Sobrescribiendo la configuración en el archivo torrc...${RESET}"
        sed -i "/HiddenServicePort/c\HiddenServicePort 80 127.0.0.1:$port" /etc/tor/torrc
        # Reiniciar el servicio Tor para aplicar los cambios
        systemctl restart tor
    else
        # Agregar las líneas de configuración si no existen
        echo -e "${R6}[+] Configurando el archivo torrc...${RESET}"
        echo "HiddenServiceDir /var/lib/tor/hidden_service/" >> /etc/tor/torrc
        echo "HiddenServicePort 80 127.0.0.1:$port" >> /etc/tor/torrc
        # Reiniciar el servicio Tor para aplicar los cambios
        systemctl restart tor
    fi
}

start(){
    [ "$(id -u)" != "0" ] && echo -e "${R6}[X] Este script debe ser ejecutado como root${RESET}" && exit 1
    command -v tor >/dev/null 2>&1 || { echo >&2 "${R6}[X] Tor no está instalado en el sistema.${RESET}"; exit 1; }
}

cmd=$1
port=4444
if [ -z "$1" ]; then
    colores
    banner
    panel
    exit 1
fi

opciones(){
    if [ $cmd = "start" ]; then
        starths
    elif [ $cmd = "stop" ]; then
        stophs
    elif [ $cmd = "change" ]; then
        changehs
    elif [ $cmd = "check" ]; then
        checkhs
    elif [ $cmd = "install" ]; then
        installhs
    elif [ $cmd = "listen" ]; then
        listenhs
    elif [ $cmd = "" ]; then
        echo -e "${R6}Parámetro inválido.${RESET}"
    else
        echo -e "${R6}Parámetro inválido.${RESET}"
    fi
}

colores
banner
start
opciones
