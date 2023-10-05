#Instalacion de apache cloudstack 4.18.0.0 en Rocky-9.2-x86_64-dvd.iso, adaptado de la guia que se encuentra en  http://docs.cloudstack.apache.org/en/latest/quickinstallationguide/qig.html

#!/bin/bash

#Comenzaremos haciendonos administrador para llevar a cabo toda la instalacion
#sudo su
#Actualizacion de paquetes
#dnf upgrade
#Instalacion de bridge utils y net-tools
#dnf install epel-release
#dnf install bridge utils net-tools
#Creacion de archivo de configuracio de red en /etc/sysconfig/network-scripts/ifcfg-cloudbr0
#r_red=/etc/sysconfig/network-scripts/ifcfg-cloudbr0
r_red=./prueba_shell
echo DEVICE=cloudbr0 > $r_red
echo TYPE=Bridge >> $r_red
echo ONBOOT=yes >> $r_red
echo BOOTPROTO=static >> $r_red
echo IPV6INIT=no >> $r_red
echo IPV6_AUTOCONF=no >> $r_red
echo DELAY=5 >> $r_red

gateway=""

for  ((i=1;i<4;i++)){
	gateway="$gateway.$(echo $1 | cut -f$i -d.)"
}
	gateway="$gateway.1"

echo IPADDR=$1 >> $r_red
echo GATEWAY=$(echo $gateway) >> $r_red   #$(echo $1 | cut -f4 -d.) >> r_red

echo NETMASK=255.255.255.0 >> $r_red
echo DNS1=8.8.8.8 >> $r_red
echo DNS2=8.8.4.4 >> $r_red
echo STP=yes >> $r_red
echo USERCTL=no >> $r_red
echo NM_CONTROLLED=no >> $r_red

#Creación de otro archuvo de configuracion de red

r_red2=/etc/sysconfig/network-scripts/ifcfg-$2

echo TYPE=Ethernet > $r_red2
echo BOOTPROTO=none >> $r_red2
echo DEFROUTE=yes >> $r_red2
echo NAME=$2 >> $r_red2
echo DEVICE=$2 >> $r_red2
echo ONBOOT=yes >> $r_red2
echo BRIDGE=cloudbr0 >> $r_red2

#5. Desactivamos la inicializacion al prender la maquina del demonio  NetworkManager, y lo detenemos.   

systemctl disable NetworkManager
systemctl stop NetworkManager

#6. Instalamos el demonio network-scripts
dnf install network-scripts --enablerepo=devel

#7. Activamos el demonio recien instalado y reiniciamos para cargar todos los cambios de configuracion
 
systemctl enable network
systemctl start network
#reboot 
#No parece conveniente reiniciar ante la ejecución de un script


#8. Realizamos un ping para corroborar que haya conexión a internet

#ping 8.8.8.8

#Si es exitoso significa que la configuración de red ha sido exitosa, igualmente al momento de realizar

#ip a
#nos debemos percatar del cambio hecho por cloudbr0


#9. Configuracion correcta del hostname, para esto es necesario modificar el archivo /etc/hosts y añadir en una nueva linea

echo $1 srvr1.cloud.priv >> /etc/hosts

#10. Se reinicia el demonio network

systemctl restart network

#se verifica el estado de hostname

hostanme --fdqn

#11. Configuramos SELinux, ejecutando en el shell

setenforce 0

#cambiamos la configuracion del archivo /etc/selinux/config para que sea igual que lo siguiente:

cat /etc/selinux/config > aux1
cat aux1 | sed 's/enforcing/permissive/' > /etc/selinux/config

#12. Configuración del repositorio de cloudstack
#Es necesario crear el archivo /etc/yum.repos.d/cloudstack.repo con el siguiente contenido

r_cloud=/etc/yum.repos.d/cloudstack.repo
echo [cloudstack] > $r_cloud
echo name=cloudstack >> $r_cloud
echo baseurl=http://download.cloudstack.org/centos/$releasever/4.18/ >> $r_cloud
echo enabled=1 >> $r_cloud
echo gpgcheck=0 >> $r_cloud

#13. Se instala nfs-utils

dnf install nfs-utils

# Se tienen que crear las siguientes carpetas

mkdir -p /export/primary
mkdir /export/secondary

#14. Se modifica el archivo /etc/idmapd.conf

cat /etc/idmapd.conf > aux2
cat aux2 | sed 's/#Domain = local.domain.edu/Domain = cloud.priv/' > /etc/idmapd.conf

echo Domain = cloud.priv >> /etc/idmapd.conf

#15. Se desactiva el demonio del firewall

sudo systemctl stop firewalld
sudo systemctl disable firewalld

#16. Se inicializan otros demonios necesarios
sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl start rpcbind
sudo systemctl start nfs-server

#17. Instalación de wget y obtención del repositorio de mysql

dnf install wget
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
dnf install mysql-server

#18. Modificar el archivo de configuracion de mysql en /etc/my.cnf añadiendo 

innodb_rollback_on_timeout=1
innodb_lock_wait_timeout=600
max_connections=350
log-bin=mysql-bin
binlog-format = 'ROW'



dnf install python3-pip


