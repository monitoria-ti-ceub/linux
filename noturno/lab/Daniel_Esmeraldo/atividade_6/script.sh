#!/bin/bash

mkdir -p /testes && cd /testes

useradd -m -s /bin/bash Usuario1
useradd -m -s /bin/bash Usuario2
useradd -m -s /bin/bash Usuario3

groupadd adm
groupadd dev
groupadd rh

usermod -aG adm Usuario1
usermod -aG dev,rh Usuario2
usermod -aG dev Usuario3

touch arquivo1.txt arquivo2.txt arquivo3.txt arquivo4.txt
chmod 644 arquivo1.txt
chmod 755 arquivo2.txt
chmod 600 arquivo3.txt
chmod 700 arquivo4.txt

su -c "cat arquivo1.txt" Usuario1 >> test_results.txt 2>&1
su -c "cat arquivo2.txt" Usuario1 >> test_results.txt 2>&1
su -c "cat arquivo3.txt" Usuario1 >> test_results.txt 2>&1
su -c "cat arquivo4.txt" Usuario1 >> test_results.txt 2>&1
su -c "echo 'teste' >> arquivo1.txt" Usuario1 >> test_results.txt 2>&1
su -c "echo 'teste' >> arquivo2.txt" Usuario1 >> test_results.txt 2>&1
su -c "echo 'teste' >> arquivo3.txt" Usuario1 >> test_results.txt 2>&1
su -c "echo 'teste' >> arquivo4.txt" Usuario1 >> test_results.txt 2>&1

su -c "cat arquivo1.txt" Usuario2 >> test_results.txt 2>&1
su -c "cat arquivo2.txt" Usuario2 >> test_results.txt 2>&1
su -c "cat arquivo3.txt" Usuario2 >> test_results.txt 2>&1
su -c "cat arquivo4.txt" Usuario2 >> test_results.txt 2>&1
su -c "echo 'teste' >> arquivo1.txt" Usuario2 >> test_results.txt 2>&1
su -c "echo 'teste' >> arquivo2.txt" Usuario2 >> test_results.txt 2>&1
su -c "echo 'teste' >> arquivo3.txt" Usuario2 >> test_results.txt 2>&1
su -c "echo 'teste' >> arquivo4.txt" Usuario2 >> test_results.txt 2>&1

su -c "cat arquivo1.txt" Usuario3 >> test_results.txt 2>&1
su -c "cat arquivo2.txt" Usuario3 >> test_results.txt 2>&1
su -c "cat arquivo3.txt" Usuario3 >> test_results.txt 2>&1
su -c "cat arquivo4.txt" Usuario3 >> test_results.txt 2>&1
su -c "echo 'teste' >> arquivo1.txt" Usuario3 >> test_results.txt 2>&1
su -c "echo 'teste' >> arquivo2.txt" Usuario3 >> test_results.txt 2>&1
su -c "echo 'teste' >> arquivo3.txt" Usuario3 >> test_results.txt 2>&1
su -c "echo 'teste' >> arquivo4.txt" Usuario3 >> test_results.txt 2>&1

cat > permissoes_significado << EOF
Permissões:
	r: O usuário poderá ler o arquivo
	w: O usuário poderá alterar o arquivo
	x: O usuário poderá executar o arquivo
EOF
