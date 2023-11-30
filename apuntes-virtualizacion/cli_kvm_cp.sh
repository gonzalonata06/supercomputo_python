#!/bin/bash
clear

for arg in "$*" #en todos los argumentos que han entrado
do
    if [ "$arg" == "--help" ] || [ "$arg" == "-h" ]
    then
        echo "Uso: sudo ./cli_kvm.sh"
        exit 0
    fi
done



echo "Has ingresado al menu de hypervisor de KVM. Selecciona el comando a ejecutar"
echo -ne "\e[1;33m list \e[0m" 
echo " Listar las instancias que se encuentran corriendo"
echo -ne "\e[1;33m list --all\e[0m "
echo "\t Listar todas las instancias creadas"
echo -ne "\e[1;33m list --autostart\e[0m "
echo "Listar todas las instancias con autoinicio"
echo -ne "\e[1;33m shutdown/reboot/start \"nombre de la instancia\"\e[0m "
echo "Para apagar, reiniciar o iniciar dicha instancia"
echo -n "Para crear una instancia usa la siguiente sintaxis "
echo -e "\e[1;33m sólo inserta la información que está después del signo =\e[0m "
echo -ne"\e[1;33m create\e[0m" 
echo "--name=centos7 --ram=1024 --vcpus=2  --os-variant=rhel7 --disk path=/var/lib/libvirt/images/centos7.qcow2,bus=virtio,size=10 --graphics=none --location=$HOME/iso/CentOS-7-x86_64-Everything-1611.iso --network=bridge:virbr0 --console=pty,target_type=serial -x 'console=ttyS0,115200n8 serial'"
echo -en "\e[1;33m exit\e[0m"
echo " salir del menu"

while [ 1 ] 
do
	read -p "Ingresa tu instruccion:   " v1 v2 v3 v4 v5 v6 v7 v8 v9
	
	if [ $v1 == exit ] 
	then
		exit
	fi


	if [ $v1 == create ]
	then
		virt-install \
		--name $v2 \
		--ram $v3 \
		--vcpus $v4 \
		--os-variant=$v5 \
		--disk $v6  \
		--graphics $v7 \
		--cdrom $v8 \
		--network $v9 
	        #--console "pty,target_type=serial -x 'console=ttyS0,115200n8 serial'"

	else

				
			case $v1 in  
			list)
				case $v2 in
				--all)
					virsh list --all
				;;
				--autostart)
					virsh list --autostart
				;;
				"")
					virsh list
				;;
				esac
			;;
			shutdown)
				virsh shutdown $v2
			;;
			restart)
				virsh restart $v2
			;;
			start)
				virsh start $v2
			;;
			remove)
				virsh destroy $v2
				virsh undefine $v2 --remove-all-storage
			;;
			esac

	fi
done
