SELECT DISTINCT
	A1.CODCOLPRD, A1.IDPRD, A1.CODIGOPRD 'CODCOLIG 00', A1.NOMEFANTASIA, 
	B1.CODCOLPRD, A1.IDPRD, B1.CODIGOPRD 'CODCOLIG 04', B1.NOMEFANTASIA
	--A1.CODCOLPRD 'COL0', A1.CODIGOPRD, B1.NUMNOFABRIC, A1.NOMEFANTASIA,
	--B1.CODCOLPRD 'COL4', B1.CODIGOPRD, B1.NUMNOFABRIC, B1.NOMEFANTASIA
FROM
(SELECT A.CODCOLPRD, A.IDPRD, A.CODIGOPRD, B.NUMNOFABRIC, A.NOMEFANTASIA FROM TPRODUTO A
INNER JOIN TPRODUTODEF B ON A.IDPRD = B.IDPRD --AND A.CODCOLPRD = B.CODCOLIGADA
WHERE
A.CODCOLPRD=0)
A1
INNER JOIN(
SELECT A.CODCOLPRD, A.IDPRD, A.CODIGOPRD, B.NUMNOFABRIC, A.NOMEFANTASIA FROM TPRODUTO A
INNER JOIN TPRODUTODEF B ON A.IDPRD = B.IDPRD --AND A.CODCOLPRD = B.CODCOLIGADA
WHERE
A.CODCOLPRD=2) B1 ON A1.CODIGOPRD = B1.CODIGOPRD
WHERE
A1.NOMEFANTASIA <> B1.NOMEFANTASIA

ORDER BY 4

