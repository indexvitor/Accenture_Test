/* CRIANDO BANCO E ACESSANDO */
CREATE DATABASE TESTE_ACCENTURE
GO
USE TESTE_ACCENTURE
GO

/* CRIAÇÃO DAS TABELAS */
CREATE TABLE tbContrato(
	IDContrato INT NOT NULL IDENTITY,
	CodContrato INT NOT NULL, -- Foi mantida apenas a numeração do código do contrato.
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
	DatBase DATE NOT NULL, --Coluna nomeada como DATbase por boa prática.
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
