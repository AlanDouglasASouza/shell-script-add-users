#!/bin/bash

#Nome: cadastro.sh
#
#Autor: Alan D. A. Souza
#
#Criado em: 13/08/2022
#
#Descrição: O script recebe um arquivo .txt com nome e cpf separado por virgulase então cadastra o usuário como 'nome.sobrenome' e com a senha sendo o cpf sem pontos ou traços. Ele compara primeiro se esse login de usuário existe, e se existir, ele escreve o usuário já existente em um arquivo nocreate-users setando que esses não foram cadastrados.
#
#IMPORTANTE: SCRIPT TESTADO PARA UBUNTU-SERVER 20.04 E NESCESSÁRIO SER UM USUÁRIO COM PERMISSÃO ROOT.

file="$1"
date=$(date +%H-%M-%S)

function create {
	sudo useradd -m -s /bin/bash "$name.$lastname" -p $(openssl passwd -1 $password);

	echo "Usuário '$name.$lastname' cadastrado com sucesso!"
}

tr -d '.-' < $file > formate-users.txt

while read line; do
	
	name=$(echo "$line" | cut -d' ' -f1);
	lastname=$(echo "$line" | cut -d, -f1 | cut -d' ' -f2);
       	password=$(echo "$line" | cut -d, -f2);	

	if [ "$(cat /etc/passwd| cut -d: -f1| grep -i $name.$lastname| wc -l)" = "1" ]; 
	then
		echo $line >> nocreate-users-$date.txt
		echo "Usuário $name.$lastname já existe. (Não Cadastrado)"
	else		
		create
	fi

done < "./formate-users.txt";

rm formate-users.txt
