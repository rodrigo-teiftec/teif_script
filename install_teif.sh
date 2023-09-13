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
fn_create_blinking_progress "$msg" &

apt-get update 2>&1 > /dev/null
apt-get install ca-certificates curl gnupg lsb-release

cod_retorno="$?"
kill $!

fn_test_cmd $cod_retorno $msg

curl -fsSL https://packages.nlnetlabs.nl/aptkey.asc | gpg --dearmor -o /usr/share/keyrings/nlnetlabs-archive-keyring.gpg
fn_test_cmd $? $msg

#Adicionando repositorio krill
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nlnetlabs-archive-keyring.gpg] https://packages.nlnetlabs.nl/linux/debian $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/nlnetlabs.list > /dev/null
fn_test_cmd $? $msg

#echo 'deb [arch=amd64] https://packages.nlnetlabs.nl/linux/debian/ bullseye main' >  /etc/apt/sources.list.d/nlnetlabs.list


#wget -qO- https://packages.nlnetlabs.nl/aptkey.asc | apt-key add -

#Instalando o pacote do krill
apt-get update 2>&1 > /dev/null
fn_test_cmd $? $msg

echo "Passou"
exit
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



