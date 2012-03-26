-- CREATE DATABASE MenuDb
-- GO
-- USE MenuDb
-- GO
if exists (select * from sysobjects where name='Menu' and xtype='U')
   drop table [Menu]
   go
   
CREATE TABLE [Menu] (
	[MenuID] [int] IDENTITY (1, 1) NOT NULL ,
	[Text] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Url] [varchar] (55) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ParentID] [int] NULL ,
	CONSTRAINT [PK_Menu] PRIMARY KEY  CLUSTERED 
	(
		[MenuID]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO


INSERT INTO MENU
Select 'PartNo','PartNO Managment', NULL, NULL
UNION ALL Select 'Client','Client Management', NULL, NULL
UNION ALL Select 'Inventory','Inventory Management', NULL, NULL
UNION ALL Select 'Invoice','Cutromer Purchase Order && Invoice', NULL, NULL
UNION ALL Select 'Admin','System Administrator', NULL, NULL
--UNION ALL Select 'Logout','Logout', NULL, NULL

UNION ALL Select 'Add New PartNO','Add New PartNO', 'partnonew.aspx',1
UNION ALL Select 'Search PartNO','Search PartNO Details', 'partnosearch.aspx',1

UNION ALL Select 'Add New Customer','Add New Customer Information','ClientNew.aspx', 2
UNION ALL Select 'Search Customer','Search & View Customer', 'ClientSearch.aspx',2
UNION ALL Select 'Customer PO Search','Search & View Customer PO', 'ClientPOSearch.aspx',2

UNION ALL Select 'Add Inventory','Input Inventory Receipt', 'InventAdd.aspx',3
UNION ALL Select 'Check Receipt','Check Inventory Receipt details', 'InventRecChk.aspx',3
UNION ALL Select 'Inventory View','Search & List All Inventory','InventList.aspx', 3

UNION ALL Select 'Add CPO','Add Customer Purchase Order','CpoAdd.aspx', 4
UNION ALL Select 'List CPO','List & Check CPO','CpoList.aspx', 4
UNION ALL Select 'List Invoice HX','List Invoice','InvoiceList.aspx', 4
UNION ALL Select 'List Invoice','List Invoice Normal','InvoiceNormal.aspx', 4

UNION ALL Select 'User Active','Set up User Entity ID','AdminUserActive.aspx', 5
UNION ALL Select 'User Menu Set','Set Users Menu','AdminUserMenu.aspx', 5
UNION ALL Select 'User Profile','Edit User Information','AdminUserProfile.aspx', 5
UNION ALL Select 'Change Password','Change Password','account/ChangePassword.aspx', 5
UNION ALL Select 'ADD Category','Category View / Edit /Insert','AdminCategoryAdd.aspx', 5
UNION ALL Select 'List Category','Category View / Edit /Insert','AdminCategoryList.aspx', 5
UNION ALL Select 'User List','Users View ','AdminUsersList.aspx', 5
UNION ALL Select 'Error Report','Report Error to Administrator','ErrorReport.aspx', 5


GO