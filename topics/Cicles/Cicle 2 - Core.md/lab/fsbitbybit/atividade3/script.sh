touch vendas.txt

echo "produto:preco:quantidade
monitor:800:12
webcam:120:8
headset:250:15
SSD_500GB:400:7
RAM_16GB:350:10
fonte_750W:450:5
gabinete:600:3
mousepad:45:25
hub_USB:80:18
cabo_HDMI:35:22
ventilador:90:14
pasta_termica:25:30
suporte_notebook:65:11
carregador_rapido:180:9
cabo_tipo_c:40:28" > vendas.txt


awk -F: '$2 > 100 {print $1}' vendas.txt 

awk -F: '{print $1, $2*$3}' vendas.txt

awk -F: '{sum += $3} END {print sum}' vendas.txt


#Por que usar awk em vez de cut ou grep?
# Para esse caso com esse tipo de estrutura o comando grep foi feito para realizar esse tipo de extração de dados, dessa maneira, ele possui uma versatiliade maior para consultas que o cut e o grep não possuem. O cut por sua vez é como um simples comando SELECT do SQL.

#Como usar awk para processar arquivos CSV?
#Da mesma maneira porque arquivos csv seguem esse mesmo formato, no entanto, usam vírgulas no lugar de ":". E o awk da mesma maneira consegue fazer a distinção e manipular os dados da mesma maneira.

#Qual é a diferença entre awk e sed?
#O sed é um comando bem poderoso para manipulação de exeibição quanto mudança de dados assim o awk. Entretanto, o awk é melhor em consideração ao sed para manipulação e mudançad e dados estruturados.
