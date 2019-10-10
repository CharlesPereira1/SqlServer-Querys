--ALTER PROCEDURE [dbo].[sp_addextendedproperty] AS

--DELETE SFR FROM SFREQUENCIA SFR 

--INNER JOIN SMATRICULA SMA (NOLOCK) ON SFR.CODCOLIGADA = SMA.CODCOLIGADA
--                                  AND SFR.IDTURMADISC = SMA.IDTURMADISC
--								  AND SFR.RA          = SMA.RA

--LEFT JOIN SHORARIOTURMA SHO (NOLOCK) ON SFR.CODCOLIGADA = SHO.CODCOLIGADA
--                                     AND SFR.IDHORARIOTURMA = SHO.IDHORARIOTURMA

--								 WHERE  SFR.DATA=CONVERT(DATETIME, FLOOR(CONVERT(FLOAT(24), GETDATE())))
--								 AND    SMA.CODCOLIGADA = '1'
--								 AND    SHO.CODFILIAL =	 '1'
--								-- AND   SFR.DATA BETWEEN '2018-04-01' AND '2018-04-18'

----DELETE SFREQUENCIA WHERE  DATA=CONVERT(DATETIME, FLOOR(CONVERT(FLOAT(24), GETDATE())))


--INSERT INTO SFREQUENCIA 
SELECT 
SET3.COLIGADA,
SET3. ID_HORARIO,
SET3.ID_TURMADISCPLICA,
SET3.RA_ALUNO,
SET3.DATA_ACESSOCATRACA,

SET3.HORARIO_INICIAL_AULA,
SET3.HORARIO_FINAL_AULA,
--DATEADD(MINUTE,-6, SET3.ENTRADA_ACESSO) 'TOLERANCIA_ENTRADA',
--DATEADD(MINUTE,6, SET3.SAIDA_ACESSO) 'TOLERANCIA_SAIDA',
SET3.ENTRADA_ACESSO,
SET3.SAIDA_ACESSO,

( 
  CASE 
       WHEN SET3.HORARIO_INICIAL_AULA <= SET3.ENTRADA_ACESSO AND SET3.DATA_AULODISCIPLICA = SET3.DATA_ACESSOCATRACA THEN 'A'
	   WHEN SET3.HORARIO_FINAL_AULA  <= SET3.SAIDA_ACESSO AND SET3.ENTRADA_ACESSO IS NOT NULL THEN 'F'
	   ELSE 'A'
	   END) PRECENSA_FALTA,
NULL AS JUSTIFICADA,
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
MAX( 
 CASE 
     WHEN SET1.tipo_acesso = '1'   THEN HORAS_CONVERTIDA
	
	 END) AS ENTRADA_ACESSO,

MAX( 
 CASE 
     WHEN SET1.tipo_acesso = '2' THEN HORAS_CONVERTIDA
	
	 END) AS SAIDA_ACESSO

FROM 
--(SELECT DISTINCT

--E1.ID_PESSOAS,
--E1.DATA_CONVERTIDA,
--E1.HORAS_CONVERTIDA,
--E1.MATRICULA,
--E1.NUMEROCARTEIR,
--E1.NOME_PESSOA,
--E1.equipamento_id,
--E1.TIPO_ACESSO,
--E1.DESCRICAO,
--E1.negado,
--E1.DATA_EVA

--         FROM ( 
--SELECT DISTINCT
--PPC.ID AS ID_PESSOAS,
--EVA.pessoa_id AS ID_EVENTOSACESSOS,
--CONVERT (DATETIME, EVA.DATA, 126)AS DATA_CONVERTIDA,
--DBO.CONVERTESEGUNDOSEMHORAS(EVA.HORA) AS HORAS_CONVERTIDA,
--EVA.DATA AS DATA_DE_ACESSO,
--EVA.hora,
--EVA.equipamento_id,
--EVA.tipo_acesso,
--EVA.descricao,
--EVA.negado,
--PPC.n_identificador AS MATRICULA,
--PPC.NOME AS NOME_PESSOA,
--SMA.NUMCARTEIRA AS NUMEROCARTEIR,
--SMA.CODTURMA,
--EVA.DATA AS DATA_EVA


--FROM [192.168.6.12].[SecullumAcessoNet].[DBO].PESSOAS  PPC (NOLOCK ) 

--LEFT JOIN [192.168.6.12].[SecullumAcessoNet].[DBO].eventos_acessos EVA (NOLOCK) ON  PPC.id = EVA.pessoa_id 

--LEFT JOIN SMATRICPL SMA (NOLOCK) ON  SMA.NUMCARTEIRA COLLATE SQL_Latin1_General_CP1_CI_AI = PPC.n_identificador COLLATE SQL_Latin1_General_CP1_CI_AI

--WHERE --CONVERT (DATETIME, EVA.DATA) BETWEEN '2018-04-01' AND '2018-04-18'
--DATA=CONVERT(DATETIME, FLOOR(CONVERT(FLOAT(24), GETDATE())))

--) E1

--) AS SET1 INNER JOIN 

--(SELECT  
--SMA.NUMCARTEIRA AS NUMEROCARTEIRINHA,
--SRT.IDTURMADISC AS CODIGO_DISPLICA,
--SDI.NOME AS NOME_DISCIPLICA,
--SHH.HORAINICIAL AS HORARIO_INICIAL_AULA,
--SHH.HORAFINAL AS HORARIO_FINAL_AULA,
--SPP.DATA,
--SMA.CODCOLIGADA,
--SHO.IDHORARIOTURMA,
--SPP.IDTURMADISC,
--SMA.RA

-- FROM SMATRICPL SMA (NOLOCK) 
 
-- INNER JOIN STURMA STU (NOLOCK ) ON       SMA.CODCOLIGADA = STU.CODCOLIGADA
--                         AND              SMA.CODFILIAL   = STU.CODFILIAL
--						 AND              SMA.CODTURMA    = STU.CODTURMA
--				         AND              SMA.IDPERLET    = STU.IDPERLET

--INNER JOIN STURMADISC SRT (NOLOCK) ON     STU.CODCOLIGADA = SRT.CODCOLIGADA
--						 AND              STU.CODFILIAL   = SRT.CODFILIAL
--						 AND			  STU.CODTURMA    = SRT.CODTURMA
--						 AND              STU.IDPERLET    = SRT.IDPERLET

--INNER JOIN SDISCIPLINA SDI (NOLOCK) ON    SRT.CODCOLIGADA  = SDI.CODCOLIGADA
--                         AND              SRT.CODDISC      = SDI.CODDISC
 
--INNER JOIN SHABILITACAOFILIAL SHA (NOLOCK) ON SMA.CODCOLIGADA = SHA.CODCOLIGADA
--                         AND                SMA.IDHABILITACAOFILIAL = SHA.IDHABILITACAOFILIAL

--INNER JOIN SHORARIOTURMA SHO (NOLOCK ) ON SRT.CODCOLIGADA = SHO.CODCOLIGADA 
--                             AND          SRT.IDTURMADISC = SHO.IDTURMADISC

--INNER JOIN SHORARIO SHH ( NOLOCK ) ON SHO.CODCOLIGADA = SHH.CODCOLIGADA
--                              AND     SHO.CODHOR      = SHH.CODHOR

--INNER JOIN SPLETIVO SPL (NOLOCK) ON SMA.CODCOLIGADA = SPL.CODCOLIGADA 
--                              AND   SMA.CODFILIAL   = SPL.CODFILIAL
--							  AND   SMA.IDPERLET    = SPL.IDPERLET

--LEFT JOIN SPLANOAULA SPP (NOLOCK) ON SHO.CODCOLIGADA = SPP.CODCOLIGADA
--                              AND     SHO.IDHORARIOTURMA = SPP.IDHORARIOTURMA
--							  AND     SHO.CODHOR         = SPP.CODHOR
--							  AND     SHO.IDTURMADISC    =SPP.IDTURMADISC


--							  WHERE 
--							  SPL.CODPERLET >= '2018' 
--							  AND SDI.CODCOLIGADA = '1'
--							  AND SHA.CODFILIAL = '1'

							  
--) SET2 ON SET1.NUMEROCARTEIR = SET2.NUMEROCARTEIRINHA

(SELECT  
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
SHH.AULA


 FROM SMATRICPL SMA (NOLOCK) 
 
 INNER JOIN STURMA STU (NOLOCK ) ON       SMA.CODCOLIGADA = STU.CODCOLIGADA
                         AND              SMA.CODFILIAL   = STU.CODFILIAL
						 AND              SMA.CODTURMA    = STU.CODTURMA
				         AND              SMA.IDPERLET    = STU.IDPERLET

INNER JOIN STURMADISC SRT (NOLOCK) ON     STU.CODCOLIGADA = SRT.CODCOLIGADA
						 AND              STU.CODFILIAL   = SRT.CODFILIAL
						 AND			  STU.CODTURMA    = SRT.CODTURMA
						 AND              STU.IDPERLET    = SRT.IDPERLET

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
							  SPL.CODPERLET >= '2018' 
							  AND SDI.CODCOLIGADA = '1'
							  AND SHA.CODFILIAL = '1'
							  AND SPP.DATA = '2018-04-09'
							  AND SRT.CODTURMA = 'EM03C101'
							  AND SRT.IDTURMADISC = '7504'
							  AND SMA.CODSTATUS=2
							  --AND SMA.RA='15509010'
							--AND SPP.DATA BETWEEN '2018-04-09' AND '2018-04-09'

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


FROM [192.168.6.12].[SecullumAcessoNet].[DBO].PESSOAS  PPC (NOLOCK ) 

LEFT JOIN [192.168.6.12].[SecullumAcessoNet].[DBO].eventos_acessos EVA (NOLOCK) ON  PPC.id = EVA.pessoa_id 

LEFT JOIN SMATRICPL SMA (NOLOCK) ON  SMA.NUMCARTEIRA COLLATE SQL_Latin1_General_CP1_CI_AI = PPC.n_identificador COLLATE SQL_Latin1_General_CP1_CI_AI

WHERE CONVERT (DATETIME, EVA.DATA) = '2018-04-09'
--WHERE CONVERT (DATETIME, EVA.DATA) BETWEEN '2018-04-09' AND '2018-04-09'
--DATA=CONVERT(DATETIME, FLOOR(CONVERT(FLOAT(24), GETDATE())))

) E1					  
) SET1 ON SET1.NUMEROCARTEIR = SET2.NUMEROCARTEIRINHA

--WHERE 
--     SET1.DATA_CONVERTIDA = SET2.DATA	



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
SET2.NUMEROCARTEIRINHA) SET3

ORDER BY SET3.ENTRADA_ACESSO, SET3.SAIDA_ACESSO

GO


