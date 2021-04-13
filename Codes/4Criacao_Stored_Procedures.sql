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


          /*------------------------------------------------------------------*/
				/* Construção de uma stored procedure que apartir dos 
				dados do arquivo 3 irá inserir novas fotos no modelo. */

          /*------------------------------------------------------------------*/



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
