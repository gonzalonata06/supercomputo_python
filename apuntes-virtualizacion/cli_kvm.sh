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


primero=$(dialog --menu "Has ingresado al menu de hypervisor de KVM. Selecciona el comando a ejecutar" 40 40 35 listar "Listar las instancias" crear "Crear una instancia" gestionar "Gestionar una instancia" salir "Salir del programa"  2>&1 1>$(tty) )

case $primero in
listar)
	
	listar=$(dialog --menu "Listado de instancias" 40 40 35 todas "Listar todas las intancias" corriendo "Listar instancias en ejecucion" autoinicio "Listar instancias con autoinicio" 2>&1 1>$(tty))
	
	case $listar in 
	todas) 
		virsh list --all  2>&1 | dialog --progressbox 50 40
	;;
	corriendo)
	
		virsh list  2>&1 | dialog --progressbox 50 40
	;;
	autoinicio)
		
		virsh list --autostart  2>&1 | dialog --progressbox 50 40
	;;
	esac
	
;;
crear)
	name=""
	ram=""
	vcpu=""
	disk=""
	cdrom=""
	network=""

	valores=$(dialog --ok-label "Crear" \
	  --backtitle "Linux User Managment" \
	  --title "Nueva instancia" \
	  --form "Crear nueva instancia:" \
					15 90 0 \
	"Nombre de la instancia:" 1 1  "$name" 	1 25 30  0 \
	"RAM (MB):" 2 1  	"$ram"  	2 25 30 0 \
	"VCPU's:"   3 1	"$vcpu"  	3 25 30 0 \
	"Disk route:"  4 1   	"$disk" 	4 25 60 0 \
	"Iso route:"    5 1	"$cdrom" 	5 25 60 0 \
	"Network (bridge:virbr0):"  6 1   	"$network" 	6 25 30 0 \
	2>&1 1>$(tty))
	echo $valores
	sleep 10
	virt-install \
                --name $name \
                --ram $ram \
                --vcpus $vcpu \
                --disk $disk  \
                --graphics vnc,listen=0.0.0.0 --noautoconsole \
                --cdrom $cdrom \
                --network $network 2>&1 | dialog --progressbox 0 0
		
;;
gestionar)
	
	gestionar=$(dialog --menu "Listado de instancias" 40 40 35 todas "Listar todas las intancias" corriendo "Listar instancias en ejecucion" autoinicio "Listar instancias con autoinicio" 2>&1 1>$(tty))
;;
esac


sleep 20
clear


