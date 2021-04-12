/* CRIANDO BANCO E ACESSANDO */
CREATE DATABASE TESTE_ACCENTURE
GO
USE TESTE_ACCENTURE
GO

/* CRIAÇÃO DAS TABELAS */
CREATE TABLE tbContrato(
	IDContrato INT NOT NULL IDENTITY,
	CodContrato VARCHAR(30) NOT NULL,
	NomeContrato VARCHAR(20) NOT NULL,
	TipoInstrumento VARCHAR(10) NOT NULL,
	Vencimento DATE NOT NULL,
	Emissao DATE NOT NULL,
	Moeda CHAR(3) NULL,
	Indexador VARCHAR (30) NULL,
	Calendario VARCHAR (50) NOT NULL,
	Basis VARCHAR (30) NOT NULL,
	Pais CHAR (6) NOT NULL,
	SeriePreco VARCHAR(30) NULL

	CONSTRAINT PK_IDCONTRATO PRIMARY KEY (IDContrato)
)
GO


CREATE TABLE tbCronograma(
	IDContrato INT NOT NULL,
	DataFoto DATE NOT NULL,
	IDTranche TINYINT NOT NULL,
	Tipo INT NOT NULL,
	DatBase DATE NOT NULL,
	DataBaixa DATE NOT NULL,
	DataEvento DATE NOT NULL,
	Projetado DECIMAL (38,2) NOT NULL,
	Realizado DECIMAL (38,2) NOT NULL,
	TaxaCambio DECIMAL (38,2) NOT NULL,
	TaxaVariante DECIMAL (38,2) NOT NULL,
	Taxa DECIMAL (38,2) NOT NULL,
	FoiRealizado BIT NOT NULL
)
GO

/* FOREIGN KEY DE CRONOGRAMA PARA CONTRATO */
ALTER TABLE tbCronograma
	ADD CONSTRAINT FK_Cronograma_Contrato
	FOREIGN KEY (IDContrato) REFERENCES tbContrato(IDContrato)
GO

/* ------------------------------------------------*/



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

/* ------------------------------------------------*/

/* ADICIONAMENTO TABELA DATA DO ULTIMO FLUXO  */
	ALTER TABLE tbContrato
	ADD DataUltimoFluxo DATE NULL
	GO

/* ADICIONANDO COLUNA IDCRONOGRAMA */
ALTER TABLE tbCronograma
	add IDCronograma INT IDENTITY(1,1) NOT NULL
GO

/* identificador de fluxo do cronograma do contrato */ 
ALTER TABLE tbCronograma
	ADD IDFluxo AS CONCAT(IDContrato,IDTranche,Tipo,convert(varchar, "DatBase", 112),IdCronograma)
GO

-- DEFINIÇÃO DO CAMPO COMO PK
ALTER TABLE tbCronograma
	ADD CONSTRAINT PK_IDFluxo PRIMARY KEY (IDFluxo)
GO

-- ADICIONAMENTO DE NONCLUSTER INDEX
CREATE NONCLUSTERED INDEX TbCronograma
ON tbCronograma (IDContrato ASC, DataFoto DESC)
GO

CREATE NONCLUSTERED INDEX NIX_TbContrato
ON tbContrato (CodContrato ASC, Emissao DESC, Vencimento DESC)
GO

select * from [dbo].[tbCronograma]

/* Contrução de uma sotred procedure que receberá como parâmetro @IDContrato e @DataFoto, 
e deve retornar o cronograma do contrato na data foto. Formato de saída abaixo: */

CREATE PROCEDURE SP_CONTRATO_DATAFOTO
	@IDContrato INT, @DataFoto DATE
 AS
	SELECT IDCONTRATO, IDFLUXO, TIPO, DATBASE, DATABAIXA, DATAEVENTO, 
		   FOIREALIZADO,
		   PROJETADO, TaxaCambio, TaxaVariante, Taxa
		   FROM tbCronograma
WHERE IDCONTRATO = @IDContrato AND DATAFOTO = @DataFoto
GO

-----------
-- Chamar a proc inserindo Id do Contrato e Data da Foto
EXEC SP_CONTRATO_DATAFOTO 1502135, '19000101'
GO

------

				/* Construção de uma stored procedure que apartir dos 
				dados do arquivo 3 irá inserir novas fotos no modelo. */

				-----



/* Construção de uma stored procedure que retorne na primeira coluna o Nome do contrato, 
na segunda coluna o indexador em ordem crescente e na terceira coluna o indexador em ordem decrescente. */

	--DROP PROCEDURE SP_NomeContrato_Indexador

CREATE PROCEDURE SP_NomeContrato_Indexador
	@NomeContrato VARCHAR(30)
 AS
	SELECT	NomeContrato, Indexador AS IndexadorCrescente, 
						  Indexador as IndexadorDecrescente2
	FROM tbContrato
	WHERE NomeContrato	LIKE ''+@NomeContrato+''
	ORDER BY IndexadorCrescente ASC, 
			 IndexadorDecrescente2 DESC
GO
-- Chamar Proc com o nome exato do contrato
-- ou adicionando uma fração do nome entre aspas simples e sinais de % ( '%Exemplo%' )
EXEC SP_NomeContrato_Indexador '%trato_12%'
GO


/*------------------------------------------*/

/*MONITORIA DE BANCO
Para previnir gargalos que impessam os processos do banco de excutarem com normalidade, 
você deve descrever meios de monitorar o banco para indentificar esses pontos criticos.

 - Verificação de espaço livre em disco,
 - Tamanho dos arquivos de backups, log,
 - Memória sendo consumida pelo banco,
 - Custo de queries.
*/








































