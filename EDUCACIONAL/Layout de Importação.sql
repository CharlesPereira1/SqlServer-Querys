Para este mesmo exemplo que voc� criou, poder�amos utilizar a fun��o Concat() a partir do SQL Server 2012:

SELECT Concat(CODCOLIGADA,';',
              CODSTATUS,';',
              DESCRICAO,';', 
              CODTIPOCURSO) as CSV
  from SSTATUS
  where ...

Eis solu��o simples, que utiliza a fun��o nativa CONCAT_WS:
-- c�digo #1
SELECT concat_ws (CODCOLIGADA, CODSTATUS, DESCRICAO, CODTIPOCURSO, ';') as CSV
  from SSTATUS


Outra solu��o, para vers�es anteriores ao SQL Server 2017:
-- c�digo #2
SELECT coalesce (cast (CODCOLIGADA as varchar(12)), '') + ';' +
       coalesce (cast (CODSTATUS as varchar(12)), '') + ';' +
       coalesce (DESCRICAO, '') + ';' +
       coalesce (cast (CODTIPOCURSO as varchar(12)), '') as CSV
  from SSTATUS
  where ...
