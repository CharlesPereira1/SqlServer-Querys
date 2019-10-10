Para este mesmo exemplo que você criou, poderíamos utilizar a função Concat() a partir do SQL Server 2012:

SELECT Concat(CODCOLIGADA,';',
              CODSTATUS,';',
              DESCRICAO,';', 
              CODTIPOCURSO) as CSV
  from SSTATUS
  where ...

Eis solução simples, que utiliza a função nativa CONCAT_WS:
-- código #1
SELECT concat_ws (CODCOLIGADA, CODSTATUS, DESCRICAO, CODTIPOCURSO, ';') as CSV
  from SSTATUS


Outra solução, para versões anteriores ao SQL Server 2017:
-- código #2
SELECT coalesce (cast (CODCOLIGADA as varchar(12)), '') + ';' +
       coalesce (cast (CODSTATUS as varchar(12)), '') + ';' +
       coalesce (DESCRICAO, '') + ';' +
       coalesce (cast (CODTIPOCURSO as varchar(12)), '') as CSV
  from SSTATUS
  where ...
