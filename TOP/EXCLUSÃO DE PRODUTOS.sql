--DELETE FROM TPRODUTO WHERE CODIGOPRD LIKE '6.01.%'
--DELETE FROM TPRDCOMPL WHERE IDPRD IN (SELECT IDPRD FROM TPRODUTO WHERE CODIGOPRD LIKE '6.01.%')
--DELETE FROM TPRDFIL WHERE IDPRD IN (SELECT IDPRD FROM TPRODUTO WHERE CODIGOPRD LIKE '6.01.%')
--DELETE FROM TPRDHISTORICO WHERE IDPRD IN (SELECT IDPRD FROM TPRODUTO WHERE CODIGOPRD LIKE '6.01.%')
--DELETE FROM TPRDUND WHERE IDPRD IN (SELECT IDPRD FROM TPRODUTO WHERE CODIGOPRD LIKE '6.01.%')
--DELETE FROM TPRODUTODEF WHERE IDPRD IN (SELECT IDPRD FROM TPRODUTO WHERE CODIGOPRD LIKE '6.01.%')
--DELETE FROM MISMPRD WHERE IDPRD IN (SELECT IDPRD FROM TPRODUTO WHERE CODIGOPRD LIKE '6.01.%')
--DELETE FROM MITEMPEDIDOMATERIAL WHERE IDPRD IN (SELECT IDPRD FROM TPRODUTO WHERE CODIGOPRD LIKE '6.01.%')
