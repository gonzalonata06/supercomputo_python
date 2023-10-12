#Instalacion de apache cloudstack 4.18.0.0 en Rocky-9.2-x86_64-dvd.iso, adaptado de la guia que se encuentra en  http://docs.cloudstack.apache.org/en/latest/quickinstallationguide/qig.html

# Para ejecutar este programa se necesitan dos argumentos

#sudo ./instalacion_cloudstack.sh direccion_ip nombre_en_tarjeta_de_red

#!/bin/bash

#Verificar que la ip e interfaz de red existan de verdad

if [ $(ip a l | grep $1 | wc -l) -eq 1 -a $(ip l l | grep $2 | wc -l ) -eq 1 ]
then
        echo "IP ingresada válida"

else
        echo IP y/o interfaz de red inválida
        exit 1
fi

#Verificar que se está instalando en un Rocky 9.2

if [ $(grep -i Rocky.*9  /etc/os-release | wc -l) -ge 1 ]
then
        echo Sistema operativo valido
else
        echo Sistema operativo incompatible
        exit 1
fi

f_instalacion(){
 ping -c1 8.8.8.8
 if [ $? -eq 0 ]
 then
        dnf list installed $1
        if [ $? -ne 0 ]
        then
                dnf -y install $1
        fi
else
        echo Sin conexion a internet para descargar paquete
fi
}


#Actualizacion de paquetes
dnf -y upgrade
#Instalacion de bridge utils y net-tools
#dnf -y install epel-release
f_instalacion epel-release
