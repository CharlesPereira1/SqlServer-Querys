/*** código #1 ***/
USE CORPORERM_teste; 
go

IF OBJECT_ID ('dbo.tbSequence2', 'U') is not null
  DROP TABLE dbo.tbSequence2;

CREATE TABLE dbo.tbSequence2 (
     CodColigada smallint not null,
     CodSistema varchar(1) not null,
     Seq varchar(30) not null unique,
     Valor int not null default 0
);
	 
/*** código #2 ***/
USE CorporeRM_TESTE; 
go

IF OBJECT_ID ('dbo.tbSequence2', 'U') is not null
  DROP TABLE dbo.tbSequence2;

CREATE TABLE dbo.tbSequence2 (
     CodColigada smallint not null,
     CodSistema varchar(1) not null,
     Seq varchar(30) not null unique,
     Valor int not null default 0

);
go

comercial@al-informatica.com.br

/*** código #3 ***/
IF OBJECT_ID ('dbo.GetSequence2') is not null
  DROP PROCEDURE dbo.GetSequence2;
go

CREATE PROCEDURE dbo.GetSequence2
     @coligada smallint,
	 @nome_seq varchar(30),      
     @sistema varchar(1),
     @valor int output,
     @n int = 1
as
begin
set nocount on;
declare @retorno int, @NLinhas int;

set @valor= NULL;
UPDATE dbo.tbSequence2
  set @valor = Valor = Valor + @n
  where Seq = @nome_seq;

SELECT @retorno= @@error, @NLinhas= @@rowcount;
IF @retorno = 0 
  begin
  IF @NLinhas = 1
    set @valor= @valor - @n +1
  else 
    set @retorno= -1; -- erro na geração do próximo valor
  end;

return @retorno;
end;
go

/*** código #4 ***/
-- cria sequência para uso nesta tabela
INSERT into dbo.tbSequence2 values (1, 'S', 'IDOCORALUNO', 1756774)

--select * from tbSequence2

--SELECT MAX(IDOCORALUNO) FROM SOCORRENCIAALUNO WHERE CODCOLIGADA = 1

/*** código #5 ***/
-- armazena os nomes em tabela temporária
DECLARE @Nomes table (CODCOLIGADA smallint, RA varchar(20), CODOCORRENCIAGRUPO smallint, CODOCORRENCIATIPO int, IDPERLET int, DATAOCORRENCIA datetime, OBSERVACOES text, DISPONIVELWEB varchar(1), RECCREATEDBY varchar(50), RECCREATEDON datetime, RECMODIFIEDBY varchar(50), RECMODIFIEDON datetime, RESPONSAVELCIENTE varchar(1));

--???? colocar Script aqui... obs.: no inser original tirar o IDOCORALUNO, e modificar o nome da tabela de inserção para @Nomes

-- próximo valor disponível
declare @NLinhas int, @Prox_Valor int;
set @NLinhas= (SELECT count(*) from @Nomes);

BEGIN TRANSACTION;

EXECUTE dbo.GetSequence2
	 @coligada = '1',
	 @sistema = 'S',
     @nome_seq= 'IDOCORALUNO',
     @valor = @Prox_Valor output, 
     @n = @NLinhas;

INSERT into dbo.socorrenciaaluno (CODCOLIGADA, IDOCORALUNO,  RA, CODOCORRENCIAGRUPO, CODOCORRENCIATIPO, IDPERLET,DATAOCORRENCIA, OBSERVACOES, DISPONIVELWEB, RECCREATEDBY, RECCREATEDON, RECMODIFIEDBY, RECMODIFIEDON, RESPONSAVELCIENTE)
  SELECT	CODCOLIGADA, 
			@Prox_Valor - 1 + row_number() over (order by (SELECT 0)),
			RA, CODOCORRENCIAGRUPO, CODOCORRENCIATIPO, IDPERLET, DATAOCORRENCIA, OBSERVACOES, DISPONIVELWEB, RECCREATEDBY, RECCREATEDON, RECMODIFIEDBY, RECMODIFIEDON, RESPONSAVELCIENTE
    from @Nomes as N;

COMMIT;
go

----select * from tbSequence2
--INSERT into dbo.tbSequence2 values (1, 'S', 'IDOCORALUNO', 1756774)

---- código #1
--USE CORPORERM_teste; 
--go

--IF OBJECT_ID ('dbo.tbSequence2', 'U') is not null
--  DROP TABLE dbo.tbSequence2;

--CREATE TABLE dbo.tbSequence2 (
--     CodColigada smallint not null,
--     CodSistema varchar(1) not null,
--     Seq varchar(30) not null unique,
--     Valor int not null default 0
--);




