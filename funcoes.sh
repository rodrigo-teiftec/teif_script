#Esse arquivo é uma bibliotec de funções que são utilizadas por todos os scritps desse repositorio

#Função para imprimir msg de erros:
#+Ela tera um buffer de impressao de 30 caracteres
#+Como todas as msg tem menos que isso, ela ira completar com .
#+${2#} é uma expansão de parametro que pega o tamanho da msg ($2)
#+OK e verde para  sucesso
#+FAIL e vermelho para falha
#+$1 é o codigo de retorno
#+$2 é a msg a ser imprimidao
fn_print_msg() {
 if [ $1 -eq 0 ]
  then
    printf "%s%s" "$2" $(printf '.%.0s' $(seq 1 $((30 - ${#2}))))
    echo -e "\e[32m[OK]\e[0m"
  else
    printf "%s%s" "$2" $(printf '.%.0s' $(seq 1 $((30 - ${#2}))))
    echo -e "\e[31m[FAIL]\e[0m"
  fi
}

# Função para criar uma barra de progresso piscante
fn_create_blinking_progress() {
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

#Função para validar a saída dos comandos
fn_test_cmd() {
  [[ $1 -eq 0 ]] || (fn_print_msg "$1" "$2" && exit)
}

