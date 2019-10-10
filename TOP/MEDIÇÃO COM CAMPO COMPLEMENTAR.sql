SELECT J.MEDICAODATA, J.RESPONSAVEL, J.OBSERVACAO,
	   A.CNTMATERIAL,
       ZZ.CODPRJ,
       ZZ.DESCRICAO,
       A.NUMCNT,
       A.DATACONTRATO,
       A.DATAINICIO,
       COALESCE((SELECT MAX(DATA) FROM MCNTADITIVO 
       WHERE CODCOLIGADA = A.CODCOLIGADA
       AND IDPRJ = A.IDPRJ
       AND IDCNT = A.IDCNT
       AND (STATUS = 0 OR STATUS is NULL)), A.DATAFIM) DATAFIM,
       B.NOMEFANTASIA,
       COALESCE(E.VALORCONTRATADO, 0) 'VALORCONTRATADO',
       COALESCE(F.VALORMEDIDO, 0) 'VALORMEDIDOACUMULADO',
       COALESCE(D.VALORRETDESC, 0) 'VALORRETDESC',
       COALESCE(G.VALORMEDIDOPDO, 0) 'VALORMEDIDOPDO', 
       COALESCE(H.VALORRETDESCPDO, 0) VALORRETDESCPDO,
       COALESCE(E.VALORCONTRATADO, 0) - COALESCE(F.VALORMEDIDO, 0) 'ALDOCONTRATO',
       COALESCE(G.VALORMEDIDOPDO, 0) - COALESCE(H.VALORRETDESCPDO, 0) 'LIQUIDOMEDIDO',
       ( COALESCE(E.VALORCONTRATADO, 0) - COALESCE(F.VALORMEDIDO, 0) ) / COALESCE(E.VALORCONTRATADO, 1) 'SALDOPERC',
       I.PERIODOMED,
       I.DATAFIM FIMPERIODO,
       I.DATAINICIO INICIOPERIODO
FROM   MCNT A (NOLOCK)
       INNER JOIN MPRJ ZZ (NOLOCK)
               ON A.CODCOLIGADA = ZZ.CODCOLIGADA
                  AND A.IDPRJ = ZZ.IDPRJ
       INNER JOIN FCFO B (NOLOCK)
               ON A.CODCOLCFO = B.CODCOLIGADA
                  AND A.CODCFO = B.CODCFO
       LEFT JOIN (SELECT CODCOLIGADA,
                         IDPRJ,
                         IDCNT,
                         SUM(COALESCE(VALOR, 0)) AS VALORRETDESC
                  FROM   MPDODETRET A (NOLOCK)
                  WHERE  A.CODCOLIGADA = 1
                         AND A.IDPRJ = 248
                         AND A.IDCNT = 28
                  GROUP  BY CODCOLIGADA,
                            IDPRJ,
                            IDCNT) D
              ON A.CODCOLIGADA = D.CODCOLIGADA
                 AND A.IDPRJ = D.IDPRJ
                 AND A.IDCNT = D.IDCNT
       LEFT JOIN (SELECT CODCOLIGADA,
                         IDPRJ,
                         IDCNT,
                         SUM(COALESCE(QTDECONTRATADA, 0) * COALESCE(VALORUNIT, 0)) AS VALORCONTRATADO
                  FROM   MOBJCNT A (NOLOCK)
                  WHERE  A.CODCOLIGADA = 1
                         AND A.IDPRJ = 248
                         AND A.IDCNT = 28
                  GROUP  BY CODCOLIGADA,
                            IDPRJ,
                            IDCNT) E
              ON A.CODCOLIGADA = E.CODCOLIGADA
                 AND A.IDPRJ = E.IDPRJ
                 AND A.IDCNT = E.IDCNT
       LEFT JOIN (SELECT A.CODCOLIGADA,
                         A.IDPRJ,
                         A.IDCNT,
                         SUM(COALESCE(A.QUANTIDADEMEDIDA, 0) * COALESCE(B.VALORUNIT, 0)) AS VALORMEDIDO
                  FROM   MOBJCNTMED A (NOLOCK)
                         INNER JOIN MOBJCNT B (NOLOCK)
                                 ON A.CODCOLIGADA = B.CODCOLIGADA
                                    AND A.IDPRJ = B.IDPRJ
                                    AND A.IDCNT = B.IDCNT
                                    AND A.IDOBJCNT = B.IDOBJCNT
                  WHERE  A.CODCOLIGADA = 1
                         AND A.IDPRJ = 248
                         AND A.IDCNT = 28
                         AND ( PERIODOMED <= 0002
                                OR PERIODOMED LIKE ( 002 ) )
                  GROUP  BY A.CODCOLIGADA,
                            A.IDPRJ,
                            A.IDCNT) F
              ON F.CODCOLIGADA = A.CODCOLIGADA
                 AND F.IDPRJ = A.IDPRJ
                 AND F.IDCNT = A.IDCNT
       LEFT JOIN (SELECT A.CODCOLIGADA,
                         A.IDPRJ,
                         A.IDCNT,
                         SUM(COALESCE(A.QUANTIDADEMEDIDA, 0) * COALESCE(B.VALORUNIT, 0)) AS VALORMEDIDOPDO
                  FROM   MOBJCNTMED A (NOLOCK)
                         INNER JOIN MOBJCNT B
                                 ON A.CODCOLIGADA = B.CODCOLIGADA
                                    AND A.IDPRJ = B.IDPRJ
                                    AND A.IDCNT = B.IDCNT
                                    AND A.IDOBJCNT = B.IDOBJCNT
                  WHERE  A.CODCOLIGADA = 1
                         AND A.IDPRJ = 248
                         AND A.IDCNT = 28
                         AND PERIODOMED = 0002
                  GROUP  BY A.CODCOLIGADA,
                            A.IDPRJ,
                            A.IDCNT) G
              ON G.CODCOLIGADA = A.CODCOLIGADA
                 AND G.IDPRJ = A.IDPRJ
                 AND G.IDCNT = A.IDCNT
       LEFT JOIN (SELECT A.CODCOLIGADA,
                         A.IDPRJ,
                         A.IDCNT,
                         SUM(COALESCE(VALOR, 0)) AS VALORRETDESCPDO
                  FROM   MPDODETRET A (NOLOCK)
                  WHERE  A.CODCOLIGADA = 1
                         AND A.IDPRJ = 248
                         AND A.IDCNT = 28
                         AND PERIODOMED LIKE 0002
                  GROUP  BY A.CODCOLIGADA,
                            A.IDPRJ,
                            A.IDCNT) H
              ON H.CODCOLIGADA = A.CODCOLIGADA
                 AND H.IDPRJ = A.IDPRJ
                 AND H.IDCNT = A.IDCNT
       LEFT JOIN MPDO I (NOLOCK)
              ON I.CODCOLIGADA = A.CODCOLIGADA
                 AND I.IDPRJ = A.IDPRJ
                 AND I.IDCNT = A.IDCNT
                 AND I.PERIODOMED = 0002

	LEFT JOIN (SELECT A.CODCOLIGADA,
                         A.IDPRJ,
                         A.IDCNT,
						 A.MEDICAODATA, A.RESPONSAVEL, A.OBSERVACAO
                         --SUM(COALESCE(A.QUANTIDADEMEDIDA, 0) * COALESCE(B.VALORUNIT, 0)) AS VALORMEDIDOPDO
                  FROM   MPDOCOMPL A (NOLOCK)
                         INNER JOIN MCNT B
                                 ON A.CODCOLIGADA = B.CODCOLIGADA
                                    AND A.IDPRJ = B.IDPRJ
                                    AND A.IDCNT = B.IDCNT
                                    --AND A.IDOBJCNT = B.IDOBJCNT
                  WHERE  A.CODCOLIGADA = 1
                         AND A.IDPRJ = 248
                         AND A.IDCNT = 28
                         AND PERIODOMED = 0002
                  --GROUP  BY A.CODCOLIGADA,
                  --          A.IDPRJ, A.MEDICAODATA, A.RESPONSAVEL, A.MEDICAO,
                  --          A.IDCNT
				  ) J
              ON I.CODCOLIGADA = A.CODCOLIGADA
				 AND I.IDPRJ = A.IDPRJ
                 AND I.IDCNT = A.IDCNT	
WHERE  A.CODCOLIGADA = 1
       AND A.IDPRJ = 248
       AND A.IDCNT = 28
