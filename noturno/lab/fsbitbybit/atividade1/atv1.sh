touch dados.txt
echo -e "nome: Pablo\nemail: pablo@gmail.com\nidade: 2\nnome: Rick Astley\nemail: rick@rolling.com\nidade: 20000000\nnome: Toguro\nemail: sabor@gmail.com\nidade: 30\nnome: Gabriel Caramez\nemail: linux@cinema.com\nidade: ?\nnome: Shia Labeouf\nemail: just@doit.com\nidade: 30\nnome: Drew Gooden\nemail: roadwork@headISureHopeItDoes.com\nidade: 30\nnome: Chorão\nemail: SóOsSk@tesSabem.com" dados.txt

touch gmail.txt
grep "gmail.com"  dados.txt > gmail.txt

touch semNum.txt
grep -v [[:digit:]] dados.txt > semNum.txt

touch temA.txt
grep -c "a" dados.txt > temA.txt

touch comecaComA.txt
grep '^A' dados.txt > comecaComA.txt
