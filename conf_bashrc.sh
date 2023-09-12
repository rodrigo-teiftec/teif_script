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
fi

echo "Alterando bashrc ..."
cat <<FIM > /root/.bashrc
# *********************************************
# * ~/.bashrc Personalizado Teiftec             *
# *                                             *
# *                                             *
# *                                             *
# *                                             *
# *********************************************

# Configurações Gerais

# Se não estiver rodando interativamente, não fazer nada
[ -z "$PS1" ] && return

# Não armazenar as linhas duplicadas ou linhas que começam com espaço no historico
HISTCONTROL=ignoreboth

# Adicionar ao Historico e não substitui-lo
shopt -s histappend

# Definições do comprimento e tamnho do historico.
HISTSIZE=10000
HISTFILESIZE=4000

#Capturando o hostname
EMP=`cut -d"." -f2 /etc/hostname`

# Definindo as cores
NONE="\[\033[0m\]" # Eliminar as Cores

## Cores de Fonte
K="\[\033[0;30m\]" # Black (Preto)
R="\[\033[0;31m\]" # Red (Vermelho)
G="\[\033[0;32m\]" # Green (Verde)
Y="\[\033[0;33m\]" # Yellow (Amarelo)
B="\[\033[0;34m\]" # Blue (Azul)
M="\[\033[0;35m\]" # Magenta (Vermelho Claro)
C="\[\033[0;36m\]" # Cyan (Ciano - Azul Claro)
W="\[\033[0;37m\]" # White (Branco)

## Efeito Negrito (bold) e cores
BK="\[\033[1;30m\]" # Bold+Black (Negrito+Preto)
BR="\[\033[1;31m\]" # Bold+Red (Negrito+Vermelho)
BG="\[\033[1;32m\]" # Bold+Green (Negrito+Verde)
BY="\[\033[1;33m\]" # Bold+Yellow (Negrito+Amarelo)
BB="\[\033[1;34m\]" # Bold+Blue (Negrito+Azul)
BM="\[\033[1;35m\]" # Bold+Magenta (Negrito+Vermelho Claro)
BC="\[\033[1;36m\]" # Bold+Cyan (Negrito+Ciano - Azul Claro)
BW="\[\033[1;37m\]" # Bold+White (Negrito+Branco)

## Cores de fundo (backgroud)
BGK="\[\033[40m\]" # Black (Preto)
BGR="\[\033[41m\]" # Red (Vermelho)
BGG="\[\033[42m\]" # Green (Verde)
BGY="\[\033[43m\]" # Yellow (Amarelo)
BGB="\[\033[44m\]" # Blue (Azul)
BGM="\[\033[45m\]" # Magenta (Vermelho Claro)
BGC="\[\033[46m\]" # Cyan (Ciano - Azul Claro)
BGW="\[\033[47m\]" # White (Branco)

# Configurações referentes ao usuário

if [ -f /etc/bash_completion ]; then
. /etc/bash_completion
fi

complete -cf man
complete -cf sudo

## Verifica se é usuário root (UUID=0) ou usuário comum
if [ $UID -eq "0" ]; then

## Cores e efeitos do Usuario root

PS1="$G┌─[$BR\u$G]$BY@$G[$EMP-$BW${HOSTNAME%%.*}$G]$B:\w\n$G└─>$BG${BGB}TEIFTEC$BGK$BR \\$ $NONE"

else

## Cores e efeitos do usuário comum

 PS1="$BR┌─[$BG\u$BR]$BY@$BR[$EMP-$BW${HOSTNAME%%.*}$BR]$B:\w\n$BR└─>$BG${BGB}TEIFTEC$BGK$BR$BG \\$ $NONE"

fi # Fim da condição if

## Exemplos de PS1

# PS1="\e[01;31m┌─[\e[01;35m\u\e[01;31m]──[\e[00;37m${HOSTNAME%%.*}\e[01;32m]:\w$\e[01;31m\n\e[01;31m└──\e[01;36m>>\e[00m"

# PS1='\[\e[m\n\e[1;30m\][$$:$PPID \j:\!\[\e[1;30m\]]\[\e[0;36m\] \T \d \[\e[1;30m\][\[\e[1;34m\]\u@\H\[\e[1;30m\]:\[\e[0;37m\]${SSH_TTY} \[\e[0;32m\]+${SHLVL}\[\e[1;30m\]] \[\e[1;37m\]\w\[\e[0;37m\] \n($SHLVL:\!)\$ '}

# PS1="\e[01;31m┌─[\e[01;35m\u\e[01;31m]──[\e[00;37m${HOSTNAME%%.*}\e[01;32m]:\w$\e[01;31m\n\e[01;31m└──\e[01;36m>>\e[00m"

# PS1="┌─[\[\e[34m\]\h\[\e[0m\]][\[\e[32m\]\w\[\e[0m\]]\n└─╼ "

# PS1='[\u@\h \W]\$ '


## Habilitando suporte a cores para o ls e outros aliases
## Vê se o arquivo existe
if [ -x /usr/bin/dircolors ]
then
test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

## Aliases (apelidos) para comandos
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
fi # Fim do if do dircolor

FIM

#Copiando o .bashrc para a pasta home de todos os usuários
cp /root/.bashrc /home/*/

#Configurando o hostname da maquina
read -p "Digite o nome da máquina: " hostname_vm
read -p "Digite o dominio do provedor": dominio

hostnamectl set-hostname $hostname_vm.$dominio

echo "Ajuste finalizado. Deslogue e logue novamente no terminal"


