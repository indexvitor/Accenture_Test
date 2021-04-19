
/* ADICIONAMENTO TABELA DATA DO ULTIMO FLUXO  */
	ALTER TABLE tbContrato
	ADD DataUltimoFluxo DATE NULL
	GO

/* identificador de fluxo do cronograma do contrato */ --checksum
ALTER TABLE tbCronograma
	ADD IDFluxo AS CHECKSUM(IDContrato,IDTranche,Tipo,DatBase)
GO

		--ALTER TABLE tbCronograma
		--	ADD IDFluxo AS CONCAT(IDContrato,IDTranche,Tipo,convert(varchar, "DatBase", 112),IdCronograma)
		--GO

--https://docs.microsoft.com/pt-br/sql/t-sql/functions/checksum-transact-sql?view=sql-server-ver15
--https://stackoverflow.com/questions/45468766/checksum-example-explanation-in-sql-server-t-sql
--https://www.mssqltips.com/sqlservertip/1023/checksum-functions-in-sql-server-2005/

/*----------------------------------------------------------------*/

-- ADICIONAMENTO DE NONCLUSTER INDEX
CREATE NONCLUSTERED INDEX NIX_TbCronograma
	ON tbCronograma (IDContrato ASC, DataFoto DESC)
	INCLUDE(IDFLUXO, TIPO, DATBASE, DATABAIXA, DATAEVENTO, 
		   FOIREALIZADO, PROJETADO, TaxaCambio, TaxaVariante, Taxa)
GO

CREATE NONCLUSTERED INDEX NIX_TbContrato
	ON tbContrato (CodContrato ASC, Emissao DESC, Vencimento DESC)
	Include (NomeContrato, tipoinstrumento, Moeda, Indexador, 
			 Calendario, Basis, Pais, SeriePreco, DataUltimoFluxo)
GO

--https://stackoverflow.com/questions/1307990/why-use-the-include-clause-when-creating-an-index



