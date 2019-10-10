CREATE FUNCTION [dbo].[NExtenso_Extenso](@Num INTEGER)
	RETURNS VARCHAR(50)
AS
BEGIN 
	-- Por Ycaro Afonso 03/12/2011
	-- V 0.1
	RETURN CASE @Num 
		WHEN 1000 THEN 'Mil' WHEN 1000000 THEN 'Milhões' WHEN 1000000000 THEN 'Bilhões'
		WHEN 100 THEN 'Cento' WHEN 200 THEN 'Duzentos' WHEN 300 THEN 'Trezentos' WHEN 400 THEN 'Quatrocentos' WHEN 500 THEN 'Quinhentos' WHEN 600 THEN 'Seiscentos' WHEN 700 THEN 'Setecentos' WHEN 800 THEN 'Oitocentos' WHEN 900 THEN 'Novecentos'
		WHEN 10 THEN 'Dez' WHEN 11 THEN 'Onze' WHEN 12 THEN 'Doze' WHEN 13 THEN 'Treze' WHEN 14 THEN 'Quartorze' WHEN 15 THEN 'Quinze' WHEN 16 THEN 'Dezesseis' WHEN 17 THEN 'Dezesete' WHEN 18 THEN 'Dezoito' WHEN 19 THEN 'Dezenove'
		WHEN 20 THEN 'Vinte' WHEN 30 THEN 'Trinta' WHEN 40 THEN 'Quarenta' WHEN 50 THEN 'Cinquenta' WHEN 60 THEN 'Sessenta' WHEN 70 THEN 'Setenta' WHEN 80 THEN 'Oitenta' WHEN 90 THEN 'Noventa' 
		WHEN 1 THEN 'Um' WHEN 2 THEN 'Dois' WHEN 3 THEN 'Tres' WHEN 4 THEN 'Quatro' WHEN 5 THEN 'Cinco' WHEN 6 THEN 'Seis' WHEN 7 THEN 'Sete' WHEN 8 THEN 'Oito' WHEN 9 THEN 'Nove' 
		ELSE NULL END
END
GO
 
CREATE FUNCTION [dbo].[NExtenso_Fator](@Num INTEGER)
	RETURNS INTEGER
AS
BEGIN 
	-- Por Ycaro Afonso 03/12/2011
	-- V 0.1
	IF @Num < 10 RETURN 1
	ELSE IF @Num < 100 RETURN 10
	ELSE IF @Num < 1000 RETURN 100
	ELSE IF @Num < 1000000 RETURN 1000
	ELSE IF @Num < 1000000000 RETURN 1000000
	ELSE IF @Num < 1000000000000 RETURN 1000000000
	RETURN NULL
END
GO
 
CREATE FUNCTION [dbo].[NExtenso_Convert](@Num DECIMAL(18, 6), @Fat DECIMAL(18, 6))
	RETURNS VARCHAR(1000)
AS 
BEGIN 
	-- Por Ycaro Afonso 03/12/2011
	-- V 0.1
	DECLARE @Ret VARCHAR(1000), @_Num DECIMAL(18, 6)
	SET @Ret = ''
	SET @_Num = 0
 
	IF @Fat > 0 BEGIN 
		IF @Num = 1000000000 BEGIN 
			SET @Ret = @Ret + ' Um Bilhão'
		END ELSE IF @Num = 1000000 BEGIN 
			SET @Ret = @Ret + ' Um Milhão'
		END ELSE IF @Num = 1000 BEGIN 
			SET @Ret = @Ret + ' Um Mil'
		END ELSE IF @Num = 100 BEGIN 
			SET @Ret = @Ret + 'Cem'
		END ELSE IF @Num > 10 AND @Num < 20 BEGIN
			SET @Ret = @Ret + ISNULL(dbo.NExtenso_Extenso(@Num) + ' e ', '')
		END ELSE BEGIN 
			IF @Fat >= 1000 BEGIN 
				SET @_Num = CAST((@Num - (@Num % @Fat)) * (CAST(1 AS DECIMAL(18, 6)) / @Fat) AS INTEGER)
 
				IF @_Num = 1 BEGIN 
					SET @Ret = @Ret + ISNULL(dbo.NExtenso_Convert(@Fat, @Fat * .1), '')
				END ELSE BEGIN 
					SET @Ret = @Ret + ISNULL(dbo.NExtenso_Convert(@_Num, dbo.NExtenso_Fator(@_Num)), '') + ' ' + ISNULL(dbo.NExtenso_Extenso(@Fat), '')
				END 
 
				SET @_Num = @Num - (@_Num * @Fat)
 
				SET @Fat = dbo.NExtenso_Fator(@_Num)
 
				SET @Ret = @Ret + CASE WHEN (@Fat > 100 OR @Fat < 100) AND CAST((@_Num - (@_Num % @Fat)) * (CAST(1 AS DECIMAL(18, 6)) / @Fat) AS INTEGER) < 100 THEN ' e ' ELSE ', ' END + ISNULL(dbo.NExtenso_Convert(@_Num, @Fat), '')
			END ELSE BEGIN 
				SET @_Num = @Num - (@Num % @Fat)
				SET @Ret = @Ret + ISNULL(dbo.NExtenso_Extenso(@_Num) + ' e ', '') + dbo.NExtenso_Convert(@Num - @_Num, @Fat * .1)
			END 
		END
	END 
	RETURN REPLACE(REPLACE(@Ret + '.', ' e .', ''), '.', '')
END
GO 
 
CREATE FUNCTION [dbo].[NExtenso](@Num DECIMAL(15, 2))
	RETURNS VARCHAR(1000)
AS 
BEGIN 
	-- Por Ycaro Afonso 03/12/2011
	-- V 0.4
	DECLARE @Ret VARCHAR(500)
	IF @Num > 0 BEGIN 
		
		SET @Ret = ''
		SET @Ret = dbo.NExtenso_Convert(@Num, dbo.NExtenso_Fator(@Num)) + 
			CASE FLOOR(@Num) WHEN 0 THEN '' WHEN 1 THEN ' Real' ELSE ' Reais' END + 
			CASE FLOOR(@Num) WHEN 0 THEN '' ELSE '' END
	 
		SET @Num = @Num - FLOOR(@Num) 
		IF @Num > 0 BEGIN 
			--WHILE @Num - FLOOR(@Num) > 0 BEGIN
			--	SET @Num = @Num / .1
			--END 
			
			SET @Num = REPLACE(CAST(@Num AS VARCHAR(20)), '0.', '')
			
			SET @Ret = @Ret + dbo.NExtenso_Convert(@Num, dbo.NExtenso_Fator(@Num)) + CASE @Num WHEN 1 THEN ' Centavo' ELSE ' Centavos' END
		END
	END ELSE BEGIN
		SET @Ret = 'Zero Reais'
	END
	RETURN @Ret
END 
GO
 
-- Exemplo 
SELECT '#'+REPLACE(CAST(FXCX.VALOR AS decimal(10,2)),'-','')+'#' AS 'VALOR', 
UPPER(dbo.NExtenso(convert( decimal(10,2), REPLACE(valor,'-','')))) AS 'VALOR_EXTENSO',
CASE
	WHEN MONTH(DATA) = 01 THEN 'JANEIRO'
	WHEN MONTH(DATA) = 02 THEN 'FEVEREIRO'
	WHEN MONTH(DATA) = 03 THEN 'MARÇO'
	WHEN MONTH(DATA) = 04 THEN 'ABRIL'
	WHEN MONTH(DATA) = 05 THEN 'MAIO'
	WHEN MONTH(DATA) = 06 THEN 'JUNHO'
	WHEN MONTH(DATA) = 07 THEN 'JULHO'
	WHEN MONTH(DATA) = 08 THEN 'AGOSTO'
	WHEN MONTH(DATA) = 09 THEN 'SETEMBRO'
	WHEN MONTH(DATA) = 10 THEN 'OUTUBRO'
	WHEN MONTH(DATA) = 11 THEN 'NOVEMBRO'
	WHEN MONTH(DATA) = 12 THEN 'DEZEMBRO'
END 'MES'
FROM FXCX
  WHERE IDXCX= 123080  --122895
  AND CODCOLIGADA=1

  