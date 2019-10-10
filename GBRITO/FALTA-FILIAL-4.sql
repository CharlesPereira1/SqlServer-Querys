USE [CorporeRM]
GO
/****** Object:  StoredProcedure [dbo].[sp_addextendedtsacodfial4]    Script Date: 28/06/2018 16:50:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_addextendedtsacodfial4] AS


INSERT INTO SFREQUENCIA --(CODCOLIGADA, IDHORARIOTURMA, IDTURMADISC, RA, DATA, PRESENCA, JUSTIFICADA, RECCREATEDBY, RECCREATEDON, RECMODIFIEDBY, RECMODIFIEDON, IDJUSTIFICATIVAFALTA)

SELECT
SET5.COLIGADA,
SET5. ID_HORARIO,
SET5.ID_TURMADISCPLICA,
SET5.RA_ALUNO,
SET5.DATA_ACESSOCATRACA,
SET5.PRECENSA_FALTA,
NULL AS JUSTIFICADA,
'mestre' AS RECCREATEDBY, 
SET5.DATA_ACESSOCATRACA AS RECCREATEDON, 
'mestre' AS RECMODIFIEDBY,
SET5.DATA_ACESSOCATRACA AS RECMODIFIEDON,
NULL AS IDJUSTIFICATIVAFALTA
FROM
(SELECT DISTINCT
SET4.COLIGADA,
SET4.ID_HORARIO,
SET4.ID_TURMADISCPLICA,
SET4.RA_ALUNO,
CASE 
WHEN (100.0 * DATEDIFF(MINUTE, SET4.ENTRADA, SET4.SAIDA ) / DATEDIFF(MINUTE, SET4.HORARIO_INICIAL_AULA, SET4.HORARIO_FINAL_AULA) < 70) 
		AND SET4.TIPO='M' AND CONVERT(VARCHAR(11),GETDATE(),114) BETWEEN '08:59' AND '13:30' 
		OR (SET4.ENTRADA_ACESSO IS NULL AND SET4.SAIDA_ACESSO IS NULL AND SET4.TIPO='M' AND CONVERT(VARCHAR(11),GETDATE(),114) BETWEEN '08:59' AND '13:30') 
THEN 'A'
WHEN (100.0 * DATEDIFF(MINUTE, SET4.ENTRADA, SET4.SAIDA ) / DATEDIFF(MINUTE, SET4.HORARIO_INICIAL_AULA, SET4.HORARIO_FINAL_AULA) < 70) 
		AND SET4.TIPO='V' AND CONVERT(VARCHAR(11),GETDATE(),114) BETWEEN '16:00' AND '20:30'
		OR (SET4.ENTRADA_ACESSO IS NULL AND SET4.SAIDA_ACESSO IS NULL AND SET4.TIPO='V' AND CONVERT(VARCHAR(11),GETDATE(),114) BETWEEN '16:00' AND '20:30') 
THEN 'A' 
--ELSE 'NULL' 
END AS 'PRECENSA_FALTA',
--THEN '4 - ALUNO SAIU MAIS CEDO' END,
CONVERT(DATETIME, FLOOR(CONVERT(FLOAT(24), GETDATE()))) 'DATA_ACESSOCATRACA',

SET4.HORARIO_INICIAL_AULA,
SET4.HORARIO_FINAL_AULA,
SET4.ENTRADA_ACESSO,
SET4.SAIDA_ACESSO,

SET4.ENTRADA,
SET4.SAIDA,
SET4.RECCREATEDBY,
SET4.RECCREATEDON,
SET4.RECMODIFIEDBY,
SET4.RECMODIFIEDON,
SET4.IDJUSTIFICATIVAFALTA
FROM
(SELECT 
SET3.COLIGADA,
SET3. ID_HORARIO,
SET3.ID_TURMADISCPLICA,
SET3.RA_ALUNO,
SET3.DATA_ACESSOCATRACA,
SET3.TIPO,

SET3.ENTRADA_ACESSO,
SET3.SAIDA_ACESSO,
SET3.HORARIO_INICIAL_AULA, 
SET3.HORARIO_FINAL_AULA,
		case when SET3.ENTRADA_ACESSO > SET3.HORARIO_INICIAL_AULA then SET3.ENTRADA_ACESSO else SET3.HORARIO_INICIAL_AULA end as ENTRADA,
        case when SET3.SAIDA_ACESSO < SET3.HORARIO_FINAL_AULA then SET3.SAIDA_ACESSO else SET3.HORARIO_FINAL_AULA end as SAIDA,
--NULL AS JUSTIFICADA,
'mestre' AS RECCREATEDBY, 
SET3.DATA_ACESSOCATRACA AS RECCREATEDON, 
'mestre' AS RECMODIFIEDBY,
SET3.DATA_ACESSOCATRACA AS RECMODIFIEDON,
NULL AS IDJUSTIFICATIVAFALTA	

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
FROM --
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
STNO.TIPO 'TIPO'

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
						 	--SMA.RA = '15020432' AND
							-- SMA.RA = '4201700338' and
							 --SRT.CODTURMA = 'EF06A104' AND
							  SPL.CODPERLET >= '2018' 
							  AND SDI.CODCOLIGADA = '1'
							  AND SHA.CODFILIAL = '4'
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


FROM [192.168.4.12].[SecullumAcessoNet].[DBO].PESSOAS  PPC (NOLOCK ) 

LEFT JOIN [192.168.4.12].[SecullumAcessoNet].[DBO].eventos_acessos EVA (NOLOCK) ON  PPC.id = EVA.pessoa_id 

LEFT JOIN SMATRICPL SMA (NOLOCK) ON  SMA.NUMCARTEIRA COLLATE SQL_Latin1_General_CP1_CI_AI = PPC.n_identificador COLLATE SQL_Latin1_General_CP1_CI_AI

--WHERE CONVERT (DATETIME, EVA.DATA) = '2018-05-22'
--WHERE CONVERT (DATETIME, EVA.DATA) BETWEEN  '2018-04-16' AND '2018-05-21'
WHERE DATA=CONVERT(DATETIME, FLOOR(CONVERT(FLOAT(24), GETDATE())))

) E1					  
) SET1 ON SET1.NUMEROCARTEIR = SET2.NUMEROCARTEIRINHA

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
SET2.TIPO
) SET3
) SET4
) SET5
WHERE
	SET5.PRECENSA_FALTA IS NOT NULL
	and not exists (SELECT * 
                        from SFREQUENCIA as T2
                        where T2.CODCOLIGADA = SET5.COLIGADA
                              and T2.IDTURMADISC = SET5.ID_TURMADISCPLICA
							  AND T2.IDHORARIOTURMA = SET5.ID_HORARIO
							  AND T2.DATA = SET5.DATA_ACESSOCATRACA
							  AND T2.RA IN (SELECT RA FROM SMATRICPL WHERE CODFILIAL=4 AND CODCOLIGADA=1))