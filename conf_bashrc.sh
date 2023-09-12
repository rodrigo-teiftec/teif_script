#!/bin/bash
#Criado by Rodrigo Lira - Teif Tecnologia
#
#Objetivo desse script é automatizar a personalização do bash no padrão da Teif
#

echo "Verificando usuário root..."
if [ $(id -u) -gt 0 ]
then
  echo "Usuário não é root"
  echo "Utilize o comando 'su -' para virar root"
  exit 1
fi

echo "Verificando dependências ..."
if [[ ! $(dpkg -s git 2> /dev/null) ]]
then
  [[ $(apt-get install git -y) > /dev/null ]] || echo "Falha ao instalar o git" 
fi

#Entrando no diretorio /tmp
cd /tmp

#Baixando repositorio
git clone https://github.com/rodrigo-teiftec/teif_script.git

cd teif_script


#Substituindo o .bashrc de todos os usuarios
echo "Alterando bashrc ..."
cp file_bashrc /home/*/.bashrc
cp file_bashrc /root/.bashrc

#Configurando o hostname da maquina
read -p "Digite o nome da máquina: " hostname_vm
read -p "Digite o dominio do provedor": dominio

hostnamectl set-hostname $hostname_vm.$dominio

echo "Ajuste finalizado. Deslogue e logue novamente no terminal"


