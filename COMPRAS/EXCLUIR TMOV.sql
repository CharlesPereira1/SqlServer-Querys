DELETE FROM dbo.TMOV WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674)


DELETE from dbo.FLAN WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674)
DELETE FROM FLANRATCCU WHERE IDLAN IN (SELECT idlan from dbo.FLAN WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674))
DELETE FROM FRELLANPAI WHERE IDLAN IN (SELECT idlan from dbo.FLAN WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674))
DELETE FROM TPAGTO WHERE IDLAN IN (SELECT idlan from dbo.FLAN WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674))
DELETE FROM FLANCOMPL WHERE IDLAN IN (SELECT idlan from dbo.FLAN WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674))

DELETE FROM dbo.TITMMOV WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674)
DELETE FROM dbo.TITMMOVCOMPL WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674)
DELETE FROM dbo.TITMMOVHISTORICO WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674)
DELETE FROM dbo.TITMMOVRATCCU WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674)

DELETE FROM dbo.TMOVRATCCU WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674)
DELETE FROM dbo.TMOVPAGTO WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674)
DELETE FROM dbo.TMOVLAN WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674)
DELETE FROM dbo.TMOVCOMPL WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674)
DELETE FROM dbo.TMOVFISCAL WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674)
DELETE FROM dbo.TMOVHISTORICO WHERE CODCOLIGADA = 1 AND IDMOV IN (54668, 54674)







