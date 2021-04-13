# Accenture_Test
Teste da Accenture

1- O Arquivo de cronograma teve os valores NULOS substituídos por "nada" diretamente no arquivo do Excel,
porém podia ter sido importado com NULL, depois substiuído essas "strings" com um:

UPDATE tabela

SET coluna = REPLACE(coluna,'NULL','') -- Nenhum valor dentro das aspas simples do ultimo campo.

GO

--------------

2- Foi criada uma coluna computada para a identifcação do fluxo cotendo as colunas informadas 
como identificadores e uma coluna IdCronograma adiciona afim de evitar duplicidades.

--------------

3- Tentei criar uma SP para o insert dos arquivos do terceiro arquivo, porém não ainda não consegui 
uma forma de criar uma variável declaravel na Procedure para o caminho do arquivo dentro de um Bulk Insert.

--------------


