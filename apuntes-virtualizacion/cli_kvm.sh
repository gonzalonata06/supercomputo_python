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
		virsh list --all  2>&1 | dialog --progressbox "Estado de las instancias" 50 60
		while true;
		do
			sleep 1
			read input
			if [ $input != '\n'  ]
			then
				continue
			else
				break
			fi
		done
	;;
	corriendo)	
		virsh list  2>&1 | dialog --progressbox 50 60
		while true;
                do
                        sleep 1
                        read input
                        if [ $input != '\n'  ]
                        then
                                continue
                        else
                                break
                        fi
                done
	;;
	autoinicio)
		
		virsh list --autostart  2>&1 | dialog --progressbox 50 60
		while true;
                do
                        sleep 1
                        read input
                        if [ $input != '\n'  ]
                        then
                                continue
                        else
                                break
                        fi
                done
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
	  --title "Nueva instancia" \
	  --form "Crear nueva instancia:" \
					15 90 0 \
	"Nombre de la instancia:" 1 1  "$name" 	1 25 30  0 \
	"RAM (MB):" 2 1  	"$ram"  	2 25 30 0 \
	"VCPU's:"   3 1	"$vcpu"  	3 25 30 0 \
	"Disk route:"  4 1   	"$disk" 	4 25 60 0 \
	"Iso route:"    5 1	"$cdrom" 	5 25 60 0 \
        2>&1 1>$(tty))

	#"Network (bridge:virbr0):"  6 1   	"$network" 	6 25 30 0 \
#	2>&1 1>$(tty))        2>&1 1>$(tty))
	if [ $valores != '' ]
	then
		valores_array=($valores)
		echo $valores
		virt-install --name ${valores_array[0]} --ram ${valores_array[1]} --vcpus ${valores_array[2]} --disk ${valores_array[3]} --graphics vnc,listen=0.0.0.0 --noautoconsole --cdrom ${valores_array[4]} 2>&1 | dialog --progressbox 50 90
	
	#--network ${valores[5]}
	
	unset valores_array
        
	while true;
        do
        	sleep 1
                read input
                if [ $input != '\n'  ]
                then
        	        continue
                else
                	break
                fi
        done
	fi
	#2>&1 | dialog --progressbox 0 0
		
;;
gestionar)
	contador=1
	for i in $(virsh list --all | sed '1,2d' | sed 's/-//' | sed 's/\ [0-9]\ //' | tr -s [:space:] | sed 's/apagado//' |  sed 's/ejecutando//' | sed 's/en pausa//')
	do
		arreglo=( ${arreglo[@]} $contador)
		arreglo=( ${arreglo[@]} $i)
		
		#echo ${arreglo[@]}
		#sleep 5

		let contador++
	done
	gestionar=$(dialog --menu "Elija la instancia a gestionar" 40 70 35 ${arreglo[@]} 2>&1 1>$(tty))
	#echo $gestionar
	#echo ${arreglo[$gestionar*2 - 1]}
        #echo ${arreglo[@]}

	#sleep  5
	if [ $gestionar != '' ]
	then
	proceso=$(dialog --menu "Eliga la operación a realizar" 40 70 35 1 Encender 2 Apagar 3 "forzar apagado"  4 "Reiniciar" 5 "Forzar reinicio" 6 Detener 7 Reanudar 8 "Activar autoencendido" 9 "Desactivar autoencendido" '10' Borrar 2>&1 1>$(tty))	
	echo $proceso

	#sleep 5

	case $proceso in
	1)
		#echo ${arreglo[$gestionar + 1]}
		#sleep 5
		virsh start ${arreglo[$gestionar*2 - 1]}
	;;
	2)

		virsh shutdown ${arreglo[$gestionar*2 - 1]}
	;;
	3)
		virsh destroy ${arreglo[$gestionar*2 - 1]}
	;;
	4)
		virsh restart ${arreglo[$gestionar*2 - 1]}
	;;
	5)
		virsh reset ${arreglo[$gestionar*2 - 1]}

	;;

	6)
		virsh suspend ${arreglo[$gestionar*2 - 1]}
	;;
	7)
		virsh resume ${arreglo[$gestionar*2 - 1]}
	;;
	8)
		virsh autostart ${arreglo[$gestionar*2 - 1]}
	;;
	9)
		virsh autostart --disable ${arreglo[$gestionar*2 - 1]}
	;;
	10)
		virsh  virsh destroy ${arreglo[$gestionar*2 - 1]}
                virsh undefine ${arreglo[$gestionar*2 - 1]} --remove-all-storage
	;;
	esac
	#unset arreglo
	#unset gestionar
	#unset proceso
	fi
	unset arreglo
        unset gestionar
        unset proceso

;;
salir)
	clear
	exit 0

;;
esac


clear

done
