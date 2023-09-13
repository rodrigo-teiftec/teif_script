#!/bin/bash
#Criado by Rodrigo Lira - Teif Tecnologia
#
#Objetivo desse script é automatizar a instalação do rpki
#

source ./funcoes.sh

#Verificando se o usuário logado é root
if [ $(id -u) -gt 0 ]
then
  echo "Usuário não é root"
  echo "Utilize o comando 'su -' para virar root"
  exit 1
fi

#Vericando versão do Debian
#+esse script é compatível apenas com a versão 11 até o momento.
if [ $(grep CODENAME /etc/os-release | cut -d"=" -f2) == "bullseye" ]
then
  fn_print_msg 0 "Verificando versão ..."
else
  fn_print_msg 1 "Verificando versão ..."
  echo "Cancelando instalação!!!"
  exit
fi

#Instalando os pacotes
msg="Instalando dependências"
fn_create_blinking_progress "$msg"

apt-get update -qq 2>&-
apt-get install wget gnupg2 apt-transport-https net-tools -qq 2>&-

cod_retorno="$?"
kill $!

fn_test_cmd $cod_retorno $msg

#Adicionando repositorio krill
echo 'deb [arch=amd64] https://packages.nlnetlabs.nl/linux/debian/ bullseye main' >  /etc/apt/sources.list.d/nlnetlabs.list
fn_test_cmd $? $msg

wget -qO- https://packages.nlnetlabs.nl/aptkey.asc | apt-key add -
fn_test_cmd $? $msg

#Instalando o pacote do krill
apt-get update -qq 2>&-
fn_test_cmd $? $msg

apt install krill krill-sync krillup krillta

cp /etc/krill.conf /etc/krill.conf.orig

echo "ip = \"0.0.0.0\"" >> /etc/krill.conf

systemctl enable krill
systemctl start krill 

#Buscando a chave de acesso ao painel web
token=$(grep "token =" /etc/krill.conf | cut -d'"' -s -f 2)

ip=$(grep address /etc/network/interfaces | cut -d" " -f 2)
echo "Acesse o krill através do navegador: https://${ip%/*}:3000"
echo "Utilize a senha: $token"



