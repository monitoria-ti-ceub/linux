touch config.txt
echo "SERVIDOR=localhost
PORTA=8080
AMBIENTE=desenvolvimento
DB_HOST=localhost
DB_PORT=5432
DB_USER=admin
DB_PASSWORD=senha123
DB_NAME=Driver
API_KEY=esqueciDaChaveOhMeuDeusDeNovoNãoToCansadoDisso
JWT_SECRET=secreto
DEBUG=false
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
EMAIL_USER=Ax@ndTheHatchetman.com
EMAIL_PASSWORD=Cheesecake
LOG_LEVEL=INFO
LOG_FILE=logs/app.log
TIMEOUT_CONEXAO=30
MAX_CONEXOES=100
" > config.txt

sed -i "s/localhost/192.168.1.1/" config.txt

sed -i '/^#/d' config.txt

sed -n '5,10p' config.txt

sed -i "s/^/HELLO/" config.txt

#Por que usar sed em vez de editar o arquivo manualmente?
#Em razão de facilitar algumas coisas em massa e fazer isso impressionantemente rápido. Redução de erros de escrita ou a produção deles em massa.

#Qual é a diferença entre sed 's/old/new/' e sed 's/old/new/g'?
#O primeiro apenas faz o replace na primeira aparição da palavara, a flag g(global) fala para o sed fazer o replace em todas as linha em todas as aparições da palavra a ser renomeada

#Como usar sed para fazer backup antes de modificar?
# sed config.txt > backup.config.txt 
