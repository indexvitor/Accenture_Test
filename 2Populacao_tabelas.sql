/* POPULAÇÃO DAS TABELAS */	

	/* TABELA CONTRATO */
BULK INSERT tbContrato
FROM 'C:\Teste Accenture\ETL arquivos\Arquivo1_Contratos.txt'
WITH (KEEPIDENTITY,
	  FIRSTROW = 2,
	  ROWTERMINATOR ='\n',
	  MAXERRORS=0);
GO

SELECT IDContrato FROM tbContrato
GO
/* ------------------------------------------------*/


	/* TABELA CRONOGRAMA */
BULK INSERT tbCronograma
FROM 'C:\Teste Accenture\ETL arquivos\Arquivo2_Cronograma2.csv'
WITH (FIRSTROW = 2,
	  fIELDTERMINATOR =';',
	  ROWTERMINATOR ='\n',
	  MAXERRORS=0);
GO

SELECT * FROM tbCronograma
GO
