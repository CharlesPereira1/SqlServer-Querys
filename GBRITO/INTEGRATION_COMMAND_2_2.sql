USE [CorporeRM]
GO
/****** Object:  StoredProcedure [dbo].[INTEGRATION_COMMAND_2_2]    Script Date: 28/06/2018 16:45:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

                   ALTER PROCEDURE [dbo].[INTEGRATION_COMMAND_2_2] AS

INSERT INTO dbo.SOCORRENCIAALUNO (CODCOLIGADA, IDOCORALUNO, RA, CODOCORRENCIAGRUPO, CODOCORRENCIATIPO, IDPERLET,DATAOCORRENCIA, OBSERVACOES, DISPONIVELWEB, RECCREATEDBY, RECCREATEDON, RECMODIFIEDBY, RECMODIFIEDON, RESPONSAVELCIENTE)

SELECT  
SET5.CODCOLIGADA,
(SELECT 
		MAX(IDOCORALUNO) 
			FROM SOCORRENCIAALUNO 
			WHERE CODCOLIGADA=1)+
			ROW_NUMBER() OVER(PARTITION BY SET5.IDPERLET ORDER BY SET5.RA ASC) 'IDOCORALUNO',
SET5.RA,
'11' CODOCORRENCIAGRUPO,
'147' CODOCORRENCIATIPO,
SET5.IDPERLET,
GETDATE() 'DATAOCORRENCIA',

--SET5.HORARIO_INICIAL_AULA,
--SET5.HORARIO_FINAL_AULA,

--SET5.ENTRADA_ACESSO,
--SET5.SAIDA_ACESSO,

--DATEADD(MINUTE,-5, SET5.ENTRADA_ACESSO) 'data5',
--DATEADD(MINUTE,-60, SET5.ENTRADA_ACESSO) 'data60',

SET5.OBSERVACOES,
'1' DISPONIVELWEB,
'mestre' RECCREATEDBY,
GETDATE() RECCREATEDON,
'mestre' RECMODIFIEDBY,
GETDATE() RECMODIFIEDON,
'N' RESPONSAVELCIENTE

FROM(
SELECT DISTINCT 
SET4.COLIGADA AS CODCOLIGADA,
NULL AS IDOCORALUNO,
SET4.RA,
'11' CODOCORRENCIAGRUPO,
'147' CODOCORRENCIATIPO,
SET4.IDPERLET,
GETDATE() 'DATAOCORRENCIA',
--SET4.HORARIO_INICIAL_AULA,
--SET4.HORARIO_FINAL_AULA,

--SET4.ENTRADA_ACESSO,
--SET4.SAIDA_ACESSO,

(
CASE
---------------------------------------------------------- ALUNO ENTROU NO COLEGIO ---------------------------------------------------------------------
WHEN DATEADD(MINUTE,-5, SET4.ENTRADA_ACESSO)  < SET4.HORARIO_INICIAL_AULA  THEN '2 - ALUNO ENTROU NO COLEGIO ÀS '+SET4.ENTRADA_ACESSO
--------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------ ALUNO ENTROU ATRSADO NO SEGUNDO HORARIO -----------------------------------------------------
WHEN  SET4.ENTRADA_ACESSO > SET4.HORARIO_INICIAL_AULA AND SET4.ENTRADA_ACESSO < SET4.HORARIO_FINAL_AULA --AND SET4.ENTRADA_ACESSO > '07:20:59' --AND SET4.AULA = 01
THEN  '3 - ALUNO CHEGOU ATRASADO - ENTROU NO SEGUNDO HORARIO ÀS '+SET4.ENTRADA_ACESSO 
----------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------ALUNO TEVE PROBLEMAS NA MARCAÇÃO DA CATRACA ---------------------------------------------------
 --WHEN (SET4.ENTRADA_ACESSO IS NULL AND SET4.SAIDA_ACESSO IS NOT NULL) OR  (SET4.ENTRADA_ACESSO IS NOT NULL AND SET4.SAIDA_ACESSO IS NULL)
 --THEN '6 - ALUNO TEVE PROBLEMAS NA MARCAÇÃO DA CATRACA' 
----------------------------------------------------------------------------------------------------------------------------------------------------------

--ELSE
--'ERROR'
END) AS OBSERVACOES,


SET4.DATA_ACESSOCATRACA,
'1' DISPONIVELWEB,
'mestre' RECCREATEDBY,
GETDATE() RECCREATEDON,
'mestre' RECMODIFIEDBY,
GETDATE() RECMODIFIEDON,
'N' RESPONSAVELCIENTE
FROM
(
SELECT
		case when SET31.ENTRADA_ACESSO > SET31.HORARIO_INICIAL_AULA then SET31.ENTRADA_ACESSO else SET31.HORARIO_INICIAL_AULA end as ENTRADA,
        case when SET31.SAIDA_ACESSO < SET31.HORARIO_FINAL_AULA then SET31.SAIDA_ACESSO else SET31.HORARIO_FINAL_AULA end as SAIDA,
SET31.COLIGADA,
SET31.ID_HORARIO,
SET31.ID_TURMADISCPLICA,
SET31.RA_ALUNO,
SET31.DATA_AULODISCIPLICA,
SET31.DATA_ACESSOCATRACA,
SET31.NUMEROCARTEIR,
SET31.NUMEROCARTEIRINHA ,
SET31.NOME_DISCIPLICA,
SET31.HORARIO_INICIAL_AULA,
SET31.HORARIO_FINAL_AULA,
SET31.IDPERLET,
SET31.IDOCORALUNO,
SET31.ENTRADA_ACESSO,
SET31.SAIDA_ACESSO,
SET31.AULA,
SET31.RA,
SET31.TIPO

FROM
(SELECT 

SET2.CODCOLIGADA AS COLIGADA,
SET2.IDHORARIOTURMA AS ID_HORARIO,
SET2.IDTURMADISC AS ID_TURMADISCPLICA,
SET2.RA AS RA_ALUNO,
SET2.DATA as DATA_AULODISCIPLICA,
SET1.DATA_CONVERTIDA AS DATA_ACESSOCATRACA,
SET1.NUMEROCARTEIR,
SET2.NUMEROCARTEIRINHA  AS NUMEROCARTEIRINHA ,
SET2.NOME_DISCIPLICA,
SET2.HORARIO_INICIAL_AULA,
SET2.HORARIO_FINAL_AULA,
SET2.IDPERLET,
SET3.IDOCORALUNO,
SET2.AULA,
SET2.RA,
SET2.TIPO,
MAX( 
 CASE 
     WHEN SET1.tipo_acesso = '1'   THEN HORAS_CONVERTIDA
	
	 END) AS ENTRADA_ACESSO,

MAX( 
 CASE 
     WHEN SET1.tipo_acesso = '2' THEN HORAS_CONVERTIDA
	
	 END) AS SAIDA_ACESSO
FROM 
(
SELECT  
SMA.NUMCARTEIRA AS NUMEROCARTEIRINHA,
SRT.IDTURMADISC AS CODIGO_DISPLICA,
SDI.NOME AS NOME_DISCIPLICA,
SHH.HORAINICIAL AS HORARIO_INICIAL_AULA,
SHH.HORAFINAL AS HORARIO_FINAL_AULA,
SPP.DATA,
SMA.CODCOLIGADA,
SHO.IDHORARIOTURMA,
SPP.IDTURMADISC,
SMA.RA,
SPL.IDPERLET 'IDPERLET',
SHH.AULA,
STNO.TIPO


 FROM SMATRICPL SMA (NOLOCK) 
 
 INNER JOIN STURMA STU (NOLOCK ) ON       SMA.CODCOLIGADA = STU.CODCOLIGADA
                         AND              SMA.CODFILIAL   = STU.CODFILIAL
						 AND              SMA.CODTURMA    = STU.CODTURMA
				         AND              SMA.IDPERLET    = STU.IDPERLET

INNER JOIN STURMADISC SRT (NOLOCK) ON     STU.CODCOLIGADA = SRT.CODCOLIGADA
						 AND              STU.CODFILIAL   = SRT.CODFILIAL
						 AND			  STU.CODTURMA    = SRT.CODTURMA
						 AND              STU.IDPERLET    = SRT.IDPERLET

INNER JOIN STURNO STNO (NOLOCK) ON STNO.CODCOLIGADA = SRT.CODCOLIGADA
						 AND			  STNO.CODTURNO    = SRT.CODTURNO

INNER JOIN SDISCIPLINA SDI (NOLOCK) ON    SRT.CODCOLIGADA  = SDI.CODCOLIGADA
                         AND              SRT.CODDISC      = SDI.CODDISC
 
INNER JOIN SHABILITACAOFILIAL SHA (NOLOCK) ON SMA.CODCOLIGADA = SHA.CODCOLIGADA
                         AND                SMA.IDHABILITACAOFILIAL = SHA.IDHABILITACAOFILIAL

INNER JOIN SHORARIOTURMA SHO (NOLOCK ) ON SRT.CODCOLIGADA = SHO.CODCOLIGADA 
                             AND          SRT.IDTURMADISC = SHO.IDTURMADISC

INNER JOIN SHORARIO SHH ( NOLOCK ) ON SHO.CODCOLIGADA = SHH.CODCOLIGADA
                              AND     SHO.CODHOR      = SHH.CODHOR

INNER JOIN SPLETIVO SPL (NOLOCK) ON SMA.CODCOLIGADA = SPL.CODCOLIGADA 
                              AND   SMA.CODFILIAL   = SPL.CODFILIAL
							  AND   SMA.IDPERLET    = SPL.IDPERLET

LEFT JOIN SPLANOAULA SPP (NOLOCK) ON SHO.CODCOLIGADA = SPP.CODCOLIGADA
                              AND     SHO.IDHORARIOTURMA = SPP.IDHORARIOTURMA
							  AND     SHO.CODHOR         = SPP.CODHOR
							  AND     SHO.IDTURMADISC    =SPP.IDTURMADISC


							  WHERE 
							  --SPL.CODPERLET >= '2018' 
							  --AND SDI.CODCOLIGADA = '1'
							  --AND SHA.CODFILIAL = '4'
							  --AND SMA.CODSTATUS = '2'
						 	 --SMA.RA = '418002282' and

							-- SMA.RA = '418003277' AND
							 SPL.CODPERLET >= '2018' 
							  AND SDI.CODCOLIGADA = '1'
							  AND SHA.CODFILIAL = '2'
							  AND SMA.CODSTATUS = '2'
							  AND SPP.DATA = CONVERT(DATETIME, FLOOR(CONVERT(FLOAT(24), GETDATE())))

) AS SET2 LEFT JOIN 

(SELECT DISTINCT

E1.ID_PESSOAS,
E1.DATA_CONVERTIDA,
E1.HORAS_CONVERTIDA,
E1.MATRICULA,
E1.NUMEROCARTEIR,
E1.NOME_PESSOA,
E1.equipamento_id,
E1.TIPO_ACESSO,
E1.DESCRICAO,
E1.negado,
E1.DATA_EVA

         FROM ( 
SELECT DISTINCT
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
EVA.DATA AS DATA_EVA


FROM [192.168.1.10].[SecullumAcessoNet].[DBO].PESSOAS  PPC (NOLOCK ) 

LEFT JOIN [192.168.1.10].[SecullumAcessoNet].[DBO].eventos_acessos EVA (NOLOCK) ON  PPC.id = EVA.pessoa_id 

LEFT JOIN SMATRICPL SMA (NOLOCK) ON  SMA.NUMCARTEIRA COLLATE SQL_Latin1_General_CP1_CI_AI = PPC.n_identificador COLLATE SQL_Latin1_General_CP1_CI_AI

--WHERE CONVERT (DATETIME, EVA.DATA) = '2018-05-12'
--WHERE CONVERT (DATETIME, EVA.DATA) BETWEEN  '2018-05-16' AND '2018-05-16'
WHERE DATA=CONVERT(DATETIME, FLOOR(CONVERT(FLOAT(24), GETDATE())))

) E1					  
) SET1 ON SET1.NUMEROCARTEIR = SET2.NUMEROCARTEIRINHA
  LEFT JOIN
(
SELECT 
	A.CODCOLIGADA,
	A.RA 'NUMEROCARTEIRINHA',
	A.IDTURMADISC 'IDTURMADISC',
	B.IDOCORALUNO 'IDOCORALUNO'
FROM SFREQUENCIA A
	INNER JOIN SOCORRENCIAALUNO B ON 
		A.CODCOLIGADA = B.CODCOLIGADA AND 
		A.IDTURMADISC = B.IDTURMADISC AND 
		A.RA = B.RA AND A.DATA = B.DATAOCORRENCIA
WHERE
	B.CODCOLIGADA = 1
GROUP BY 
	A.CODCOLIGADA,
	A.RA,
	A.IDTURMADISC,
	B.IDOCORALUNO
) 
SET3 ON 
	SET3.NUMEROCARTEIRINHA = SET1.NUMEROCARTEIR AND 
	SET2.CODIGO_DISPLICA = SET3.IDTURMADISC AND 
	SET2.CODCOLIGADA = SET3.CODCOLIGADA

GROUP BY 

SET2.CODCOLIGADA,
SET2.RA,
SET1.NUMEROCARTEIR,
SET2.IDHORARIOTURMA,
SET2.IDTURMADISC,
SET2.DATA,
SET1.DATA_CONVERTIDA,
SET2.NOME_DISCIPLICA,
SET2.HORARIO_INICIAL_AULA,
SET2.HORARIO_FINAL_AULA,
SET2.NUMEROCARTEIRINHA,
SET2.IDPERLET,
SET3.IDOCORALUNO,
SET2.AULA,
SET2.RA,
SET2.TIPO

) SET31
GROUP BY
SET31.COLIGADA,
SET31.ID_HORARIO,
SET31.ID_TURMADISCPLICA,
SET31.RA_ALUNO,
SET31.DATA_AULODISCIPLICA,
SET31.DATA_ACESSOCATRACA,
SET31.NUMEROCARTEIR,
SET31.NUMEROCARTEIRINHA ,
SET31.NOME_DISCIPLICA,
SET31.HORARIO_INICIAL_AULA,
SET31.HORARIO_FINAL_AULA,
SET31.IDPERLET,
SET31.IDOCORALUNO,
SET31.ENTRADA_ACESSO,
SET31.SAIDA_ACESSO,
SET31.AULA,
SET31.RA,
SET31.TIPO

) SET4

GROUP BY 
SET4.COLIGADA,
SET4.NUMEROCARTEIRINHA ,
SET4.IDPERLET,
SET4.ID_TURMADISCPLICA,
SET4.ENTRADA_ACESSO,
SET4.SAIDA_ACESSO,
SET4.HORARIO_INICIAL_AULA,
SET4.HORARIO_FINAL_AULA,
SET4.DATA_AULODISCIPLICA,
SET4.NOME_DISCIPLICA,
SET4.IDOCORALUNO,
SET4.DATA_ACESSOCATRACA,
SET4.HORARIO_INICIAL_AULA,
SET4.HORARIO_FINAL_AULA,
SET4.ENTRADA_ACESSO,
SET4.SAIDA_ACESSO,
SET4.ENTRADA, SET4.SAIDA,
SET4.AULA,
SET4.RA
) SET5

  WHERE SET5.OBSERVACOES IS NOT NULL
  --and set5.horario_inicial_aula = '07:00'
  --and set5.entrada_acesso >= '07:05:00'
  and not exists (SELECT * 
                        from SOCORRENCIAALUNO as T2
                        where T2.CODCOLIGADA = SET5.CODCOLIGADA
                              and T2.RA = SET5.RA
                              and convert(varchar,t2.dataocorrencia, 103) = convert(varchar, set5.dataocorrencia, 103)
							  and t2.CODOCORRENCIATIPO  = set5.CODOCORRENCIATIPO
							  and t2.CODOCORRENCIAGRUPO = set5.CODOCORRENCIAGRUPO
							  and convert(varchar,set5.observacoes) = convert(varchar, t2.observacoes)
							  AND T2.RA IN (SELECT RA FROM SMATRICPL WHERE CODFILIAL=2 AND CODCOLIGADA=1))
							  
UPDATE dbo.GAUTOINC
SET VALAUTOINC = (SELECT MAX(IDOCORALUNO) FROM SOCORRENCIAALUNO WHERE CODCOLIGADA = 1)
WHERE CODCOLIGADA = 1 AND CODSISTEMA = 'S' AND CODAUTOINC = 'IDOCORALUNO'

