select DISTINCT SMA.RA, SRT.CODFILIAL,SMA.NUMCARTEIRA, STNO.TIPO , sma.idperlet, sma.codstatus
from SMATRICPL SMA (NOLOCK) 
 
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

 where 
SMA.CODSTATUS=2 
and sma.idperlet=26
and sma.numcarteira is null
 sma.ra in (
 SELECT a.ra FROM SALUNO A
 INNER JOIN PPESSOA B ON A.CODPESSOA = B.CODIGO
 WHERE
 B.NOME in (
-- 'ANA BEATRIZ SALUM DA CUNHA',
--'ANA CLARA ARA�JO VENANCIO',
--'ANA CLARA GOMES FERNANDES',
--'ANA CLARA RUAS MACHADO PINTO',
--'ANA CLAUDIA CARROCINI FERRO',
--'ANA GABRIELA BORGES JUNQUEIRA',
--'ANA GABRIELA VICTAL FERREIRA',
--'ANA J�LIA DE CASTRO SUAKI',
--'ANA JULIA GUIMARAES RODRIGUES DA CUNHA',
--'ANA JULIA MATIAS COSTA',
--'ANA J�LIA TOMAZ OLIVEIRA',
--'ANA LAURA ASSIS SANTANA',
--'ANT�NIO BROISLER FIGUEIREDO',
'CAUA ARAUJO FERREIRA ' ))

--14956991


--select * from ppessoa where nome like '%andrade%'