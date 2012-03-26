USE Tempdb
GO
ALTER DATABASE infoccc_test COLLATE Chinese_PRC_CI_AS 
GO


USE [master]
GO
EXEC master . dbo. sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'AllowInProcess' , 1
GO
EXEC master . dbo. sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0' , N'DynamicParameters' , 1
GO

sp_configure 'show advanced options', 1
go
reconfigure
go
sp_configure 'Ad Hoc Distributed Queries', 1
go
reconfigure
go


SELECT * INTO XLImport5 FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0',
'Excel 8.0;Database=C:\test\xltest.xls', 'SELECT * FROM [Customers$]')

SELECT *  FROM OPENROWSET('Microsoft.Jet.OLEDB.4.0',
'Excel 8.0;Database=C:\work\sara\PARTLIST.xlsx', 'SELECT * FROM [PARTLIST$]')

select * into partno_tmp FROM OPENROWSET (
  'Microsoft.ACE.OLEDB.12.0' ,
  'Excel 12.0;Database=C:\work\sara\PARTLIST.xlsx', 'SELECT * FROM [PARTLIST$]')
 
 SELECT * 
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 
'Excel 12.0;Database=C:\work\sara\PARTLIST.xls;HDR=YES', 'SELECT * FROM [PARTLIST$]')


USE [master]
GO

EXEC dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
GO

EXEC dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO


select * FROM OPENROWSET (
  'Microsoft.ACE.OLEDB.12.0' ,
  'Excel 12.0;Database=C:\work\sara\book1.xlsx', 'SELECT * FROM [Sheet1$]')
 
 
SELECT * FROM OPENROWSET
('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0;Database=C:\work\sara\book1.xlsx;HDR=YES;IMEX=1',
'SELECT * FROM [Sheet1$]'); 


insert into partno(part_no,part_name,price1,unit)

select a,b,c,d from partno_tmp  where a not in (
'YCD01',
'YCD02',
'YCD03',
'YCDG01',
'YCDG02',
'YCDG03',
'YCDG04',
'YCDG05'
)
select * from partno



			update warehouse 
			 set part_name = p.part_name,
				 description = p.part_description
				 from warehouse w, partno p
				  where w.part_no = p.part_no
						and p.part_no = 'YCE05'   and p.operator = @p_usercode
				
				
				