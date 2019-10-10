SELECT SPLETIVO.CODPERLET,
       STURMADISC.CODTURMA,
       STURMADISC.CODDISC,
       SMATRICULA.CODCOLIGADA,
       SMATRICULA.IDTURMADISC,
       SMATRICULA.RA,
       PPESSOA.NOME
FROM   SMATRICULA (NOLOCK)
       JOIN STURMADISC (NOLOCK)
         ON ( SMATRICULA.CODCOLIGADA = STURMADISC.CODCOLIGADA
              AND SMATRICULA.IDTURMADISC = STURMADISC.IDTURMADISC )
       JOIN SPLETIVO (NOLOCK)
         ON ( SPLETIVO.CODCOLIGADA = STURMADISC.CODCOLIGADA
              AND SPLETIVO.IDPERLET = STURMADISC.IDPERLET )
       JOIN SALUNO (NOLOCK)
         ON ( SMATRICULA.CODCOLIGADA = SALUNO.CODCOLIGADA
              AND SMATRICULA.RA = SALUNO.RA )
       JOIN PPESSOA (NOLOCK)
         ON ( SALUNO.CODPESSOA = PPESSOA.CODIGO )
       FULL OUTER JOIN SDISCIPLINA (NOLOCK)
         ON SDISCIPLINA.CODDISC = STURMADISC.CODDISC
WHERE  SMATRICULA.CODCOLIGADA = 1
       AND SDISCIPLINA.IDGRUPOCOMPLEMENTO NOT IN ( '4' )
       AND SPLETIVO.CODPERLET = '1-2019'
       AND SMATRICULA.RA = '18-1-13191'
       AND SMATRICULA.CODSTATUS IN (SELECT CODSTATUS
                                    FROM   SSTATUS
                                    WHERE  CODCOLIGADA = SMATRICULA.CODCOLIGADA
                                           AND DISCIPLINA = 'S'
                                           AND DIBLOQNOTAFALTA = 'N'
                                           AND PLDIARIO = 'S') 
