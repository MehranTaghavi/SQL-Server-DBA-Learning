SELECT CAST('2026-09-08' AS date) AS CastDate,
       TRY_CAST('not-a-number' AS int) AS SafeCast,
       CONVERT(decimal(10,2), '1234.50') AS ConvertedAmount,
       TRY_CONVERT(date, 'bad-date') AS SafeConvert,
       PARSE('08/09/2026' AS date USING 'en-GB') AS ParsedDate,
       TRY_PARSE('bad-date' AS date USING 'en-GB') AS SafeParse;
