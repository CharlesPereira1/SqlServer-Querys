SELECT A.NSEQITMMOV,
       A.DESCRICAO,
       B.TAREFA,
       A.QUANTIDADE,
       A.HISTORICOCURTO,
       A.PRECOUNITARIO,
       C.VALOR 'PC-PLANEJADO',
       A.VL_TOTAL
FROM   (SELECT DISTINCT B.CODTMV,
                        A.NSEQITMMOV,
                        C.DESCRICAO,
                        A.PRECOUNITARIO,
                        A.QUANTIDADE,
                        D.HISTORICOCURTO,
                        A.IDMOV,
                        A.IDPRD,
                        A.PRECOUNITARIO * A.QUANTIDADE 'VL_TOTAL',
                        B.CODCCUSTO,
                        B.CODCOLIGADA
        FROM   TITMMOV A (NOLOCK)
               INNER JOIN TMOV B
                 ON B.CODCOLIGADA = A.CODCOLIGADA
                    AND B.IDMOV = A.IDMOV
               INNER JOIN TPRODUTO C
                 ON C.IDPRD = A.IDPRD
               INNER JOIN TITMMOVHISTORICO D
                 ON D.CODCOLIGADA = A.CODCOLIGADA
                    AND D.IDMOV = A.IDMOV
                    AND D.NSEQITMMOV = A.NSEQITMMOV
        WHERE  A.IDMOV = :IDMOV5
               AND B.CODCCUSTO = :CODCCUSTO1
               AND A.IDPRD = :IDPRD2
               AND B.CODCOLIGADA = 1
               AND B.CODTMV = '1.2.05') A
       LEFT JOIN (SELECT A.IDMOV,
                         COALESCE((SELECT CAST(C.CODTRF + ' - ' + C.NOME AS VARCHAR(800)) + ', '
                                   FROM   TITMMOV A
                                          INNER JOIN TITMMOVRATCCU B
                                            ON B.CODCOLIGADA = A.CODCOLIGADA
                                               AND B.IDMOV = A.IDMOV
                                               AND B.NSEQITMMOV = A.NSEQITMMOV
                                          LEFT JOIN MTAREFA C
                                            ON C.CODCOLIGADA = B.CODCOLIGADA
                                               AND C.IDPRJ = B.IDPRJ
                                               AND C.IDTRF = B.IDTRF
                                   WHERE  A.IDMOV = :IDMOV5
                                          AND A.IDPRD = :IDPRD2
                                          AND TMOV.CODCCUSTO = :CODCCUSTO1
                                   ORDER  BY 1
                                   FOR XML PATH(''), TYPE), '') 'TAREFA',
                         A.IDPRD                                'IDPRD1',
                         A.IDMOV                                'IDMOV1',
                         TMOV.CODTMV,
                         B.PERCENTUAL,
                         A.CODCOLIGADA                          'CODCOLIGADA1',
                         TMOV.CODCCUSTO                         'CODCCUSTO1'
                  FROM   TITMMOV A
                         INNER JOIN TMOV
                           ON TMOV.CODCOLIGADA = A.CODCOLIGADA
                              AND TMOV.IDMOV = A.IDMOV
                         INNER JOIN TITMMOVRATCCU B
                           ON B.CODCOLIGADA = A.CODCOLIGADA
                              AND B.IDMOV = A.IDMOV
                              AND B.NSEQITMMOV = A.NSEQITMMOV
                         LEFT JOIN MTAREFA C
                           ON C.CODCOLIGADA = B.CODCOLIGADA
                              AND C.IDPRJ = B.IDPRJ
                              AND C.IDTRF = B.IDTRF
                  WHERE  A.IDMOV = :IDMOV5
                         AND A.IDPRD = :IDPRD2
                         AND TMOV.CODCCUSTO = :CODCCUSTO1
                  GROUP  BY A.IDMOV,
                            A.IDPRD,
                            A.IDMOV,
                            TMOV.CODTMV,
                            B.PERCENTUAL,
                            A.CODCOLIGADA,
                            TMOV.CODCCUSTO) B
         ON B.IDMOV1 = A.IDMOV
            AND B.IDPRD1 = A.IDPRD
            AND B.CODCCUSTO1 = A.CODCCUSTO
            AND A.CODCOLIGADA = B.CODCOLIGADA1
       LEFT JOIN (SELECT A.IDPRJ,
                         A.IDISM,
                         A.IDPRD       'IDPRD2',
                         B.DESCISM,
                         B.VALOR,
                         B.CODCOLIGADA 'CODCOLIGADA2',
                         C.CODCCUSTO   'CODCCUSTO2'
                  FROM   MISMPRD A
                         INNER JOIN MISM B
                           ON A.CODCOLIGADA = B.CODCOLIGADA
                              AND A.IDPRJ = B.IDPRJ
                              AND A.IDISM = B.IDISM
                         INNER JOIN MPRJ C
                           ON C.IDPRJ = A.IDPRJ
                              AND A.CODCOLIGADA = C.CODCOLIGADA
                  WHERE  A.IDPRJ = (SELECT A1.IDPRJ
                                    FROM   MPRJ A1
                                           LEFT JOIN GCCUSTO B1
                                             ON B1.CODCOLIGADA = A1.CODCOLIGADA
                                                AND B1.CODCCUSTO = A1.CODCCUSTO
                                    WHERE  B1.CODCCUSTO = :CODCCUSTO1)
                         AND A.IDPRD = :IDPRD2) C
         ON A.IDPRD = C.IDPRD2
            AND A.CODCCUSTO = C.CODCCUSTO2
            AND A.CODCOLIGADA = C.CODCOLIGADA2
