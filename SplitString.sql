CREATE FUNCTION [dbo].[utab_SplitString] (
	@param NVARCHAR(MAX), 
	@delimiter CHAR(1)
) 
RETURNS @t TABLE (InVal NVARCHAR(MAX), strVal NVARCHAR(MAX), seq INT)
AS
BEGIN
SET @param += @delimiter

;WITH a AS -- recursive CTE to identify positions of first character before a delimiter (f) and the position of the following delimiter (t) within the input string
(
	SELECT
		CAST(1 AS BIGINT) f
		,CHARINDEX(@delimiter, @param) t
		,1 seq
	UNION ALL
	SELECT
		t + 1
		,CHARINDEX(@delimiter, @param, t + 1)
		,seq + 1
	FROM 
		a
	WHERE 
		CHARINDEX(@delimiter, @param, t + 1) > 0
)
INSERT INTO @t   -- insert the substring relative to first and terminating positions identified from above CTE 
SELECT 
	@param
	,SUBSTRING(@param, f, t - f)
	,seq 
FROM 
	a
OPTION (MAXRECURSION 0)

RETURN
END
