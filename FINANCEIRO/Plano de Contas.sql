SELECT 
	G.NOMEFANTASIA 'EMPRESA', 
	A.VALORLIQUIDOORIG 'VALOR_ORIGINAL', 
	A.NUMEROMOV 'NF-E', 
	A.SEGUNDONUMERO 'N� AF', 
	A.CHAVEACESSONFE 'CHAVE_NF-E',
	I.CODCONTA 'PLANO_DE_CONTAS', 
	F.NOME 'CENTRO_DE_qadCUSTOS', 
	D.VALOR, H.DEBOUCRED
FROM TMOV A (NOLOCK)
INNER JOIN FLAN B (NOLOCK) ON B.CODCOLIGADA = A.CODCOLIGADA AND B.IDMOV = A.IDMOV
--INNER JOIN CPARTIDA C (NOLOCK) ON C.CODCOLIGADA = B.CODCOLIGADA AND C.IDLANCAMENTO = B.IDLAN
INNER JOIN FLANRATCCU D (NOLOCK) ON B.CODCOLIGADA = D.CODCOLIGADA AND D.IDLAN = B.IDLAN
INNER JOIN TTBORCAMENTO E (NOLOCK) ON D.CODNATFINANCEIRA = E.CODTBORCAMENTO AND E.CODCOLIGADA = D.CODCOLIGADA
INNER JOIN GCCUSTO F (NOLOCK) ON D.CODCOLIGADA = F.CODCOLIGADA AND D.CODCCUSTO = F.CODCCUSTO
INNER JOIN FCFO G (NOLOCK) ON B.CODCOLCFO = G.CODCOLIGADA AND B.CODCFO = G.CODCFO
RIGHT JOIN TTBORCAMENTOCONT H (NOLOCK) ON H.CODTBORCAMENTO = D.CODNATFINANCEIRA AND H.CODCOLIGADA = E.CODCOLIGADA
INNER JOIN CCONTA I (NOLOCK) ON H.CODCONTA = I.CODCONTA AND H.CODCOLIGADA = I.CODCOLIGADA
WHERE
H.DEBOUCRED= 1 --1 - CREDITO E 2 - CREDITO
AND B.NFOUDUP= 1  --1 - LAN�AMENTO PADRAO E 2 - INCLUS�O DE FATURA
AND YEAR(B.DATAEMISSAO)='2018'
--and B.IDLAN=678966
--AND A.CHAVEACESSONFE IS NOT NULL
ORDER BY 1

678967
678966


select statuslan, * from flan where idlan in ('262553',
'262755',
'262942',
'276609'
)

select * from flan where NFOUDUP=2

select * from gcampos where tabela='flan'

select * from flan where IDLAN in ('275997',
'276002',
'276610'
)