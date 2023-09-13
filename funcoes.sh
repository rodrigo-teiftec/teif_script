#Esse arquivo é uma bibliotec de funções que são utilizadas por todos os scritps desse repositorio

#Função para imprimir msg de erros:
#+OK e verde para  sucesso
#+FAIL e vermelho para falha
#+$1 é o codigo de retorno
#+$2 é a msg a ser imprimida
print_msg() {
  [[ $1 -eq 0 ]] && echo -e "$2 \e[32m[OK]\e[0m" || echo -e "$2 \e[31m[FAIL]\e[0m"
}

# Função para criar uma barra de progresso piscante
create_blinking_progress() {
  while true; do
    echo -en "$1.\r"  
    sleep 0.5 
    echo -en "$1..\r"
    sleep 0.5 
    echo -en "$1...\r"
    sleep 0.5 
    echo -en "\e[K"
  done
}

kill $!

