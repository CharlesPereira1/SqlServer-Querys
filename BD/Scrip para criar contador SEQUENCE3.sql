-- código #1

USE CORPORERM; 
go

IF OBJECT_ID ('dbo.tbSequence', 'U') is not null
  DROP TABLE dbo.tbSequence;

CREATE TABLE dbo.tbSequence (
     CodColigada smallint not null,
     CodSistema varchar(1) not null,
     Seq varchar(30) not null unique,
     Valor int not null default 0

);
go

-- código #2

IF OBJECT_ID ('dbo.GetSequence') is not null
  DROP PROCEDURE dbo.GetSequence;
go

CREATE PROCEDURE dbo.GetSequence
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
UPDATE dbo.tbSequence
  set @valor = Valor = Valor + @n
  where Seq = @nome_seq
        and CodColigada = @coligada
        and CodSistema = @sistema;

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

-- código #3
-- cria sequência para uso nesta tabela
INSERT into dbo.tbSequence values (1, 'S', 'IDOCORALUNO', 1756774)

--select * from tbsequence

--SELECT MAX(IDOCORALUNO) FROM SOCORRENCIAALUNO WHERE CODCOLIGADA = 1