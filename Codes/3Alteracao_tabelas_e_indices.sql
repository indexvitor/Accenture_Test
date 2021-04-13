
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