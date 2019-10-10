USE [CorporeRM]
GO
/****** Object:  StoredProcedure [dbo].[CONTRATURNO_4]    Script Date: 10/07/2018 16:34:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

                 ALTER PROCEDURE [dbo].[CONTRATURNO_4] AS

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
--sma.ra in ('15020797', '15020796')  and
--SMA.NUMCARTEIRA in ('14947657', '2358027') AND
 CONVERT (DATETIME, EVA.DATA) = CONVERT(DATETIME, FLOOR(CONVERT(FLOAT(24), GETDATE())))
),
Ponto_seq as (
SELECT MATRICULA, DATA_DE_ACESSO, HORAS_CONVERTIDA, tipo_acesso, IDPERLET, RA,
       Seq= row_number() over (partition by MATRICULA, DATA_DE_ACESSO order by HORA)
  from Consulta
)

INSERT INTO dbo.SOCORRENCIAALUNO (CODCOLIGADA, IDOCORALUNO, RA, CODOCORRENCIAGRUPO, CODOCORRENCIATIPO, IDPERLET,DATAOCORRENCIA, OBSERVACOES, DISPONIVELWEB, RECCREATEDBY, RECCREATEDON, RECMODIFIEDBY, RECMODIFIEDON, RESPONSAVELCIENTE)


SELECT CODCOLIGADA, (SELECT 
		MAX(IDOCORALUNO) 
			FROM SOCORRENCIAALUNO 
			WHERE CODCOLIGADA=1)+
			ROW_NUMBER() OVER(PARTITION BY SET4.CODOCORRENCIAGRUPO ORDER BY SET4.RA ASC) 'IDOCORALUNO', 
RA, CODOCORRENCIAGRUPO, CODOCORRENCIATIPO, IDPERLET,DATAOCORRENCIA, OBSERVACOES, DISPONIVELWEB, RECCREATEDBY, RECCREATEDON, RECMODIFIEDBY, RECMODIFIEDON, RESPONSAVELCIENTE
FROM

(SELECT 

1 'CODCOLIGADA',
SET1.RA,
'11' 'CODOCORRENCIAGRUPO',
CASE 
	WHEN SET1.STATUS = 'ENTRADA'  THEN '147' 
	WHEN SET1.STATUS = 'SAIDA'  THEN '146' 
END	'CODOCORRENCIATIPO',
SET1.IDPERLET,
GETDATE() 'DATAOCORRENCIA',

	CASE 
		WHEN SET1.BATIDA IS NOT NULL AND SET1.STATUS = 'ENTRADA' THEN convert(varchar(100), concat('2 - ALUNO ENTROU NO COLEGIO ÀS ',+SET1.BATIDA))
		WHEN SET1.BATIDA IS NOT NULL AND SET1.STATUS = 'SAIDA' THEN convert(varchar(100), concat('5 - O ALUNO SAIU DO COLÉGIO ÀS ',+SET1.BATIDA))
	END  'OBSERVACOES',

'1' DISPONIVELWEB,
'mestre' RECCREATEDBY,
GETDATE() RECCREATEDON,
'mestre' RECMODIFIEDBY,
GETDATE() RECMODIFIEDON,
'N' RESPONSAVELCIENTE


--SET1.MATRICULA, SET1.DATA_DE_ACESSO

FROM
(SELECT P1.MATRICULA, P1.DATA_DE_ACESSO, P1.IDPERLET, P1.RA,
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
) SET1
) SET4
where
	SET4.RA IS NOT NULL
	and not exists (SELECT * 
                        from SOCORRENCIAALUNO (NOLOCK) as T2
                        where T2.CODCOLIGADA = SET4.CODCOLIGADA
                             and T2.RA = SET4.RA
							 and t2.CODOCORRENCIATIPO  = set4.CODOCORRENCIATIPO
							 and t2.CODOCORRENCIAGRUPO = set4.CODOCORRENCIAGRUPO
							 and convert(varchar(100), t2.observacoes) = convert(varchar(100), set4.observacoes))
order by 2	asc		
			  
UPDATE dbo.GAUTOINC
SET VALAUTOINC = (SELECT MAX(IDOCORALUNO) FROM SOCORRENCIAALUNO WHERE CODCOLIGADA = 1)
WHERE CODCOLIGADA = 1 AND CODSISTEMA = 'S' AND CODAUTOINC = 'IDOCORALUNO'


--select * from socorrenciaaluno where ra in ('15020797', '15020796') and year(dataocorrencia)='2018' and month(dataocorrencia)='07'

--select observacoes, convert(varchar, observacoes,13 ), * from socorrenciaaluno where ra='118002061' and year(dataocorrencia)='2018' and month(dataocorrencia)='07' 
--and
--CONCAT(observacoes, observacoes) = CONCAT(observacoes, observacoes)

--delete from socorrenciaaluno where ra in ('15020797', '15020796') and year(dataocorrencia)='2018' and month(dataocorrencia)='07'


