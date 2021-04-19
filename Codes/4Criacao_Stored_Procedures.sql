/* Contrução de uma sotred procedure que receberá como parâmetro @IDContrato e @DataFoto, 
e deve retornar o cronograma do contrato na data foto. Formato de saída abaixo: */

-- retornar o mais recente até a datafoto.

CREATE OR ALTER PROCEDURE SP_CONTRATO_DATAFOTO
	@IDContrato INT, @DataFoto DATE
 AS
	SELECT IDCONTRATO, DataFoto, IDFLUXO, TIPO, DATBASE, DATABAIXA, DATAEVENTO, 
		   FOIREALIZADO, PROJETADO, TaxaCambio, TaxaVariante, Taxa
		   FROM tbCronograma
	WHERE IDCONTRATO = @IDContrato AND DATAFOTO = @DataFoto
	ORDER BY DataBaixa DESC
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
na segunda coluna o indexador em ordem crescente e na terceira coluna o indexador em ordem
decrescente. */

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





/* Construção de uma stored procedure que retorne na primeira coluna o Nome do contrato, 
na segunda coluna o indexador em ordem crescente e na terceira coluna o indexador em ordem
decrescente. */
CREATE OR ALTER PROCEDURE SP_NomeContrato_Indexador2
	--@NomeContrato VARCHAR(30)
 AS
	SELECT NomeContrato,
			ROW_NUMBER() OVER(ORDER BY Indexador DESC) as Ind_Decrescente,
			ROW_NUMBER() OVER(ORDER BY Indexador ASC) as Ind_Crescente,
			 Indexador
	FROM tbContrato
	--WHERE NomeContrato	LIKE ''+@NomeContrato+''
GO

EXEC SP_NomeContrato_Indexador2 
GO



--MANIPULAÇÃO DE FUNÇÕES XML
--Criar uma consulta que retorne para cada contrato um xml com os atributos seguindo o schema abaixo 
--e insira em uma nova tabela contendo duas colunas: IDContrato, xmlgerado
--<contract>
--<[tipoinstrumento] @issuedate @calendar @basis/>
--<currency @index @currency />
--<series @priceseries>
--</[tipoinstrumento]>
--</contract>

/* CRIAÇÃO DOS XMLs */
SELECT * FROM tbContrato

DECLARE @IDCONTRATO INT
SET @IDCONTRATO = 372586
SELECT 
        IDContrato AS '@Contrato',
       (
            SELECT
					Emissao AS '@issuedate',
					Calendario AS'@calendar',
					Basis AS '@basis'
			FROM tbContrato
			WHERE IDContrato = @IDCONTRATO
			FOR XML PATH ('Date'), TYPE
		),
		(
			SELECT
					Indexador AS '@index',
					Moeda AS '@currency'
			FROM tbContrato
			WHERE IDContrato = @IDCONTRATO
			FOR XML PATH ('Currency'), TYPE
		),
		(
			SELECT
					SeriePreco AS '@priceseries'
			FROM tbContrato
			WHERE IDContrato = @IDCONTRATO
			FOR XML PATH ('PriceSeries'), TYPE
		)
FROM tbContrato
WHERE IDContrato = @IDCONTRATO
FOR XML PATH ('Contrato'), ROOT ('ACCENTURE')
GO

CREATE TABLE XML_DATA(
	IDContrato INT UNIQUE,
	XMLGERADO NVARCHAR(MAX)
)
GO

--CRIAÇÃO DA PROC QUE ADICIONA OS XMLS A TABELA XML_DATA
CREATE PROCEDURE SP_MANIPULA_XML 
	@IDCONTRATO INT 
AS 
DECLARE @xmlgerado xml
SET @xmlgerado = ( SELECT -- Definição da variável como o resultado da criação do XML.
        IDContrato AS '@Contrato',
       (
            SELECT
					Emissao AS '@issuedate',
					Calendario AS'@calendar',
					Basis AS '@basis'
			FROM tbContrato
			WHERE IDContrato = @IDCONTRATO
			FOR XML PATH ('Date'), TYPE
		),
		(
			SELECT
					Indexador AS '@index',
					Moeda AS '@currency'
			FROM tbContrato
			WHERE IDContrato = @IDCONTRATO
			FOR XML PATH ('Currency'), TYPE
		),
		(
			SELECT
					SeriePreco AS '@priceseries'
			FROM tbContrato
			WHERE IDContrato = @IDCONTRATO
			FOR XML PATH ('PriceSeries'), TYPE
		)
FROM tbContrato
WHERE IDContrato = @IDCONTRATO -- Recebe a variável da Proccedure
FOR XML PATH ('Contrato'), ROOT ('ACCENTURE')) -- tranforma o xml e o ")" fecha o resultado da definição da variável @xmlgerado

SELECT @Xmlgerado -- adiciona o resultado da váriavel a tabela XML_DATA recebendo as duas variáveis.
INSERT INTO XML_DATA (IDContrato, XMLGERADO) 
VALUES (@IDCONTRATO, @xmlgerado)
GO

SELECT IDCONTRATO FROM tbContrato
GO

EXEC SP_MANIPULA_XML 441000 
GO

SELECT * FROM XML_DATA
GO


--https://www.informit.com/articles/article.aspx?p=389112&seqNum=2
--http://www.linhadecodigo.com.br/artigo/3705/representando-dados-em-xml-no-sql-server.aspx
--http://www.linhadecodigo.com.br/artigo/3705/representando-dados-em-xml-no-sql-server.aspx#ixzz6sOhQEDab
--https://docs.microsoft.com/pt-br/sql/relational-databases/xml/examples-using-path-mode?view=sql-server-ver15
--https://stackoverflow.com/questions/48338477/insert-into-select-in-sql-server

--Crie um script que insere um novo atributos chamado “calendarname” 
--nos xmls dessa nova tabela. O Atributo deve ser o valor da tag @calender sem o prefixo ‘CAL’
UPDATE XML_DATA
SET xmlgerado.modify('insert atribute calendar {sql:variable("@calendarname")}'
						+(SELECT SUBSTRING( c.Calendario, 4, 6) AS CALENDARNAME
						FROM XML_DATA AS X
						INNER JOIN tbContrato AS C
							ON X.IDContrato = C.IDContrato
						WHERE x.IDContrato = 170374)+
					 'into (/ACCENTURE/Contrato)[1]')
WHERE IDContrato = 170374

SELECT * FROM XML_DATA

----------------------------

DECLARE @x XML
SELECT @x = (
			SELECT XMLGERADO
			FROM XML_DATA
			WHERE IDContrato = 170374
			)
SET @x.modify('
    insert element calendardate {'+(SELECT SUBSTRING( c.Calendario, 4, 6) AS CALENDARNAME
						FROM XML_DATA AS X
						INNER JOIN tbContrato AS C
							ON X.IDContrato = C.IDContrato
						WHERE x.IDContrato = 170374)+'}
    as first
    into (calendardate)[1]
    ')
SELECT @x
go


--Crie um script que remova dos xmls a nova tag criada.
UPDATE XML_DATA
SET xmlgerado.modify('delete (/ACCENTURE/Contrato/Currency)')
WHERE IDContrato = 170374