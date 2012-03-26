
----------------------------------------------------------------------
----------------------------------------------------------------------
-- create PROCEDURE Category_Get AS
if exists(select * from sysobjects where name = 'Category_Get')
	drop proc Category_Get
	go
	
	create PROCEDURE Category_Get
	(
		@PageIndex INT,
		@PageSize INT,
		@Sort NVARCHAR(20),
		@p_users_code           NVARCHAR(65)
	)
AS
BEGIN
	SELECT id_num,category_id, category,operator, description
	FROM (
		SELECT id_num,category_id, category,operator, description, ROW_NUMBER () OVER (
			ORDER BY 
				CASE @Sort
					WHEN 'category' THEN category
				END,
				CASE @Sort 
					WHEN 'category DESC' THEN category
				END DESC,
				CASE @Sort WHEN 'description' THEN description END,
				CASE @Sort WHEN 'description DESC' THEN description	END DESC,
				CASE @Sort WHEN 'category_id' THEN category_id END,
				CASE @Sort WHEN 'category_id DESC' THEN category_id	END DESC,
				CASE @Sort WHEN '' THEN id_num END
		) AS RowNumber
		FROM category
		WHERE 		  operator=@p_users_code
	) AS Results
	WHERE RowNumber BETWEEN @PageIndex + 1 AND @PageIndex + @PageSize
	SELECT COUNT(*) FROM category WHERE  operator=@p_users_code
END
go



----------------------------------------------------------------------
----------------------------------------------------------------------
if exists(select * from sysobjects where name = 'Category_Delete')
	drop proc Category_Delete
	go
create PROCEDURE Category_Delete
	(
	@Id INT
	)
AS
	SET NOCOUNT ON
	DELETE FROM category WHERE id_num = @Id
	RETURN

go

----------------------------------------------------------------------
----------------------------------------------------------------------
if exists(select * from sysobjects where name = 'Category_Insert')
	drop proc Category_Insert
	go
	
	create PROCEDURE Category_Insert
	(
	@category_id VARCHAR(15),
	@category NVARCHAR(65),
	@description nvarchar(250),
	@operator varchar(35)
	)
AS
BEGIN
	INSERT INTO category (
		category_id,
		category,
		description,
		operator
	) VALUES (
		@category_id,
		@category,
		@description,
		@operator
	)
	SELECT @@Identity
END

go

----------------------------------------------------------------------
----------------------------------------------------------------------
 --create PROCEDURE Category_Update as 
 --drop PROCEDURE Category_Update as
if exists(select * from sysobjects where name = 'Category_Update')
	drop proc Category_Update
	go

create PROCEDURE Category_Update
	(
	@Id INT,
	@category_id VARCHAR(15),
	@category NVARCHAR(65),
	@description nvarchar(250),
	@operator varchar(35)
	)
AS
BEGIN
	UPDATE category SET
		category_id   =    		@category_id, 
		category      =    		@category,    
		description   =    		@description, 
		operator      =    		@operator 
  WHERE	id_num = @Id 
END

go


------------------------------------------------------------
------------------------------------------------------------
--if(select count(*) from sysobjects where name = 'bom_category') > 0
--  drop table bom_category
--go
--create table bom_category
--(
--id_num            int identity    not null ,
--category_id       varchar(15)                 ,
--category          varchar(65)                 ,
--description       nvarchar(250)            ,
--operator          char(35),
--) 
-- create PROCEDURE Category_Get AS
if exists(select * from sysobjects where name = 'BomCategory_Get')
	drop proc BomCategory_Get
	go
	
create PROCEDURE BomCategory_Get
	(
		@PageIndex INT,
		@PageSize INT,
		@Sort NVARCHAR(20),
		@p_users_code           NVARCHAR(65)
	)
AS
BEGIN
	SELECT id_num,category_id, category,operator, description
	FROM (
		SELECT id_num,category_id, category,operator, description, ROW_NUMBER () OVER (
			ORDER BY 
				CASE @Sort
					WHEN 'category' THEN category
				END,
				CASE @Sort 
					WHEN 'category DESC' THEN category
				END DESC,
				CASE @Sort WHEN 'description' THEN description END,
				CASE @Sort WHEN 'description DESC' THEN description	END DESC,
				CASE @Sort WHEN 'category_id' THEN category_id END,
				CASE @Sort WHEN 'category_id DESC' THEN category_id	END DESC,
				CASE @Sort WHEN '' THEN id_num END
		) AS RowNumber
		FROM bom_category
		WHERE 		  operator=@p_users_code
	) AS Results
	WHERE RowNumber BETWEEN @PageIndex + 1 AND @PageIndex + @PageSize
	SELECT COUNT(*) FROM bom_category WHERE  operator=@p_users_code
END
go



----------------------------------------------------------------------
----------------------------------------------------------------------
if exists(select * from sysobjects where name = 'BomCategory_Delete')
	drop proc BomCategory_Delete
	go
	create  PROCEDURE BomCategory_Delete
	(
	@Id INT
	)
AS
	SET NOCOUNT ON
	DELETE FROM bom_category WHERE id_num = @Id
	RETURN

go

----------------------------------------------------------------------
----------------------------------------------------------------------
if exists(select * from sysobjects where name = 'BomCategory_Insert')
	drop proc BomCategory_Insert
	go
	create PROCEDURE BomCategory_Insert
	(
	@category_id VARCHAR(15),
	@category NVARCHAR(65),
	@description nvarchar(250),
	@operator varchar(35)
	)
AS
BEGIN
	INSERT INTO bom_category (
		category_id,
		category,
		description,
		operator
	) VALUES (
		@category_id,
		@category,
		@description,
		@operator
	)
	SELECT @@Identity
END

go

----------------------------------------------------------------------
----------------------------------------------------------------------
 
if exists(select * from sysobjects where name = 'BomCategory_Update')
	drop proc BomCategory_Update
	go
	create PROCEDURE BomCategory_Update
	(
	@Id INT,
	@category_id VARCHAR(15),
	@category NVARCHAR(65),
	@description nvarchar(250),
	@operator varchar(35)
	)
AS
BEGIN
	UPDATE bom_category SET
		category_id   =    		@category_id, 
		category      =    		@category,    
		description   =    		@description, 
		operator      =    		@operator 
  WHERE	id_num = @Id 
END

go




------------------------------------------------------------
------------------------------------------------------------
--if(select count(*) from sysobjects where name = 'bom_lower_level') > 0
--  drop table bom_lower_level
--go

--create table bom_lower_level
--(
--id_num            int identity    not null ,
--level_code        varchar(15)                 ,
--lower_level       int                      ,
--description       nvarchar(250)            ,
--operator          char(35),
--)
--go

if exists(select * from sysobjects where name = 'BomLowerLevel_Get')
	drop proc BomLowerLevel_Get
	go
	
create PROCEDURE BomLowerLevel_Get
	(
		@PageIndex INT,
		@PageSize INT,
		@Sort NVARCHAR(20),
		@p_users_code           NVARCHAR(65)
	)
AS
BEGIN
	SELECT id_num,level_code, lower_level,operator, description
	FROM (
		SELECT id_num,level_code, lower_level,operator, description, ROW_NUMBER () OVER (
			ORDER BY 
				CASE @Sort
					WHEN 'level_code' THEN level_code
				END,
				CASE @Sort 
					WHEN 'level_code DESC' THEN level_code
				END DESC,
				CASE @Sort WHEN 'description' THEN description END,
				CASE @Sort WHEN 'description DESC' THEN description	END DESC,
				CASE @Sort WHEN 'lower_level' THEN lower_level END,
				CASE @Sort WHEN 'lower_level DESC' THEN lower_level	END DESC,
				CASE @Sort WHEN '' THEN id_num END
		) AS RowNumber
		FROM bom_lower_level WHERE 		  operator=@p_users_code
	) AS Results
	WHERE RowNumber BETWEEN @PageIndex + 1 AND @PageIndex + @PageSize
	SELECT COUNT(*) FROM bom_lower_level WHERE  operator=@p_users_code
END
go



----------------------------------------------------------------------
----------------------------------------------------------------------
if exists(select * from sysobjects where name = 'BomLowerLevel_Delete')
	drop proc BomLowerLevel_Delete
	go
	create  PROCEDURE BomLowerLevel_Delete
	(
	@Id INT
	)
AS
	SET NOCOUNT ON
	DELETE FROM bom_lower_level WHERE id_num = @Id
	RETURN

go

----------------------------------------------------------------------
----------------------------------------------------------------------
if exists(select * from sysobjects where name = 'BomLowerLevel_Insert')
	drop proc BomLowerLevel_Insert
	go
	create PROCEDURE BomLowerLevel_Insert
	(
	@lower_level int,
	@level_code NVARCHAR(65),
	@description nvarchar(250),
	@operator varchar(35)
	)
AS
BEGIN
	INSERT INTO bom_lower_level (
		lower_level,
		level_code,
		description,
		operator
	) VALUES (
		@lower_level,
		@level_code,
		@description,
		@operator
	)
	SELECT @@Identity
END

go

----------------------------------------------------------------------
----------------------------------------------------------------------
 
if exists(select * from sysobjects where name = 'BomLowerLevel_Update')
	drop proc BomLowerLevel_Update
	go
	create PROCEDURE BomLowerLevel_Update
	(
	@Id INT,
	@lower_level int,
	@level_code NVARCHAR(65),
	@description nvarchar(250),
	@operator varchar(35)
	)
AS
BEGIN
	UPDATE bom_lower_level SET
		lower_level   =    		@lower_level, 
		level_code      =    	@level_code,    
		description   =    		@description, 
		operator      =    		@operator 
  WHERE	id_num = @Id 
END

go



------------------------------------------------------------
----------system---bill of material-------------end
------------------------------------------------------------

--if exists(select * from sysobjects where name='rcebrand')
--   drop table rcebrand
-- go
 
--create table rcebrand
--(
--id_num      int identity   not null,
--brand       varchar(35) not null,
--series      varchar(65) not null,
--model       varchar(65) not null,
--operator          char(35),
--CONSTRAINT pk_rcebrand PRIMARY KEY CLUSTERED (brand,series,model,operator)  ON [PRIMARY]
--)
-- ON [PRIMARY]
--go


if exists(select * from sysobjects where name = 'Brand_Get')
	drop proc Brand_Get
	go
	
create PROCEDURE Brand_Get
	(
		@PageIndex INT,
		@PageSize INT,
		@Sort NVARCHAR(20),
		@p_users_code           NVARCHAR(65)
	)
AS
BEGIN
	SELECT id_num,brand, series,model,operator
	FROM (
		SELECT id_num,brand, series,model,operator, ROW_NUMBER () OVER (
			ORDER BY 
				CASE @Sort
					WHEN 'brand' THEN brand
				END,
				CASE @Sort 
					WHEN 'brand DESC' THEN brand
				END DESC,
				CASE @Sort WHEN 'series' THEN series END,
				CASE @Sort WHEN 'series DESC' THEN series	END DESC,
				CASE @Sort WHEN 'model' THEN model END,
				CASE @Sort WHEN 'model DESC' THEN model	END DESC,
				CASE @Sort WHEN '' THEN id_num END
		) AS RowNumber
		FROM rcebrand
		WHERE 		  operator=@p_users_code
	) AS Results
	WHERE RowNumber BETWEEN @PageIndex + 1 AND @PageIndex + @PageSize
	SELECT COUNT(*) FROM rcebrand WHERE  operator=@p_users_code
END
go



----------------------------------------------------------------------
----------------------------------------------------------------------
if exists(select * from sysobjects where name = 'Brand_Delete')
	drop proc Brand_Delete
	go
	create  PROCEDURE Brand_Delete
	(
	@Id INT
	)
AS
	SET NOCOUNT ON
	DELETE FROM rcebrand WHERE id_num = @Id
	RETURN

go

----------------------------------------------------------------------
----------------------------------------------------------------------
if exists(select * from sysobjects where name = 'Brand_Insert')
	drop proc Brand_Insert
	go
	create PROCEDURE Brand_Insert
	(
	@brand VARCHAR(35),
	@series NVARCHAR(65),
	@model nvarchar(65),
	@operator varchar(35)
	)
AS
BEGIN
	INSERT INTO rcebrand (
		brand,
		series,
		model,
		operator
	) VALUES (
		@brand,
		@series,
		@model,
		@operator
	)
	SELECT @@Identity
END

go

----------------------------------------------------------------------
----------------------------------------------------------------------
 
if exists(select * from sysobjects where name = 'Brand_Update')
	drop proc Brand_Update
	go
	create PROCEDURE Brand_Update
	(
	@Id INT,
	@brand VARCHAR(35),
	@series NVARCHAR(65),
	@model nvarchar(65),
	@operator varchar(35)
	)
AS
BEGIN
	UPDATE rcebrand SET
		brand   =    		@brand, 
		series      =    	@series,    
		model   =    		@model, 
		operator      =    		@operator 
  WHERE	id_num = @Id 
END

go
