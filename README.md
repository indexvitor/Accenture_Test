# Accenture_Test
Teste da Accenture

** ***UPDATE 19/04:
- Foi alterado o DataType do Identificador de Fluxo para INT utilizando CHECKSUM.
- Foram adicionadas colunas no campo INCLUDE do Índices Non-clustered.
- Alteração da primeira SP para que retorne o valor até a Data Foto.
- Alteração da terceira SP para que retorne os valores em order crescente e decrescente com ROWNUMBER.
- XML > Primeira e Terceira requisições efetuadas com sucesso. 

--------------
1- O Arquivo de cronograma teve os valores NULOS substituídos por "nada" diretamente no arquivo do Excel,
porém podia ter sido importado com NULL, depois substiuído essas "strings" com um:

UPDATE tabela

SET coluna = REPLACE(coluna,'NULL','') -- Nenhum valor dentro das aspas simples do ultimo campo.

GO

--------------

2- Foi criada uma coluna computada para a identifcação do fluxo cotendo as colunas informadas 
como identificadores e uma coluna IdCronograma adiciona afim de evitar duplicidades.

--------------

3- Tentei criar uma SP para o insert dos dados do terceiro arquivo, porém não ainda não consegui 
uma forma da SP aceitar uma variável declaravel para o caminho do arquivo dentro de um Bulk Insert.

--------------

4- Os valores foram alterados para número e as virgulas substituídas por ponto '.', afim de o 
SQL reconhecesse os centavos e não os adicionasse por 00 no fim desses valores.

--------------


--------------


--------------


