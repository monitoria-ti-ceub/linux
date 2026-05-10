#!/bin/bash

USUARIO=${USER:-$(whoami)}

adicionar_arquivo() {
	read -p "Informe o nome do arquivo a adicionar: " nome_arquivo

        if [ -e "$nome_arquivo" ]; then
		echo "Há um arquivo/diretório já existente com o mesmo nome."
        else
                touch "$nome_arquivo"
                echo "Arquivo $nome_arquivo criado com êxito."
                echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO criou arquivo $nome_arquivo" >> log.txt
        fi
}

buscar_arquivo() {
        read -p "Informe o nome do arquivo a buscar: " nome_arquivo
        resultado=$(find . -type f -name "$nome_arquivo" 2>/dev/null)

        if [ -n "$resultado" ]; then
                echo "$resultado"
	else
		echo "Arquivo não encontrado."
        fi

        echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO procurou por arquivo $nome_arquivo" >> log.txt
}

deletar_arquivo() {
	read -p "Informe o nome do arquivo a deletar: " nome_arquivo
	if [ -f "$nome_arquivo" ]; then
		read -p "Você realmente deseja deletar o arquivo $nome_arquivo? (s/n): " confirm
		if [ "$confirm" == "s" ]; then
			rm "$nome_arquivo"
                        echo "Arquivo $nome_arquivo deletado."
                        echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO removeu o arquivo $nome_arquivo" >> log.txt
		fi
        else
		 echo "Arquivo não encontrado."
	fi
}

visualizar_head() {
	local nome_arquivo="$1"
	read -p "Informe quantas linhas deseja visualizar [padrão 10]: " linhas
	linhas=${linhas:-10}
	head -n "$linhas" "$nome_arquivo"
}

visualizar_tail() {
	local nome_arquivo="$1"
	read -p "Informe quantas linhas deseja visualizar [padrão 10]: " linhas
	linhas=${linhas:-10}
	tail -n "$linhas" "$nome_arquivo"
}

visualizar_grep() {
	local nome_arquivo="$1"
	read -p "Informe a palavra ou padrão a buscar: " padrao
	if [ -z "$padrao" ]; then
		echo "Padrão não encontrado"
		return 1
	fi
	grep -i -n --color=always "$padrao" "$nome_arquivo"
}

visualizar_conteudo() {
	read -p "Informe o nome do arquivo: " nome_arquivo
	if [ ! -f "$nome_arquivo" ]; then
		echo "Arquivo não encontrado"
		return 1
	fi

	while true; do
		clear
		PS3="Escolha uma opção: "
		select opcao in "Visualizar todo o conteúdo" "Visualizar as N primeiras linhas" "Visualizar as N últimas linhas" "Buscar por uma palavra" "Voltar"; do
			case $opcao in
				"Visualizar todo o conteúdo")
					clear
					cat "$nome_arquivo"
					echo ""
					read -p "Pressione ENTER para continuar..."
					;;
				"Visualizar as N primeiras linhas")
					clear
					visualizar_head "$nome_arquivo"
					echo ""
					read -p "Pressione ENTER para continuar..."
					;;
				"Visualizar as N últimas linhas")
					clear
					visualizar_tail "$nome_arquivo"
					echo ""
					read -p "Pressione ENTER para continuar..."
					;;
				"Buscar por uma palavra")
					clear
					visualizar_grep "$nome_arquivo"
					echo ""
					read -p "Pressione ENTER para continuar..."
					;;
				"Voltar")
					return 0
					;;
				*)
					echo "Opção inválida."
					echo ""
					read -p "Pressione ENTER para continuar..."
					;;
			esac

			break
		done
	done
}

adicionar_diretorio() {
	read -p "Informe o nome do diretorio a adicionar: " nome_diretorio

        if [ -e "$nome_diretorio" ]; then
		echo "Há um arquivo/diretório já existente com o mesmo nome."
        else
                mkdir "$nome_diretorio"
                echo "$nome_diretorio criado com êxito."
                echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO criou diretório $nome_diretorio" >> log.txt
        fi
}

buscar_diretorio() {
        read -p "Informe o nome do diretório a buscar: " nome_diretorio
        resultado=$(find . -type d -name "$nome_diretorio" 2>/dev/null)

        if [ -n "$resultado" ]; then
                echo "$resultado"
	else
		echo "Diretório não encontrado."
        fi

        echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO procurou por diretório $nome_diretorio" >> log.txt
}

deletar_diretorio() {
	read -p "Informe o nome do diretório a deletar: " nome_diretorio
	if [ -d "$nome_diretorio" ]; then
		echo "ATENÇÃO! TODOS OS ARQUIVOS DENTRO DE $nome_diretorio SERÃO DELETADOS"
		read -p "Você realmente deseja deletar o diretório $nome_diretorio? (s/n): " confirm
		if [ "$confirm" == "s" ]; then
			rm -r "$nome_diretorio"
                        echo "Diretório $nome_diretorio deletado."
                        echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO removeu o diretório $nome_diretorio" >> log.txt
		fi
        else
		 echo "Diretório não encontrado."
	fi
}

listar() {
	ls -la
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO listou os arquivos/diretórios" >> log.txt
}

gerenciar_permissoes() {
	read -p "Informe o nome do arquivo/diretório a gerenciar permissão: " nome
        read -p "Informe as permissões que o arquivo/diretório terá (Ex: 755): " permissoes
	if [ -e "$nome" ]; then
		if [[ "$permissoes" =~ ^[0-7]{3,4}$ ]]; then
			chmod "$permissoes" "$nome"
                        echo "Permissão alterada com êxito."
                        echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO alterou a permissão do arquivo/diretório $nome para $permissoes" >> log.txt
                else
                        echo "Formato inválido. Use 755, 644, etc."
                fi
	else
		echo "Arquivo/diretório não encontrado."
        fi
}

gerenciar_proprietarios() {
	read -p "Informe o nome do arquivo/diretório: " nome
	read -p "Informe o novo proprietário (usuário): " dono
	read -p "Informe o novo grupo (opcional, Enter para pular): " grupo

	if ! id "$dono" &>/dev/null; then
		echo "Usuário $dono não existe!"
		return 1
	fi

	if [ -n "$grupo" ] && ! getent group "$grupo" &>/dev/null; then
		echo "Grupo $grupo não existe!"
		return 1
	fi 

	if [ -e "$nome" ]; then
		if [ -n "$grupo" ]; then
			chown "$dono:$grupo" "$nome"
			echo "Proprietário alterado para $dono:$grupo"
			echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO alterou proprietário do arquivo/diretório $nome para $dono:$grupo" >> log.txt
		else
			chown "$dono" "$nome"
			echo "Proprietário alterado para $dono"
			echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO alterou proprietário do arquivo/diretório $nome para $dono" >> log.txt
		fi
	else
		echo "Arquivo/diretório não encontrado."
	fi
}

gerar_relatorio() {
	echo "================================RELATÓRIO================================"
	echo "Quantidade de arquivos: $(ls -l | grep "^-" | wc -l)"
	echo "Quantidade de diretórios: $(ls -l | grep "^d" | wc -l)"
	echo "Espaço total usado: $(du -sh . 2>/dev/null | cut -f1)"
	echo ""
	echo "=== PERMISSÕES DOS ARQUIVOS ==="
	ls -la
	echo ""
    	echo "=== LOG DE OPERAÇÕES ==="
    	if [ -f "log.txt" ]; then
        	cat log.txt
    	else
        	echo "Nenhum log encontrado ainda."
    	fi
}

copiar_item() {
	read -p "Informe item de origem a copiar: " item_origem
	read -p "Informe o  destino: " destino
	if [ -e "$item_origem" ]; then
		if [ -f "$item_origem" ]; then
			cp -i "$item_origem" "$destino"
		elif [ -d "$item_origem" ]; then
			cp -r -i "$item_origem" "$destino"
		else
			echo "Tipo de arquivo não suportado para cópia (ex: link, dispositivo)."
			return 1
		fi
		if [ $? -eq 0 ]; then
			echo "Cópia concluída com êxito."
			echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO copiou o item $item_origem para o destino $destino" >> log.txt
		else
			echo "Cópia fracassada."
		fi
	else
		echo "Origem não encontrada."
	fi
}

mover_renomear_item() {
	read -p "Informe o item de origem a mover/renomear: " item_origem
	read -p "Informe o caminho [mover] ou nome [renomear]: " caminho_nome
	if [ -e "$item_origem" ]; then
		mv -i "$item_origem" "$caminho_nome"
		if [ $? -eq 0 ]; then
			echo "Processo concluído com êxito."
			echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO moveu/renomeou  o item $item_origem para $caminho_nome" >> log.txt
		else
			echo "Processo fracassado."
		fi
	else
		echo "Origem não encontrada."
	fi
}

compactar() {
	read -p "Informe o nome do arquivo/diretorio a compactar: " origem
	if [ ! -e "$origem" ]; then
		echo "Arquivo/diretório não encontrado."
		return 1
	fi
	read -p "Informe o nome do arquivo compactado (sem extensão): " saida
	tar -czf "$saida.tar.gz" "$origem"
	if [ $? -eq 0 ]; then
		echo "Arquivo/diretório $origem compactado com êxito."
		echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO compactou o arquivo/diretório $origem" >> log.txt
	else
		echo "Falha ao compactar arquivo/diretório $origem."
	fi
}

descompactar() {
	read -p "Informe o nome do arquivo .tar.gz: " arquivo
	if [ ! -e "$arquivo.tar.gz" ]; then
		echo "Arquivo $arquivo não encontrado."
		return 1
	fi

	if [[ ! "$arquivo" =~ \.tar\.gz$ ]] && [[ ! "$arquivo" =~ \.tgz$ ]]; then
        echo "O arquivo não parece ser um .tar.gz ou .tgz. Verifique a extensão."
        return 1
    	fi

	read -p "Informe o diretório de destino (Enter para atual): " destino
	if [ -z "$destino" ]; then
		tar -xzf "$arquivo"
	else
		mkdir -p "$destino"
		tar -xzf "$arquivo" -C "$destino"
	fi
	if [ $? -eq 0 ]; then
		echo "Descompactado com êxito."
		echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO descompactou o arquivo $arquivo" >> log.txt
	else
		echo "Falha ao descompactar o arquivo $arquivo."
	fi
}

navegar() {
	read -p "Informe o caminho do diretório a navegar: " caminho
	if [ -d "$caminho" ]; then
		cd "$caminho"
		echo "Agora você está em: $(pwd)"
		echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO navegou para $caminho" >> log.txt
	else
		echo "Diretório não encontrado."
	fi
}

backup() {
	read -p "Informe o arquivo/diretório a fazer backup: " origem
	if [ ! -e "$origem" ]; then
		echo "Arquivo/diretório não encontrado."
		return 1
	fi
	mkdir -p backup
	data=$(date '+%Y%m%d_%H%M%S')
	nome_base=$(basename "$origem")
	destino="backup/${nome_base}_${data}"
	if [ -f "$origem" ]; then
		cp "$origem" "$destino"
	elif [ -d "$origem" ]; then
		cp -r "$origem" "$destino"
	fi
	if [ $? -eq 0 ]; then
		echo "Backup concluído com êxito."
		echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO fez o backup do arquivo/diretório $origem" >> log.txt
	else
		echo "Backup fracassado."
	fi
}

ajuda() {
	cat << 'EOF'
================================ AJUDA ================================
GERENCIADOR DE ARQUIVOS - Versão 1.0

FUNCIONALIDADES:

- Arquivo: Adicionar, Buscar, Visualizar conteúdo, Deletar
- Diretório: Adicionar, Buscar, Deletar
- Copiar item (arquivos/diretórios)
- Mover/Renomear item
- Listar conteúdo do diretório atual
- Gerenciar permissões (chmod) - use códigos como 755, 644
- Gerenciar proprietários (chown) - usuário e opcional grupo
- Gerar relatório (estatísticas + log)
- Compactar/Descompactar (.tar.gz)
- Navegar (mudar de diretório)
- Backup (cria cópia com timestamp)
- Ajuda (esta tela)

COMO USAR:
- Navegue pelo menu usando números.
- Opção "Voltar" retorna ao menu anterior.
- Todas as ações são registradas em log.txt.
EOF
	echo ""
	read -p "Pressione ENTER para continuar..."
}

sair() {
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO ---------------Usuário encerrou o programa---------------" >> log.txt
        exit 0
}

echo "$(date '+%Y-%m-%d %H:%M:%S') - $USUARIO ---------------Usuário iniciou o programa---------------" >> log.txt

while true; do
	clear
	echo "----------------------GERENCIADOR DE ARQUIVOS----------------------"
	PS3="Escolha uma opção: "
	select opcao in "Arquivo" "Diretório" "Copiar item" "Mover/renomear item" "Listar" "Gerenciar permissões" "Gerenciar proprietários" "Compactar" "Descompactar" "Navegar" "Backup" "Gerar relatório" "Ajuda" "Sair"; do
		case $opcao in
			"Arquivo")
				clear
				PS3="Escolha uma opção: "
				select opcao in "Adicionar arquivo" "Buscar arquivo" "Visualizar conteúdo" "Deletar arquivo" "Voltar"; do
			        	case $opcao in
			                	"Adicionar arquivo")
							clear
							adicionar_arquivo
							echo ""
							read -p "Pressione ENTER para continuar..."
			                        	;;
			                	"Buscar arquivo")
							clear
							buscar_arquivo
							echo ""
							read -p "Pressione ENTER para continuar..."
			                        	;;
						"Visualizar conteúdo")
							clear
							visualizar_conteudo
							;;
			                	"Deletar arquivo")
							clear
							deletar_arquivo
							echo ""
							read -p "Pressione ENTER para continuar..."
			                        	;;
						"Voltar")
							break
							;;
			        	esac

					break
				done
				;;
			"Diretório")
				clear
				PS3="Escolha uma opção: "
				select opcao in "Adicionar diretório" "Buscar diretório" "Deletar diretório" "Voltar"; do
			        	case $opcao in
			                	"Adicionar diretório")
							clear
							adicionar_diretorio
							echo ""
							read -p "Pressione ENTER para continuar..."
			                        	;;
			                	"Buscar diretório")
							clear
							buscar_diretorio
							echo ""
							read -p "Pressione ENTER para continuar..."
			                        	;;
			                	"Deletar diretório")
							clear
							deletar_diretorio
							echo ""
							read -p "Pressione ENTER para continuar..."
			                        	;;
						"Voltar")
							break
							;;
			        	esac

					break
				done
				;;
			"Copiar item")
				clear
				copiar_item
				echo ""
				read -p "Pressione ENTER para continuar..."
				;;
			"Mover/renomear item")
				clear
				mover_renomear_item
				echo ""
				read -p "Pressione ENTER para continuar..."
				;;
			"Listar")
				clear
				listar
				echo ""
				read -p "Pressione ENTER para continuar..."
				;;
			"Gerenciar permissões")
				clear
				gerenciar_permissoes
				echo ""
				read -p "Pressione ENTER para continuar..."
				;;
			"Gerenciar proprietários")
				clear
				gerenciar_proprietarios
				echo ""
				read -p "Pressione ENTER para continuar..."
				;;
			"Compactar")
				clear
				compactar
				echo ""
				read -p "Pressione ENTER para continuar..."
				;;
			"Descompactar")
				clear
				descompactar
				echo ""
				read -p "Pressione ENTER para continuar..."
				;;
			"Navegar")
				clear
				navegar
				echo ""
				read -p "Pressione ENTER para continuar..."
				;;
			"Backup")
				clear
				backup
				echo ""
				read -p "Pressione ENTER para continuar..."
				;;
			"Gerar relatório")
				clear
				gerar_relatorio
				echo ""
				read -p "Pressione ENTER para continuar..."
				;;
			"Ajuda")
				clear
				ajuda
				;;
			"Sair")
				sair
				;;
			*)
				echo "Opção inválida."
				echo ""
				read -p "Pressione ENTER para continuar..."
				;;
		esac

		break
	done
done
