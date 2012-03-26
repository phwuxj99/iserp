
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
--Auguest 30,2008 begin
--create  PROCEDURE GetPartNOForPOSorted as
-- drop proc GetPartNOForPOSorted
 ALTER PROCEDURE GetPartNOForPOSorted
--CREATE PROCEDURE GetPartNOForPOSorted 
 ( 
  @sortExpression nvarchar(100),
  @sortDirection  varchar(15),
  @startRowIndex int, 
  @maximumRows int ,
  @p_partno varchar(35),
  @p_usercode   varchar(35),
  @rowcount int output
 ) 
 AS 

	 -- Make sure a @sortExpression is specified 
	 declare @StartRecord int,@EndRecord int

	 IF LEN(@sortExpression) = 0 or @sortExpression is null
	    SET @sortExpression = 'part_no'

	 SET @StartRecord = (@startRowIndex - 1) * @maximumRows + 1

	-- Find last record on selected page
	SET @EndRecord = @startRowIndex * @maximumRows

	 select @rowcount=COUNT(*) from warehouse where lower(part_no) like '%'+lower(rtrim(@p_partno))+'%' and operator = rtrim(@p_usercode)
	  -- Issue query 
	 declare @sql nvarchar(4000)
	 set @sql='  select a.*
	                      from (select  *,
	                           ROW_NUMBER() OVER(ORDER BY '+@sortExpression +' '+rtrim(@sortDirection)+' ) as rowrank
	                           from warehouse  
	                         where operator =  '''+ rtrim(@p_usercode) +''' and lower(part_no) like '''+lower(rtrim(@p_partno))+'%'+''' ) as a
	                          where  a.rowrank >='+convert(nvarchar(10),@StartRecord)+' and
	                              a.rowrank <=('+convert(nvarchar(10),@EndRecord)+' ) '

  EXEC sp_executesql @sql

  go

-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
--September 7,2009 begin
--create  PROCEDURE GetCPOSorted as
-- drop proc GetCPOSorted
  ALTER PROCEDURE GetCPOSorted
--CREATE PROCEDURE GetCPOSorted 
 ( 
  @sortExpression nvarchar(100),
  @sortDirection  varchar(15),
  @startRowIndex int, 
  @maximumRows int ,
  @p_cpono varchar(35),
  @p_usercode   varchar(35),
  @rowcount int output
 ) 
 AS 

	 -- Make sure a @sortExpression is specified 
	 declare @StartRecord int,@EndRecord int

	 IF LEN(@sortExpression) = 0 or @sortExpression is null
	    SET @sortExpression = 'cpono'

	 SET @StartRecord = (@startRowIndex - 1) * @maximumRows + 1

	-- Find last record on selected page
	SET @EndRecord = @startRowIndex * @maximumRows

   create table #tmpcpono(cpono varchar(35))

	 select @rowcount=COUNT(distinct cpono) from cpo where lower(cpono) like '%'+lower(rtrim(@p_cpono))+'%'  and operator = rtrim(@p_usercode)
	  -- Issue query 
	 declare @sql nvarchar(4000)
	 set @sql=' insert into #tmpcpono(cpono) select a.cpono 
	                      from (select  cpono,
	                           ROW_NUMBER() OVER(ORDER BY '+@sortExpression +' '+rtrim(@sortDirection)+' ) as rowrank
	                           from cpo  
	                         where operator =  '''+ rtrim(@p_usercode) +''' and lower(cpono) like '''+lower(rtrim(@p_cpono))+'%'+''' group by cpono ) as a
	                          where  a.rowrank >='+convert(nvarchar(10),@StartRecord)+' and
	                              a.rowrank <=('+convert(nvarchar(10),@EndRecord)+' ) '

  EXEC sp_executesql @sql
  
  select a.cpono,min(c.op_date) as op_date from #tmpcpono a 
  		left join cpo c  on a.cpono=c.cpono  
  				group by a.cpono 
  						order by op_date desc
  
  go
  
  /*
declare @p8 int
set @p8=NULL
declare @p9 int
set @p9=NULL
exec sp_executesql N'EXEC @RETURN_VALUE = [GetCPOSorted] @sortExpression = @p0, @sortDirection = @p1, @startRowIndex = @p2, @maximumRows = @p3, @p_cpono = @p4, @rowcount = @p5 OUTPUT',N'@p0 nvarchar(4000),@p1 varchar(4),@p2 int,@p3 int,@p4 varchar(8000),@p5 int output,@RETURN_VALUE int output',@p0=NULL,@p1='desc',@p2=1,@p3=10,@p4='',@p5=@p8 output,@RETURN_VALUE=@p9 output
select @p8, @p9

  */


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists ( select * from sysobjects where name='cpo_add')
		drop proc cpo_add
	go
	
create proc cpo_add             @p_cpono     varchar(35),
                                @p_cnamecode varchar(35),
                                @p_partno    varchar(150),
                                @p_qty       int,
                                @p_soprice   decimal(12,2),
                                @p_usercode   varchar(35),
                                @isvalid     varchar(253)  output
                          with encryption as

	declare @filename char(35),     @pkno char(15),@cname_id int,@cname varchar(120),
	        @apono char(35),@weight decimal(12,2),
	        @price    decimal(12,2),@itemno int,   
	        @soprice decimal(12,2),@qty_avail int 
	
	select @cname = cname from erpclient where cname_code = @p_cnamecode

 if (select count(*) from cpo where cpono=@p_cpono   and operator = @p_usercode)<1
    select @itemno = '1'
 else select @itemno = count(*)+1 from cpo where cpono = @p_cpono   and operator = @p_usercode

 insert cpo(cpono,itemno,part_no,qty,soprice,op_date,operator,cname,cname_code)
	  values(@p_cpono,@itemno,@p_partno,@p_qty,@p_soprice,getdate(),@p_usercode,@cname,@p_cnamecode)
	if @@rowcount = 0
		begin
			select @isvalid = 'Add failed'
			return -200
		end

   update warehouse set qty=qty-@p_qty where part_no = @p_partno   and operator = @p_usercode


  return 0

 go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists ( select * from sysobjects where name='cpo_Singledelete')
		drop proc cpo_Singledelete
	go
	
create proc cpo_Singledelete    @p_idnum int,
                                @p_usercode   varchar(35),
                                @isvalid     varchar(253)  output
                          with encryption as

	 declare @partno char(35), @qty int

	 select @partno = part_no,@qty = qty from cpo where id_num = @p_idnum   and operator = @p_usercode

	 update warehouse set qty=qty+@qty where part_no = @partno   and operator = @p_usercode

	 delete cpo where  id_num = @p_idnum   and operator = @p_usercode
	 
	 select @isvalid='Success.'

  return 0

 go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
if exists ( select * from sysobjects where name='cpo_Confirm')
		drop proc cpo_Confirm
	go
	
create proc cpo_Confirm         @p_cpono     varchar(35),
                                @p_usercode   varchar(35),
                                @isvalid     varchar(253)  output
                          with encryption as

   update cpo set finished = 0 where cpono=@p_cpono   and operator = @p_usercode

	select @isvalid='Success.'

   return 0

 go


  /*
declare @p7 int
set @p7=0
declare @p8 int
set @p8=0
exec sp_executesql N'EXEC @RETURN_VALUE = [dbo].[GetPartNOForPOSorted] @sortExpression = @p0, @startRowIndex = @p1, @maximumRows = @p2, @p_partno = @p3, @rowcount = @p4 OUTPUT',N'@p0 nvarchar(4000),@p1 int,@p2 int,@p3 varchar(2),@p4 int output,@RETURN_VALUE int output',@p0=null,@p1=1,@p2=10,@p3='1',@p4=@p7 output,@RETURN_VALUE=@p8 output
select @p7 as row, @p8
  */


/*set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

CREATE PROCEDURE [dbo].[sp_GridView_RowNumber]
(
    @PageNum int,
    @PageSize int,
    @TotalRowsNum int output
)
AS

BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from

    -- interfering with SELECT statements.

    SET NOCOUNT ON;

    -- Use ROW_NUMBER function

    WITH Salespeople_AdventureWorks As
    (
        SELECT 'RowNumber' = ROW_NUMBER() OVER(ORDER BY SalesYTD DESC), 
               'Name' = c.FirstName + ' ' + c.LastName, s.SalesYTD, a.PostalCode
        FROM Sales.SalesPerson s JOIN Person.Contact c on s.SalesPersonID = c.ContactID
        JOIN Person.Address a ON a.AddressID = c.ContactID
        WHERE ((TerritoryID IS NOT NULL) AND (s.SalesYTD <> 0))
    )

    -- Query result

    SELECT * 
    FROM Salespeople_AdventureWorks
    WHERE RowNumber BETWEEN (@PageNum - 1) * @PageSize + 1 AND @PageNum * @PageSize             
    ORDER BY SalesYTD DESC

    -- Returns total records number

    SELECT @TotalRowsNum = count(*) 
    FROM Sales.SalesPerson s JOIN Person.Contact c on s.SalesPersonID = c.ContactID
    JOIN Person.Address a ON a.AddressID = c.ContactID
    WHERE ((TerritoryID IS NOT NULL) AND (s.SalesYTD <> 0))
END


CREATE PROCEDURE [dbo].[usp_GetCustomersPaged] (@maximumRows int = 10,@startRowIndex int = 20)
-- Created from query generated by LinqDataSource
AS
SET NOCOUNT ON
SELECT TOP (@maximumRows) [t1].[CustomerID], [t1].[CompanyName],
    [t1].[ContactName], [t1].[ContactTitle], [t1].[Address],
    [t1].[City], [t1].[Region], [t1].[PostalCode], [t1].[Country],
    [t1].[Phone], [t1].[Fax]
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY [t0].[CustomerID],
     [t0].[CompanyName], [t0].[ContactName], [t0].[ContactTitle],
     [t0].[Address], [t0].[City], [t0].[Region], [t0].[PostalCode],
     [t0].[Country], [t0].[Phone], [t0].[Fax]) AS [ROW_NUMBER],
     [t0].[CustomerID], [t0].[CompanyName], [t0].[ContactName],
     [t0].[ContactTitle], [t0].[Address], [t0].[City], [t0].[Region],
     [t0].[PostalCode], [t0].[Country], [t0].[Phone], [t0].[Fax]
    FROM [dbo].[Customers] AS [t0]
    ) AS [t1]
WHERE [t1].[ROW_NUMBER] > @startRowIndex
SET NOCOUNT OFF;


CREATE PROCEDURE dbo.GetProductsPaged ( @startRowIndex int, @maximumRows int )
 AS 
 SELECT ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, 
 ReorderLevel, Discontinued, CategoryName, SupplierName 
    FROM ( SELECT ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, 
                   UnitsOnOrder, ReorderLevel, Discontinued, 
                   (SELECT CategoryName FROM Categories WHERE Categories.CategoryID = Products.CategoryID) AS CategoryName, 
                   (SELECT CompanyName FROM Suppliers WHERE Suppliers.SupplierID = Products.SupplierID) AS SupplierName, 
                   ROW_NUMBER() OVER (ORDER BY ProductName) AS RowRank FROM Products ) AS ProductsWithRowNumbers
                     WHERE RowRank > @startRowIndex AND RowRank <= (@startRowIndex + @maximumRows)
*/


/*                     
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
/// <summary>
/// Summary description for ProductDAL
/// </summary>
public class ProductDAL
{
    public static List<Product> GetProducts()
    {
        return GetProducts(int.MaxValue, 0);
    }
    public static List<Product> GetProducts(int maximumRows, int startRowIndex)
    {
        return GetProducts(maximumRows, startRowIndex);
    }
    public static List<Product> GetProducts(int maximumRows,   int startRowIndex)
    {
        // returns a list of Product instances based on the
        // data in the Northwind Products table
        string sql = @"SELECT ProductID, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock  FROM Products";
        using (SqlConnection myConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["NWConnectionString"].ConnectionString))
        {
            // Place the data in a DataTable
            SqlCommand myCommand = new SqlCommand(sql, myConnection);
            SqlDataAdapter myAdapter = new SqlDataAdapter(myCommand);
            myConnection.Open();
            DataTable dt = new DataTable();
            myAdapter.Fill(dt);
            List<Product> results = new List<Product>();
            int currentIndex = startRowIndex;
            int itemsRead = 0;
            int totalRecords = dt.Rows.Count;
            while (itemsRead < maximumRows && currentIndex < totalRecords)
            {
                Product product = new Product();
                product.ProductID = Convert.ToInt32(dt.Rows[currentIndex]["ProductID"]);
                product.ProductName = dt.Rows[currentIndex]["ProductName"].ToString();
                product.QuantityPerUnit = dt.Rows[currentIndex]["QuantityPerUnit"].ToString();
                if (dt.Rows[currentIndex]["UnitPrice"].Equals(DBNull.Value))
                    product.UnitPrice = 0;
                else
                    product.UnitPrice = Convert.ToDecimal(dt.Rows[currentIndex]["UnitPrice"]);
                if (dt.Rows[currentIndex]["UnitsInStock"].Equals(DBNull.Value))
                    product.UnitsInStock = 0;
                else
                    product.UnitsInStock = Convert.ToInt32(dt.Rows[currentIndex]["UnitsInStock"]);
                results.Add(product);
                itemsRead++;
                currentIndex++;
            }
            myConnection.Close();
            return results;
        }
    }
}


<%@ Page Language="C#" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" 
  "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<script runat="server">
</script>
<html  >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:ObjectDataSource ID="productsDataSource" 
          Runat="server" TypeName="ProductDAL" 
          SortParameterName="SortExpression"
            SelectMethod="GetProducts" EnablePaging="True" 
            SelectCountMethod="TotalNumberOfProducts">
        </asp:ObjectDataSource>
        <asp:GridView ID="productsGridView" AllowPaging="True" 
         BorderColor="White" BorderStyle="Ridge"
            CellSpacing="1" CellPadding="3" GridLines="None" 
            BackColor="White" BorderWidth="2px"
            AutoGenerateColumns="False" 
            DataSourceID="productsDataSource" 
            Runat="server" AllowSorting="True">
            <FooterStyle ForeColor="Black" BackColor="#C6C3C6"></FooterStyle>
            <PagerStyle ForeColor="Black" HorizontalAlign="Right" 
             BackColor="#C6C3C6"></PagerStyle>
            <HeaderStyle ForeColor="#E7E7FF" Font-Bold="True" 
             BackColor="#4A3C8C"></HeaderStyle>
            <Columns>
                <asp:BoundField HeaderText="Product" 
                  DataField="ProductName" 
                  SortExpression="ProductName"></asp:BoundField>
                <asp:BoundField HeaderText="Unit Price" 
                  DataField="UnitPrice" SortExpression="UnitPrice"
                    DataFormatString="{0:c}">
                    <ItemStyle HorizontalAlign="Right"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField HeaderText="Units In Stock" 
                    DataField="UnitsInStock" 
                    SortExpression="UnitsInStock"
                    DataFormatString="{0:d}">
                    <ItemStyle HorizontalAlign="Right"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField HeaderText="Quantity Per Unit" 
                   DataField="QuantityPerUnit"></asp:BoundField>
            </Columns>
            <SelectedRowStyle ForeColor="White" 
               Font-Bold="True" 
               BackColor="#9471DE"></SelectedRowStyle>
            <RowStyle ForeColor="Black" BackColor="#DEDFDE"></RowStyle>
        </asp:GridView>
        <i>You are viewing page
        <%=productsGridView.PageIndex + 1%>
        of
        <%=productsGridView.PageCount%>
        </i>
    
    </div>
    </form>
</body>
</html>
*/
