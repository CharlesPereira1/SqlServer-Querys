
select max(numremessa), max(id) from flanremessa 

select * from GAUTOINC where CODAUTOINC like '%num%' and 
CODSISTEMA='f'

UPDATE dbo.GAUTOINC
SET VALAUTOINC = 457
WHERE CODCOLIGADA = 1 AND CODSISTEMA = 'F' AND CODAUTOINC = 'NUMREMESSACOB16'
GO

