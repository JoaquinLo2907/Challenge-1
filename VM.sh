if [ "$#" -ne 6 ]; then
    echo "Estas son las configuraciones: $0 <nomVm> <tipoSO> <numcpu> <gbmemoria> <mbVram> <discogb>"
    exit 1
fi

nomVm="$1"
tipoSO="$2"
numcpu="$3"
gbmemoria="$4"
mbVram="$5"
discogb="$6"

# Esta linea creara la VM
VboxManage createvm --name "$nomVm" --ostype "$tipoSO" --register 
# Esta linea asignara los cpu
VboxManage modifyvm "$nomVm" --cpus "$numcpu"
# Esta linea asigna la ram y vram
VboxManage modifyvm "$nomVm" --memory "$gbmemoria" --vram "$mbVram"
# Esta linea creara el disco duro
VboxManage createhd --filename "$nomVm.vdi" --size "$discogb"
# Esta linea creara el cotrolador SATA
VBoxManage storagectl "$nomVm" --name "SATA Controller" --add sata --controller IntelAHCI
# Esta linea asocia el disco duro virtual al SATA
VBoxManage storageattach "$nomVm" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$nomVm.vdi"
# Esta linea crea IDE
VBoxManage storagectl "$nomVm" --name "IDE Controller" --add ide

echo "Este es el resumen de tu configuración:"
echo "Nombre de la VM: $nomVm"
echo "Tipo de sistema operativo: $tipoSO"
echo "Número de CPUs: $numcpu"
echo "Memoria RAM: $gbmemoria GB"
echo "VRAM: $mbVram MB"
echo "Tamaño del disco duro virtual: $discogb GB"

exit 0

