/*EM ABERTO*/
SELECT DISTINCT B.CODCCUSTO+' - '+B.NOME 'CENTRODECUSTOS', A.HISTORICO, A.DATAVENCIMENTO, A.VALORORIGINAL, A.VALOROP1 'DESCBOLSA', 
CASE WHEN GETDATE() > A.DATAVENCIMENTO THEN A.VALORORIGINAL * 0.02 END 'MULTA',
CASE WHEN GETDATE() > A.DATAVENCIMENTO THEN  DATEDIFF(DAY, A.DATAVENCIMENTO, GETDATE()) * (A.VALORORIGINAL * 0.0033) / 100 END 'JUROS'

FROM FLAN A
INNER JOIN GCCUSTO B ON B.CODCOLIGADA = A.CODCOLIGADA AND B.CODCCUSTO = A.CODCCUSTO
WHERE
A.STATUSLAN=0 AND
A.PAGREC=1

/*BAIXADOS*/
SELECT DISTINCT C.CODCCUSTO+' - '+C.NOME 'CENTRODECUSTOS', A.HISTORICO, D.DESCFORMAPAGTO, A.DATAVENCIMENTO, B.VALORORIGINAL, B.VALOROP1 'DESCBOLSA', B.VALORDESCONTO, B.VALORJUROS, B.VALORMULTA,
B.VALORBAIXA, B.DATABAIXA
FROM FLAN A
INNER JOIN FLANBAIXA B ON B.IDLAN = A.IDLAN AND B.CODCOLIGADA = A.CODCOLIGADA
INNER JOIN GCCUSTO C ON C.CODCOLIGADA = A.CODCOLIGADA AND C.CODCCUSTO = A.CODCCUSTO
INNER JOIN TFORMAPAGTO D ON D.CODCOLIGADA = A.CODCOLIGADA AND D.IDFORMAPAGTO = B.IDFORMAPAGTO
WHERE
A.STATUSLAN=1 AND
A.PAGREC=1


/*MULTA*/

SE RECEBER = 1
ENTAO

SE DATASISTEMA > DATAVENCIMENTO ENTAO 
   (VALORORIGINAL - VALOROP1)*0.02

SENAO 0

FIMSE 

SENAO 0
FIMSE

/*JUROS*/
SE 
RECEBER = 1
ENTAO SE 
DATASISTEMA > DATAVENCIMENTO  ENTAO 
(DATASISTEMA -  DATAVENCIMENTO) * (VALORORIGINAL * 0.033) / 100
SENAO
0
FIMSE