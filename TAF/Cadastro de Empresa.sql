select distinct
a.CODCOLIGADA, 
upper(A.codigo) 'cod', 
upper(A.DESCRICAO) 'descricao', 
upper(B.NOME) 'segnome',
replace(CONVERT(VARCHAR, A.TELEFONE), '-', '') 'TELEFONE',
replace(replace(replace(CONVERT(VARCHAR, A.CGC), '-', ''), '.', ''), '/', '')'CNPJ', 
replace(CONVERT(VARCHAR, A.INSCRESTADUAL), '.', '') 'INSCRESTADUAL', 
upper(A.RUA) 'rua', 
upper(A.COMPLEMENTO) 'complemento', 
upper(A.BAIRRO) 'bairro', 
upper(A.CIDADE) 'CIDADE',
replace(replace(CONVERT(VARCHAR, A.CEP), '-', ''), '.', '') 'CEP',
a.CODMUNICIPIO

from psecao A
left join GDEPTO B ON B.CODDEPARTAMENTO = A.CODDEPTO AND B.CODCOLIGADA = A.CODCOLIGADA and a.CODFILIAL = b.CODFILIAL
--INNER JOIN DTIPORUA C ON A.CODIGO = C.CODIGO
where
a.CODCOLIGADA=5
order by 2


--SELECT * FROM GDEPTO