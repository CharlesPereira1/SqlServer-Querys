/*Venho solicitar que os lan�amentos remanescentes nos centros de custos desativados dos Mirante�s (03.01.0232 / 03.01.0233 / 03.01.0234), 
sejam destinados corretamente aos centros de custos atuais (03.01.0235 / 03.01.0236 / 03.01.0237).
H� alguns dias identifiquei que ainda temos lan�amentos a serem migrados no sistema.
Esta migra��o � via banco de dados, n�o sei se via Cristiane ou via Suporte (Chamado).
*/

select CODCCUSTO,* from FLANRATCCU where CODCCUSTO='03.01.0232'
select CODCCUSTO,* from TPAGTO where CODCCUSTO='03.01.0232' --idlan=234330
select CODCCUSTO,* from FLANBAIXAHST where idlan=234330
select CODCCUSTO,* from FLANBAIXARATCCU where idlan=234330
select CODCCUSTO,* from FLANCONTOLD where idlan=234330
select CODCCUSTO,statuslan,idmov,* from flan where CODCCUSTO in('03.01.0232', '03.01.0233', '03.01.0234') IDLAN=234330

select CODCCUSTO,* from tmov where IDMOV in (select idmov from flan where idlan=234330) 

select * from GLINKSREL where CHILDFIELD like '%CODCCUSTO%' and MASTERTABLE like 't%' or MASTERTABLE like 'f%'