--ALTER procedure [dbo].[ATUALIZA_CATRACA] AS

--DELETE FROM ZALTERACAO_CATRACA WHERE DT_ATUALIZA < GETDATE() -1

/*TIRADENTES */
--UPDATE [192.168.4.12].[SecullumAcessoNet].[DBO].PESSOAS SET N_IDENTIFICADOR = NUMCARTEIRA


select p.n_identificador, p.nome, z.numcarteira, z.nome, sma.ra, sma.numcarteira, max(z.codigo)
FROM ZALTERACAO_CATRACA z (NOLOCK)
	inner JOIN [192.168.6.12].[SecullumAcessoNet].[DBO].PESSOAS P (NOLOCK)
	ON P.NOME COLLATE SQL_Latin1_General_CP1_CI_AI = z.NOME COLLATE SQL_Latin1_General_CP1_CI_AI
	--LEFT JOIN SMATRICPL SMA (NOLOCK) ON  SMA.NUMCARTEIRA COLLATE SQL_Latin1_General_CP1_CI_AI = p.n_identificador COLLATE SQL_Latin1_General_CP1_CI_AI
	left JOIN SMATRICPL SMA (NOLOCK) ON  SMA.ra COLLATE SQL_Latin1_General_CP1_CI_AI = z.ra COLLATE SQL_Latin1_General_CP1_CI_AI
WHERE 
	--convert(CHAR,dt_atualiza,103) = convert(CHAR,getdate(),103)
	--CONVERT (DATETIME, EVA.DATA) = '2018-07-10' 
	--AND 
	p.N_IDENTIFICADOR  COLLATE SQL_Latin1_General_CP1_CI_AI <> z.NUMCARTEIRA  COLLATE SQL_Latin1_General_CP1_CI_AI
	AND z.NUMCARTEIRA IS NOT NULL
	and sma.codstatus=2
	group by p.n_identificador, p.nome, z.nome, sma.ra, sma.numcarteira, z.numcarteira, z.codigo
	having  
	z.codigo = max(z.codigo)
--group by p.n_identificador, p.nome, z.nome, sma.ra, sma.numcarteira
	
--update smatricpl set numcarteira='1908294' where ra='15020818' and codstatus=2

--select * from zalteracao_catraca where ra='15020818'

/*
select * from ZALTERACAO_CATRACA where numcarteira='9002528' 

select * from [192.168.6.12].[SecullumAcessoNet].[DBO].PESSOAS 
where n_identificador = '9002528' 
order by nome


select * from [192.168.6.12].[SecullumAcessoNet].[DBO].PESSOAS 
where n_identificador = '9002528' 
order by nome


select * from zbatidascatraca
*/