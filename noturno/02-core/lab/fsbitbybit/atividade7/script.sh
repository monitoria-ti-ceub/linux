touch relatorio.txt

# ls -l | awk '$1 == "drwxrwxrwx" {print $9}' usando o pipe
find ~ -type f -perm 777 >> relatorio.txt

#ls -l | awk 'substr($1, 4, 1) == "s" {print $9}'
find ~ -perm -4000 >> relatorio.txt

grep ":0:" /etc/passwd >> relatorio.txt
