select 
	A.PRJ,
	((sum(a.percentual)/sum(a.total) / (sum(a.total)/100)) * 100) 'PERC_GERAL',
	sum(custototal) 'CUSTO_TOTAL'
from
(select MPRJ.CODPRJ+' - '+UPPER(MPRJ.DESCRICAO) 'PRJ',
	100 'total', 
	CASE WHEN mtarefa.PERCCONCLUIDO IS NULL THEN 0 ELSE mtarefa.PERCCONCLUIDO END 'percentual',
	mtarefa.custototal
from mtarefa 
INNER JOIN MPRJ ON MPRJ.CODCOLIGADA = mtarefa.CODCOLIGADA AND MPRJ.IDPRJ = mtarefa.IDPRJ
where 
	mtarefa.idprj= 8
	and mtarefa.quantidade is not null 
	and mtarefa.SERVICO=0) A
GROUP BY A.PRJ
/******************************************/
select 
	UPPER(B.NOME),
	B.TOTAL,
	B.PERCENTUAL 'PERC_CONCLUIDO',
	((B.percentual/B.total)*100) 'PERC_GRUPO_TAREFA'
from
(select codtrf+' - '+NOME 'NOME', 
	100 'total', 
	CASE WHEN PERCCONCLUIDO IS NULL THEN 0 ELSE PERCCONCLUIDO END 'PERCENTUAL'
from mtarefa 
where 
	idprj= 8
	and quantidade is not null 
	and SERVICO=0
) B


--select 80/100*100 *** IDEIA, QUANDO ACHAR OS PERCENTUAIS CONCLUIDOS DOS GRUPOS, 
--SOMAR TODOS E DIVIDIR POR 100 EM SEGUIDA MULTIPLICAR POR 100 PARA ACHAR O PERCENTUAL TOTAL DA OBRA
--CRIAR

--((sum(a.total)/100) / (sum(a.total)/100)) * 100
--(a.PERCCONCLUIDO / 100) * 100 FORMA CORRETA PARA REALIZAR O CALCULO INDIVIDUALMENTE
--((sum(a.percconcluido)/100) / (sum(a.total)/100)) * 100 /*FORMA CORRETA DE SE FAZER O CALCULO GERAL*/

SELECT * FROM MPRJ
MPRJ.CODPRJ+' - '+UPPER(MPRJ.DESCRICAO)