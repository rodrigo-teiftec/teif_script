#!/bin/bash
#Criado by Rodrigo Lira - Teif Tecnologia
#
#Objetivo desse script é automatizar a instalação do rpki
#

#Fazendo o import do arquivo de funções
source ./funcoes.sh

#Declarando as variáveis globais

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
  fn_print_msg 0 "Verificando versão"
else
  fn_print_msg 1 "Verificando versão"
  echo "Cancelando instalação!!!"
  exit
fi

#Instalando os pacotes
msg="Instalando dependências"
fn_create_blinking_progress "$msg" &

apt-get update -y 2>&1 > /dev/null
apt-get install ca-certificates curl gnupg lsb-release -y 2>&1 > /dev/null

cod_retorno="$?"
kill $!

fn_test_cmd "$cod_retorno" "$msg"
fn_print_msg "$cod_retorno" "$msg"
curl -fsSL https://packages.nlnetlabs.nl/aptkey.asc | gpg --dearmor -o /usr/share/keyrings/nlnetlabs-archive-keyring.gpg

fn_test_cmd "$?" "Falha ao baixar a chave gpg"

#Adicionando repositorio krill
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nlnetlabs-archive-keyring.gpg] https://packages.nlnetlabs.nl/linux/debian $(lsb_release -cs) main" > /etc/apt/sources.list.d/nlnetlabs.list

fn_test_cmd "$?" "Falha ao configurar o repositorio krill"

#Instalando o pacote do krill
msg="Instalando o krill"
fn_create_blinking_progress "$msg" &
apt-get update -y 2>&1 > /dev/null
fn_test_cmd $? $msg

apt-get install krill krill-sync krillup krillta -y 2>&1 > /dev/null
fn_test_cmd $? $msg

cp /etc/krill.conf /etc/krill.conf.orig

echo "ip = \"0.0.0.0\"" >> /etc/krill.conf

systemctl enable krill 2>&-
systemctl start krill 2>&-

kill $!
fn_print_msg "$cod_retorno" "$msg"

#Buscando a chave de acesso ao painel web
token=$(grep "token =" /etc/krill.conf | cut -d'"' -s -f 2)

ip=$(grep address /etc/network/interfaces | cut -d" " -f 2)
echo "Acesse o krill através do navegador: https://${ip%/*}:3000"
echo "Utilize a senha: $token"



