SELECT DISTINCT TPRODUTO.DESCRICAO, AVG(TITMMOV.PRECOUNITARIO)--, TITMMOV.PRECOUNITARIO * TITMMOV.QUANTIDADE 'VL_TOTAL' 
FROM TITMMOV
INNER JOIN TPRODUTO ON TPRODUTO.IDPRD = TITMMOV.IDPRD
INNER JOIN TMOV ON TMOV.CODCOLIGADA = TITMMOV.CODCOLIGADA AND TMOV.IDMOV = TITMMOV.IDMOV
WHERE
--TPRODUTO.DESCRICAO LIKE '%METALON%'AND 
TMOV.CODTMV LIKE '1.2%'
AND TMOV.DATAEMISSAO BETWEEN '2017-07-01' AND GETDATE()
GROUP BY TPRODUTO.DESCRICAO
ORDER BY TPRODUTO.DESCRICAO