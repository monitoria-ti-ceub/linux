sudo useradd -m -s /bin/bash sally
sudo useradd -m -s /bin/bash TowMater
sudo useradd -m -s /bin/bash Doc

sudo groupadd best_friend
sudo groupadd girlfriend
sudo groupadd mentor

sudo usermod -aG best_friend TowMater
sudo usermod -aG girlfriend TowMater
sudo usermod -aG girlfriend sally
sudo usermod -aG mentor Doc

sudo mkdir -p /var/testes_permissoes
cd /var/testes_permissoes

touch gas644.txt
touch lifeIsAHighway755.txt
touch sallyMakesMcQueenDirtyClip600.txt
echo "I ruined your childhood
https://www.youtube.com/watch?v=8ZRPiKFtCoA" > sallyMakesMcQueenDirtyClip600.txt
touch materIsBased700.txt

sudo chown root:girlfriend /var/testes_permissoes/*
sudo chmod 644 /var/testes_permissoes/gas644.txt
sudo chmod 755 /var/testes_permissoes/lifeIsAHighway755.txt
sudo chmod 600 /var/testes_permissoes/sallyMakesMcQueenDirtyClip600.txt
sudo chmod 700 /var/testes_permissoes/materIsBased700.txt

ls -l /var/testes_permissoes/

cat /var/testes_permissoes/gas644.txt
su - sally -c "cat /var/testes_permissoes/gas644.txt"
su - Doc -c "cat /var/testes_permissoes/gas644.txt"
su - TowMater -c "cat /var/testes_permissoes/gas644.txt"
su - TowMater -c "echo "Lightning McQueen : I’m serious! He’s won three Piston Cups!
Mater : [spits out fuel]  He did WHAT in his cup?" >> /var/testes_permissoes/gas644.txt" 

su - sally -c  cat "/var/testes_permissoes/sallyMakesMcQueenDirtyClip600.txt"
su - Doc -c  cat "/var/testes_permissoes/sallyMakesMcQueenDirtyClip600.txt"
su - TowMater -c  cat "/var/testes_permissoes/sallyMakesMcQueenDirtyClip600.txt"
su - TowMater -c "echo "WHAT, WTF IS THAT????" >> /var/testes_permissoes/sallyMakesMcQueenDirtyClip600.txt" 

#O primeiro número conta para o dono do arquivo, o segundo para grupos e o terceiro para outros usuários fora de grupos
#4 - apenas leitura; 2 - apenas escrita; 1 - apenas execução
#Somando os valores você permite que o usuário ou grupo tenha múltiplas permissões







