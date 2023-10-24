#Instalacion de apache cloudstack 4.18.0.0 en Rocky-9.2-x86_64-dvd.iso, adaptado de la guia que se encuentra en  http://docs.cloudstack.apache.org/en/latest/quickationguide/qig.html

# Para ejecutar este programa se necesitan dos argumentos

#sudo ./instalacion_cloudstack.sh direccion_ip nombre_interfaz_de_red

#!/bin/bash


for arg in "$a" #en todos los argumentos que han entrado
do
    if [ "$arg" == "--help" ] || [ "$arg" == "-h" ] 
    then
        echo "Uso: sudo ./instalacion_cloudstack.sh direccion_ip nombre_interfaz_de_red"
    fi
done


#Verificar que la ip e interfaz de red existan de verdad

if [ $(echo $(ip a l | grep -c "$1/")) = "1" ] && [ $(echo $(ip l l | grep -c "$2:")) = "1" ]
then
	echo "IP e interfaz de red ingresadas válidas"
	
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
 ping -c1 8.8.8.8 > /dev/null 2>&1  
 if [ $? = '0' ]
 then
	dnf list installed $1 
	if [ $? != '0' ]
	then
		dnf -y install $1 $2 2>> err_ins_cloudstack.txt
		if [ $? != '0' ]
		then
			echo "Error en $1 al momento de instalar, las lineas superiores a ésta muestran los errores"

		fi
	else
  		echo "El paquete $1 ya esta instalado"
	fi
else
	echo Sin conexion a internet para descargar paquete
fi
}

f_log(){

	if [ $? != '0' ]
	then
		echo "Error en $1 $2 $3 al ejecutar, las lineas superiores a ésta muestran los errores" 2>> err_ins_cloudstack.txt
	fi

}

#Actualizacion de paquetes

dnf -y upgrade 2>> err_ins_cloudstack.txt
f_log dnf -y upgrade

#Instalacion de bridge utils y net-tools

f_instalacion epel-release
f_instalacion bridge-utils 
f_instalacion net-tools

#Creacion de archivo de configuracio de red en /etc/sysconfig/network-scripts/ifcfg-cloudbr0
r_red=/etc/sysconfig/network-scripts/ifcfg-cloudbr0

echo DEVICE=cloudbr0 > $r_red
echo TYPE=Bridge >> $r_red
echo ONBOOT=yes >> $r_red
echo BOOTPROTO=static >> $r_red
echo IPV6INIT=no >> $r_red
echo IPV6_AUTOCONF=no >> $r_red
echo DELAY=5 >> $r_red

#gateway=""

#gateway="$(echo $1 | cut -f1 -d.)"

#for  ((i=2;i<4;i++)){
	#gateway="$gateway.$(echo $1 | cut -f$i -d.)"
#}
#	gateway="$gateway.1"

echo IPADDR=$1 >> $r_red
#echo GATEWAY=$(echo $gateway) >> $r_red   
echo NETMASK=255.255.255.0 >> $r_red
echo DNS1=8.8.8.8 >> $r_red
echo DNS2=8.8.4.4 >> $r_red
echo STP=yes >> $r_red
echo USERCTL=no >> $r_red
echo NM_CONTROLLED=no >> $r_red

#Creación de otro archivo de configuracion de red

r_red2=/etc/sysconfig/network-scripts/ifcfg-$2

echo TYPE=Ethernet > $r_red2
echo BOOTPROTO=none >> $r_red2
echo DEFROUTE=yes >> $r_red2
echo NAME=$2 >> $r_red2
echo DEVICE=$2 >> $r_red2
echo ONBOOT=yes >> $r_red2
echo BRIDGE=cloudbr0 >> $r_red2

#Creacion del archivo de configuracion para la interfaz que se conecta a internet

subip_int=$(echo $(ip r l | grep -o "def.*dev.*[0-9].proto" | cut -f3 -d" " | cut -f1 -d.))

for  ((i=2;i<3;i++)){
	subip_int="$subip_int.$(echo $(ip r l | grep -o "def.*dev.*[0-9].proto" | cut -f3 -d" " | cut -f$i -d.))"
}


interfaz_internet=$(echo $(ip r l | grep -o "def.*dev.*[0-9].proto" | cut -f5 -d" "))
ip_int=$(echo $(ip a l | grep -o "inet.*$subip_int.[0-9]\{1,3\}/" | tr -d "/" | cut -f2 -d" "))
gateway=""

gateway="$(echo $ip_int | cut -f1 -d.)"

for  ((i=2;i<4;i++)){
        gateway="$gateway.$(echo $ip_int | cut -f$i -d.)"
}
        gateway="$gateway.1"


if [ "$ip_int" != "$2" ]
then 
	echo "DEVICE=$interfaz_internet" > /etc/sysconfig/network-scripts/ifcfg-$interfaz_internet
	echo "IPADRR=$ip_int" >> /etc/sysconfig/network-scripts/ifcfg-$interfaz_internet
	echo "NETMASK=255.255.255.0" >> /etc/sysconfig/network-scripts/ifcfg-$interfaz_internet
	echo "GATEWAY=$gateway" >> /etc/sysconfig/network-scripts/ifcfg-$interfaz_internet
fi

#5. Desactivamos la inicializacion al prender la maquina del demonio  NetworkManager, y lo detenemos.   

systemctl disable NetworkManager 2>> err_ins_cloudstack.txt
f_log systemctl disable NetworkManager 

systemctl stop NetworkManager 2>> err_ins_cloudstack.txt
f_log systemctl stop NetworkManager

#6. Instalamos el demonio network-scripts
f_instalacion network-scripts --enablerepo=devel

#7. Activamos el demonio recien instalado y reiniciamos para cargar todos los cambios de configuracion
 
systemctl enable network 2>> err_ins_cloudstack.txt
f_log systemctl enable network
systemctl start network 2>> err_ins_cloudstack.txt
f_log systemctl start network
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

systemctl restart network 2>> err_ins_cloudstack.txt
f_log systemctl restart network

#se verifica el estado de hostname

#hostaname --fdqn

#11. Configuramos SELinux, ejecutando en el shell

setenforce 0 2>> err_ins_cloudstack.txt
f_log setenforce 0 

#cambiamos la configuracion del archivo /etc/selinux/config para que sea igual que lo siguiente:

cat /etc/selinux/config > aux1
cat aux1 | sed 's/enforcing/permissive/' > /etc/selinux/config
rm aux1

#12. Configuración del repositorio de cloudstack
#Es necesario crear el archivo /etc/yum.repos.d/cloudstack.repo con el siguiente contenido

r_cloud=/etc/yum.repos.d/cloudstack.repo
echo [cloudstack] > $r_cloud
echo name=cloudstack >> $r_cloud
echo 'baseurl=http://download.cloudstack.org/centos/$releasever/4.18/' >> $r_cloud
echo enabled=1 >> $r_cloud
echo gpgcheck=0 >> $r_cloud

#13. Se instala nfs-utils

f_instalacion nfs-utils

# Se tienen que crear las siguientes carpetas

mkdir -p /export/primary
mkdir /export/secondary

#14. Se modifica el archivo /etc/idmapd.conf

#cat /etc/idmapd.conf > aux2
#cat aux2 | sed 's/#Domain = local.domain.edu/Domain = cloud.priv/' > /etc/idmapd.conf

echo Domain = cloud.priv >> /etc/idmapd.conf

#15. Se desactiva el demonio del firewall

systemctl stop firewalld 2>> err_ins_cloudstack.txt
f_log systemctl stop firewalld
systemctl disable firewalld 2>> err_ins_cloudstack.txt
f_log systemctl disable firewalld

#16. Se inicializan otros demonios necesarios
systemctl enable rpcbind 2>> err_ins_cloudstack.txt
f_log systemctl enable rpcbind
systemctl enable nfs-server 2>> err_ins_cloudstack.txt
f_log systemctl enable nfs-server
systemctl start rpcbind 2>> err_ins_cloudstack.txt
f_log systemctl start rpcbind
systemctl start nfs-server 2>> err_ins_cloudstack.txt
f_log systemctl start nfs-server

#17. Instalación de wget y obtención del repositorio de mysql

f_instalacion wget
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm 2>> err_ins_cloudstack.txt
f_log wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm 2>> err_ins_cloudstack.txt 
f_log rpm -ivh mysql-community-release-el7-5.noarch.rpm
f_instalacion mysql-server

#18. Modificar el archivo de configuracion de mysql en /etc/my.cnf añadiendo 

echo innodb_rollback_on_timeout=1 >> /etc/my.cnf
echo innodb_lock_wait_timeout=600 >> /etc/my.cnf
echo max_connections=350 >> /etc/my.cnf
echo log-bin=mysql-bin >> /etc/my.cnf
echo binlog-format = 'ROW' >> /etc/my.cnf

#19. Se inicia el demonio de mysql

systemctl enable mysqld 2>> err_ins_cloudstack.txt
f_log systemctl enable mysqld
systemctl restart mysqld 2>> err_ins_cloudstack.txt
f_log systemctl restart mysqld

#Puedes corroborar que se encuentra ejecutandose usando

#systemctl status mysqld

#20. Para instalar el conector de python con mysql usaremos
f_instalacion python3-pip
pip install mysql-connector-python 2>> err_ins_cloudstack.txt
f_log pip install mysql-connector-python

#21. Instalacion de cloudstack con el repositorio agregado en el paso 12

f_instalacion cloudstack-management

#los puertos 8080, 8250, 8443 y 9090 se deben encontrar abiertos y no firewalled por el server management, y no utilizados por algún otro proceso en este host

#23. Se inicializa la base de datos

cloudstack-setup-databases cloud:password@localhost --deploy-as=root 2>> err_ins_cloudstack.txt
f_log cloudstack-setup-databases cloud:password@localhost --deploy-as=root

#24. Se inicializa el gestor del servidor

cloudstack-setup-management 2>> err_ins_cloudstack.txt
f_log cloudstack-setup-management

#25 Se establece una configuración para cloudstack
/usr/share/cloudstack-common/scripts/storage/secondary/cloud--sys-tmplt -m /export/secondary -u http://download.cloudstack.org/systemvm/4.18/systemvmtemplate-4.18.1-kvm.qcow2.bz2 -h kvm -F 2>> err_ins_cloudstack.txt
f_log /usr/share/cloudstack-common/scripts/storage/secondary/cloud--sys-tmplt -m /export/secondary -u http://download.cloudstack.org/systemvm/4.18/systemvmtemplate-4.18.1-kvm.qcow2.bz2 -h kvm -F

#26 Para realizar la virtualización es necesario instalar kvm para ello será necesario

f_instalacion cloudstack-agent

#27. Instalacion de libvirt

f_instalacion libvirt

#28. Configuracion del archivo /etc/libvirt/qemu.conf, se agrega la siguiente linea

echo 'vnc_listen = "0.0.0.0"' >> /etc/libvirt/qemu.conf

#De igual forma se debe tener en el archivo /etc/libvirt/libvirtd.conf la siguiente configuracion

echo listen_tls = 0 >> /etc/libvirt/libvirtd.conf
echo listen_tcp = 1 >> /etc/libvirt/libvirtd.conf
echo 'tcp_port = "16509"' >> /etc/libvirt/libvirtd.conf
echo 'auth_tcp = "none"' >> /etc/libvirt/libvirtd.conf
echo mdns_adv = 0 >> /etc/libvirt/libvirtd.conf

#29. Reiniciamos el demonio correspondiente a libvirtd y verificamos que éste se esté ejecutando
systemctl restart libvirtd 2>> err_ins_cloudstack.txt
f_log systemctl restart libvirtd 
systemctl status libvirtd 2>> err_ins_cloudstack.txt
f_log systemctl status libvirtd

#30. Corroboramos qque kvm se encuentre corriendo con el siguiente comand, debería obtenerse algo como lo de abajo 

lsmod | grep kvm

#kvm_intel              55496  0
#kvm                   337772  1 kvm_intel
#kvm_amd # if you are in AMD cpu

#31. Es necesario que el puerto 8080 se encuentre escuchando para ejecutar correctamente la interfaz de cloudstack en el navegador, para esto hacemos

ss -tlpn | grep 8080


#32. Verificamos que se esté utilizando la versión 11 de java

alternatives --config java
systemctl status cloudstack-management 2>> err_ins_cloudstack.txt
f_log systemctl status cloudstack-management
systemctl status mysqld 2>> err_ins_cloudstack.txt
f_log systemctl status mysqld
systemctl status libvirtd 2>> err_ins_cloudstack.txt
f_log systemctl status libvirtd

#33. Abrimos el navegador y colocamos la direccion

#$MYIPADRESS:8080/client

echo Reinicia el equipo si algo aún no funciona correctamente, al encender verifica los demonios cloudstack-management libvirtd mysqld
