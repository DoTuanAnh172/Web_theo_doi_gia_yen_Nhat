USE [jpy]
GO
/****** Object:  Table [dbo].[ForexRates]    Script Date: 5/26/2024 6:56:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ForexRates](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[base_currency] [nvarchar](50) NOT NULL,
	[target_currency] [decimal](18, 5) NOT NULL,
	[exchange_rate] [float] NOT NULL,
	[updated_time] [datetime] NOT NULL,
 CONSTRAINT [PK__ForexRat__3213E83F846B7D96] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[InsertDulieuJson]    Script Date: 5/26/2024 6:56:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertDulieuJson]
   
    @json NVARCHAR(MAX)= null
AS
BEGIN
    DECLARE @base_currency NVARCHAR(50);
    DECLARE @target_currency DECIMAL(18, 0);
    DECLARE @exchange_rate FLOAT;
    DECLARE @updated_time DATETIME;

    -- Phân tích JSON và gán giá trị cho các biến
    SELECT 
        @base_currency = JSON_VALUE(@json, '$.base'),
        @target_currency = CAST(JSON_VALUE(@json, '$.result.VND') AS DECIMAL(18, 0)),
        @exchange_rate = CAST(JSON_VALUE(@json, '$.result.VND') AS FLOAT),
        @updated_time = CONVERT(DATETIME, JSON_VALUE(@json, '$.updated'));

    -- Chèn dữ liệu vào bảng ExchangeRates
    INSERT INTO ForexRates(base_currency, target_currency, exchange_rate, updated_time)
    VALUES (@base_currency, @target_currency, @exchange_rate, @updated_time);
END;
GO
