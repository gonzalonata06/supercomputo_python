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

while [ 1 ]
do

primero=$(dialog --menu "Has ingresado al menu de hypervisor de KVM. Selecciona el comando a ejecutar" 40 40 35 listar "Listar las instancias" crear "Crear una instancia" gestionar "Gestionar una instancia" salir "Salir del programa"  2>&1 1>$(tty) )

case $primero in
listar)
	
	listar=$(dialog --menu "Listado de instancias" 40 40 35 todas "Listar todas las intancias" corriendo "Listar instancias en ejecucion" autoinicio "Listar instancias con autoinicio" 2>&1 1>$(tty))
	
	case $listar in 
	todas) 
		virsh list --all  2>&1 | dialog --progressbox 50 60		
		sleep 8

	;;
	corriendo)
	
		virsh list  2>&1 | dialog --progressbox 50 60
		sleep 8
	;;
	autoinicio)
		
		virsh list --autostart  2>&1 | dialog --progressbox 50 60
		seep 8
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
	contador=1
	for i in $(sudo virsh list --all | sed '1,2d' | tr -s " " ":")
	do
		arreglo=( $i ${arreglo[@]})
		arreglo=( $contador ${arreglo[@]})
		let contador++
	done
	#gestionar=$(dialog --menu "Elija la instancia a gestionar" 0 0 0 todas "Listar todas las intancias" corriendo "Listar instancias en ejecucion" autoinicio "Listar instancias con autoinicio" 2>&1 1>$(tty))
	gestionar=$(dialog --menu "Elija la instancia a gestionar" 40 40 35 ${arreglo[@]} 2>&1 1>$(tty))
	proceso=$(dialog --menu "Eliga la operación a realizar" 40 40 35 1 Encender 2 Apagar 3 Reiniciar 4 Detener 5 Reanudar 6 Activar autoencendido 7 Desactivar autoencendido 8 Borrar 2>&1 1>$(tty))	

	case $proceso in
	1)
		virsh start ${arreglo[$gestionar + 1]}
	;;
	2)

		virsh shutdown ${arreglo[$gestionar + 1]}
	;;
	3)
		virsh restart ${arreglo[$gestionar + 1]}
	;;
	4)
		virsh suspend ${arreglo[$gestionar + 1]}
	;;
	5)
		virsh resume ${arreglo[$gestionar + 1]}
	;;
	6)
		virsh autostart ${arreglo[$gestionar + 1]}
	;;
	7)
		virsh autostart --disable ${arreglo[$gestionar + 1]}
	;;
	8)
		virsh  virsh destroy ${arreglo[$gestionar + 1]}
                virsh undefine ${arreglo[$gestionar + 1]} --remove-all-storage
	;;
	esac
	

;;
salir)
	clear
	exit 0
esac


clear

done
