with 
Consulta as (
SELECT 
CASE 
		EVA.tipo_acesso
	WHEN 1 THEN DBO.CONVERTESEGUNDOSEMHORAS(EVA.HORA)
	END as 'entrada',
	CASE 
		EVA.tipo_acesso
	when 2 THEN DBO.CONVERTESEGUNDOSEMHORAS(EVA.HORA)
	END as 'saida',
	PPC.ID AS ID_PESSOAS,
	EVA.pessoa_id AS ID_EVENTOSACESSOS,
	CONVERT (DATETIME, EVA.DATA, 126)AS DATA_CONVERTIDA,
	DBO.CONVERTESEGUNDOSEMHORAS(EVA.HORA) AS HORAS_CONVERTIDA,
	EVA.DATA AS DATA_DE_ACESSO,
	EVA.hora,
	EVA.equipamento_id,
	EVA.tipo_acesso,
	EVA.descricao,
	EVA.negado,
	PPC.n_identificador AS MATRICULA,
	PPC.NOME AS NOME_PESSOA,
	SMA.NUMCARTEIRA AS NUMEROCARTEIR,
	SMA.CODTURMA,
	EVA.DATA AS DATA_EVA,
	SMA.IDPERLET,
	SMA.RA
FROM 
	[192.168.6.12].[SecullumAcessoNet].[DBO].PESSOAS  PPC (NOLOCK ) 
	LEFT JOIN [192.168.6.12].[SecullumAcessoNet].[DBO].eventos_acessos EVA (NOLOCK) ON  PPC.id = EVA.pessoa_id 
	LEFT JOIN SMATRICPL SMA (NOLOCK) ON  SMA.NUMCARTEIRA COLLATE SQL_Latin1_General_CP1_CI_AI = PPC.n_identificador COLLATE SQL_Latin1_General_CP1_CI_AI

where
eva.negado= 0 and
--sma.ra='15507029' and
--SMA.NUMCARTEIRA in ('14947657', '2358027') AND
 CONVERT (DATETIME, EVA.DATA) = '2018-07-27'
 and sma.ra is null
),


Ponto_seq as (
SELECT NUMEROCARTEIR, NEGADO, MATRICULA, DATA_DE_ACESSO, HORAS_CONVERTIDA, tipo_acesso, IDPERLET, RA, NOME_PESSOA,
       Seq= row_number() over (partition by MATRICULA, DATA_DE_ACESSO order by HORA)
  from Consulta
)
SELECT P1.MATRICULA, p1.NUMEROCARTEIR, P1.RA, P1.DATA_DE_ACESSO, P1.IDPERLET, P1.NEGADO, p1.NOME_PESSOA,
       case 
			when P1.tipo_acesso = 1 and P1.HORAS_CONVERTIDA is not null then P1.HORAS_CONVERTIDA
			when P1.tipo_acesso = 2 and P1.HORAS_CONVERTIDA is not null then P1.HORAS_CONVERTIDA
	  end 'batida',
	  case 
			when P1.tipo_acesso = 1 and P1.HORAS_CONVERTIDA is not null then 'entrada'
			when P1.tipo_acesso = 2 and P1.HORAS_CONVERTIDA is not null then 'Saida'
	  end 'status'
       --P2.HORAS_CONVERTIDA as SAÍDA
  from Ponto_seq as P1
       inner join Ponto_seq as P2 on P1.MATRICULA = P2.MATRICULA
                                          and P1.DATA_DE_ACESSO = P2.DATA_DE_ACESSO
                                          and P1.Seq = P2.Seq
ORDER BY 1,7 desc
