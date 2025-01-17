-- Default password: 1

USE [Amusement_Park]
GO
/****** Object:  Table [dbo].[Tbl_AmusementPark]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_AmusementPark](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) COLLATE Arabic_CI_AI NOT NULL,
	[Address] [nvarchar](max) COLLATE Arabic_CI_AI NOT NULL,
	[Owner] [nvarchar](50) COLLATE Arabic_CI_AI NOT NULL,
	[Mobile] [char](11) COLLATE Arabic_CI_AI NULL,
	[Phone] [varchar](11) COLLATE Arabic_CI_AI NULL,
	[Price] [int] NOT NULL,
 CONSTRAINT [PK_Tbl_BaseData] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tbl_Customer]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_Customer](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](60) COLLATE Arabic_CI_AI NOT NULL,
	[Birth] [date] NULL,
	[Mobile] [varchar](11) COLLATE Arabic_CI_AI NULL,
	[InGame] [bit] NOT NULL,
	[UnPaid] [int] NOT NULL,
 CONSTRAINT [PK_Tbl_Customer] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tbl_Game]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_Game](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[Start_Time] [datetime] NOT NULL,
	[End_Time] [datetime] NULL,
	[Price] [int] NULL,
 CONSTRAINT [PK_Tbl_Game] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tbl_User]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_User](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](40) COLLATE Arabic_CS_AI NOT NULL,
	[Password] [nvarchar](100) COLLATE Arabic_CS_AI NOT NULL,
 CONSTRAINT [PK_Tbl_User] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tbl_Version]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_Version](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SqlVersion] [int] NOT NULL,
	[Executed] [bit] NOT NULL,
	[AppVersion] [int] NOT NULL,
 CONSTRAINT [PK_Tbl_Version] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Tbl_Customer] ADD  CONSTRAINT [DF_Tbl_Customer_InGame]  DEFAULT ((0)) FOR [InGame]
GO
ALTER TABLE [dbo].[Tbl_Customer] ADD  CONSTRAINT [DF_Tbl_Customer_UnPaid]  DEFAULT ((0)) FOR [UnPaid]
GO
ALTER TABLE [dbo].[Tbl_Game]  WITH CHECK ADD  CONSTRAINT [FK_Tbl_Game_Tbl_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Tbl_Customer] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Tbl_Game] CHECK CONSTRAINT [FK_Tbl_Game_Tbl_Customer]
GO
/****** Object:  StoredProcedure [dbo].[SP_CHECK_EXISTS_Customer]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CHECK_EXISTS_Customer]
	@FullName nvarchar(60),
	@Mobile varchar(11) = NULL,
	@Birth date = NULL
AS
BEGIN
	SELECT COUNT(*) FROM Tbl_Customer
	WHERE (@FullName = FullName) AND (@Mobile = Mobile OR @Mobile IS NULL) AND
	(@Birth = Birth OR @Birth IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_Customer]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_DELETE_Customer]
	@Id int = NULL,
	@FullName nvarchar(60),
	@Mobile varchar(11)
AS
BEGIN
	DELETE FROM Tbl_Customer WHERE (@Id = ID OR ID IS NULL)
	AND (FullName = @FullName OR @FullName IS NULL)
	AND (Mobile = @Mobile OR @Mobile IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DELETE_Game]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_DELETE_Game]
	@Id int,
	@CustomerId int
AS
BEGIN
	DELETE FROM Tbl_Game
	WHERE (ID = @Id OR @Id IS NULL) AND (CustomerID = @CustomerId OR @CustomerId IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Game_Select_All]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
CREATE PROCEDURE [dbo].[SP_Game_Select_All]
	@RecordCount INT = 20,
	@Page INT = 1,
	@PageCount INT output
AS
BEGIN
	DECLARE @SkipItem BIGINT;

	exec @PageCount = SP_TotalPage_Game default;

	SET @SkipItem = (@Page - 1) * @RecordCount;

	Select ROW_NUMBER() OVER (Order By [ID]), FullName, InGame, Birth, Mobile
	FROM Tbl_Customer
	Order By [ID] OFFSET @SkipItem
	ROWS FETCH NEXT @RecordCount
	ROW ONLY
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_Amusement]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INSERT_Amusement]
	@Name nvarchar(50),
	@Address nvarchar(MAX),
	@Owner nvarchar(50),
	@Mobile char(11),
	@Phone varchar(11),
	@Price int
AS
BEGIN
	INSERT INTO Tbl_AmusementPark([Name], Address, Owner, Mobile, Phone, Price)
	VALUES (@Name, @Address, @Owner, @Mobile, @Phone, @Price);
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_Customer]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INSERT_Customer]
	@FullName nvarchar(60),
	@Birth date = null,
	@Mobile varchar(11) = null,
	@InGame bit = 0,
	@Id INT = 0 output
AS
BEGIN
	INSERT INTO Tbl_Customer (FullName, Birth, Mobile, InGame) VALUES (@FullName, @Birth, @Mobile, @InGame)
	SET @Id = SCOPE_IDENTITY();
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_Game]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_INSERT_Game]
	@CustomerID int,
	@StartTime datetime
AS
BEGIN
	INSERT INTO Tbl_Game (CustomerID, Start_Time)
	VALUES (@CustomerID, @StartTime)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_Amusement]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SELECT_Amusement]
	
AS
BEGIN
    SELECT * FROM Tbl_AmusementPark
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_COUNT_User]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SELECT_COUNT_User]
	@Username nvarchar(40),
	@Password nvarchar(100)
AS
BEGIN
	SELECT COUNT(*) FROM Tbl_User WHERE Username=@Username AND Password=@Password
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_Customer]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SELECT_Customer]
	@RecordCount INT = 20,
	@Page INT = 1,
	@TotalPage INT = 0 output
AS
BEGIN
	DECLARE @SkipItem INT;

	exec @TotalPage = SP_TotalPage_Customer @RecordCount;

	SET @SkipItem = (@Page - 1) * @RecordCount;

	Select FullName, InGame, Birth, Mobile
	FROM Tbl_Customer
	Order By [ID] OFFSET @SkipItem
	ROWS FETCH NEXT @RecordCount
	ROW ONLY
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_JOIN_Customer_Game]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SELECT_JOIN_Customer_Game]
	@FullName nvarchar(60) = NULL,
	@InGame bit = NULL,
	--------------------------------------------------
	@RecordCount INT = 20,
	@Page INT = 1,
	@TotalPage INT = 0 output
AS
BEGIN
	IF @Page = 0
	BEGIN
		return;
	END

	DECLARE @SkipItem INT;

	--IF @FullName IS NULL OR @InGame IS NULL
	--BEGIN
	exec @TotalPage = SP_TotalPage_Customer @RecordCount, @FullName, @InGame;
	--END

	SET @SkipItem = (@Page - 1) * @RecordCount;

	WITH LatestGamePrices AS (
    SELECT
        c.ID CustomerID, g.ID GameID,
        c.FullName, c.Birth, c.Mobile, c.InGame, g.Start_Time, c.UnPaid,
        ROW_NUMBER() OVER (PARTITION BY c.ID ORDER BY g.ID DESC) AS RowNum
    FROM
        Tbl_Customer c
    LEFT JOIN Tbl_Game g ON c.ID = g.CustomerID
)
	SELECT l.CustomerID, l.GameID,
	l.FullName, l.Birth, l.Mobile, l.InGame, l.Start_Time, l.UnPaid
	FROM LatestGamePrices l
	WHERE l.RowNum = 1 AND (FullName LIKE '%' + @FullName + '%' OR @FullName IS NULL OR @FullName = '') AND
	(@InGame = InGame OR @InGame IS NULL)
	Order By l.InGame DESC, l.CustomerID DESC
	OFFSET @SkipItem
	ROWS FETCH NEXT @RecordCount
	ROW ONLY;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_User]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SELECT_User]
	@Username nvarchar(40) = NULL,
	@Password nvarchar(100) = NULL
AS
BEGIN
	SELECT ID, Username
	FROM Tbl_User
	WHERE (@Password = Password AND @Username = Username)
	OR (@Username IS NULL AND @Password IS NULL)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SELECT_WHERE_Customer]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SELECT_WHERE_Customer]
	@ID int = NULL,
	@FullName nvarchar(60) = NULL,
	@Birth date = NULL,
	@Mobile varchar(11) = NULL,
	@InGame bit = NULL,

	@RecordCount INT = 20,
	@Page INT = 1,
	@TotalPage INT = 0 output
AS
BEGIN

	DECLARE @SkipItem INT;

	exec @TotalPage = SP_TotalPage_Customer @RecordCount;

	SET @SkipItem = (@Page - 1) * @RecordCount;

	SELECT * FROM Tbl_Customer
	WHERE (@ID = ID OR @ID IS NULL) AND (FullName LIKE '%' + @FullName + '%' OR @FullName IS NULL) AND (@Birth = Birth OR @Birth IS NULL)
	AND (Mobile LIKE '%' + @Mobile + '%' OR @Mobile IS NULL) AND (@InGame = InGame OR @InGame IS NULL)
	Order By [ID] OFFSET @SkipItem
	ROWS FETCH NEXT @RecordCount
	ROW ONLY
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Start_End_Game]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Start_End_Game]
	@CustomerID INT,
	@Time datetime,
	@StartGame bit,
	@GameID INT = NULL,
	@Price INT = NULL
AS
BEGIN
	
	if @StartGame = 1
	BEGIN
		UPDATE Tbl_Customer SET InGame=1 WHERE ID=@CustomerID;
		INSERT INTO Tbl_Game (CustomerID, Start_Time) VALUES (@CustomerID, @Time)
	END
	else
	BEGIN
		UPDATE Tbl_Customer SET InGame=0, UnPaid += @Price
			WHERE ID=@CustomerID;
		UPDATE Tbl_Game SET End_Time=@Time, Price=@Price
			WHERE ID=@GameID;
	END

END
GO
/****** Object:  StoredProcedure [dbo].[SP_TotalPage_Customer]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TotalPage_Customer]
    @ItemCount INT = 20,
	@FullName nvarchar(60) = NULL,
	@InGame bit = NULL
AS
BEGIN
    DECLARE @TotalRecords INT;
    DECLARE @TotalPages INT;

    SELECT @TotalRecords = COUNT(1) FROM Tbl_Customer
	WHERE (FullName LIKE '%' + @FullName + '%' OR @FullName IS NULL OR @FullName = '') AND
	(@InGame = InGame OR @InGame IS NULL);

    SET @TotalPages = CEILING(CAST(@TotalRecords AS FLOAT) / @ItemCount);

    return @TotalPages;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_TotalPage_Customer_Game]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TotalPage_Customer_Game]
	@ItemCount INT = 20
AS
BEGIN
	DECLARE @TotalRecords INT;
    DECLARE @TotalPages INT;

    SET @TotalRecords = (SELECT COUNT(1)
		FROM Tbl_Customer s
		LEFT JOIN Tbl_Game c ON c.CustomerID = s.ID);

    SET @TotalPages = CEILING(CAST(@TotalRecords AS FLOAT) / @ItemCount);

    return @TotalPages;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_TotalPage_Game]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TotalPage_Game]
    @PageSize INT = 20
AS
BEGIN
    DECLARE @TotalRecords BIGINT;
    DECLARE @TotalPages INT;

    SELECT @TotalRecords = COUNT(*) FROM Tbl_Customer;

    SET @TotalPages = CEILING(CAST(@TotalRecords AS FLOAT) / @PageSize);

    return @TotalPages;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_Amusement]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UPDATE_Amusement]
	@Id int,
	@Name nvarchar(50),
	@Address nvarchar(MAX),
	@Owner nvarchar(50),
	@Mobile char(11),
	@Phone varchar(11),
	@Price int
AS
BEGIN
	UPDATE Tbl_AmusementPark SET Name=@Name, Address=@Address, Owner=@Owner, Mobile=@Mobile, Phone=@Phone, Price=@Price
	WHERE ID=@Id;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_Customer]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UPDATE_Customer]
	@Id int,
	@FullName nvarchar(50),
	@Birth date,
	@Mobile char(11)
AS
BEGIN
	UPDATE Tbl_Customer SET FullName=@FullName, Birth=@Birth, Mobile=@Mobile
	WHERE ID=@Id;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_Game]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UPDATE_Game]
	@Id int,
	@EndTime datetime,
	@Price int
AS
BEGIN
	UPDATE Tbl_Game SET End_Time=@EndTime, Price=@Price
	WHERE ID=@Id
END
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_User]    Script Date: 9/7/2024 6:23:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_UPDATE_User]
	@Id int,
	@Username nvarchar(40),
	@Password nvarchar(100)
AS
BEGIN
	UPDATE Tbl_User SET Username=@Username, Password=@Password
	WHERE ID=@Id
END
GO
USE [Amusement_Park]
INSERT INTO Tbl_User ([Username], [Password]) VALUES ('admin', '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b')
