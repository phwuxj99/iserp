--use erp
--go
/*
if exists(select * from sysobjects where name='sys_menu')
            drop table sys_menu
    go
    
    create table sys_menu
    (
     id_num int identity(1,1) not null,
     menu_id int not null,
     m_name varchar(50),
     m_description varchar(255),
     m_link varchar(255),
     parent_id int null,
     CONSTRAINT pk_menu_id PRIMARY KEY CLUSTERED (menu_id)  ON [PRIMARY]
    ) ON [PRIMARY]
    go
*/
-- Create the site map node table

if exists(select * from sysobjects where name='SiteMap')
            drop table SiteMap
    go
    
CREATE TABLE [SiteMap] (
    [ID]          [int] NOT NULL,
    [Title]       [nvarchar] (32),
    [Description] [nvarchar] (512),
    [Url]         [varchar] (512),
    [Roles]       [varchar] (512),
    [Parent]      [int],
    [Language]    [varchar] (12)
) ON [PRIMARY]
GO

ALTER TABLE [SiteMap] ADD 
    CONSTRAINT [PK_SiteMap] PRIMARY KEY CLUSTERED 
    (
        [ID]
    )  ON [PRIMARY] 
GO
/*
-- Add site map nodes

INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent)
VALUES (1, 'Home', NULL, '~/Default.aspx', NULL, NULL)

INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent)
VALUES (10, 'News', NULL, NULL, '*',1,'en-US')

INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent)
VALUES (11, 'Local', 'News from greater Seattle', '~/Summary.aspx?CategoryID=0', NULL, 10)

INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent)
VALUES (12, 'World', 'News from around the world', '~/Summary.aspx?CategoryID=2', NULL, 10)

INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent)
VALUES (20, 'Sports', NULL, NULL, '*',1,'en-US')

INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent)
VALUES (21, 'Baseball', 'What''s happening in baseball', '~/Summary.aspx?CategoryID=3', NULL, 20)
*/
----------------------------------------ERPDB
--INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent)
--VALUES (1, 'Home', NULL, 'main.aspx', '*',1,'en-US')

INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (1, 'Logout', 'Logout', 'admin/logout.aspx', '*',1,'en-US')

--PartNo Manager
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (100, 'Part NO.', NULL, NULL, '*',1,'en-US')

--INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
--     values(1,'PartNo','PartNo Manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(101,'Add New PartNo','Add New PartNo','partno/input.aspx',100,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(102,'Search PartNo','Search PartNo','partno/partno.aspx',100,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(104,'IMG Upload','Upload PartNo Image','partno/uploadimg.aspx',100,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(107,'Batch Upload PartNo','Batch Upload PartNo','partno/uploadpartno.aspx',100,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(109,'View PartNo Picture','View PartNo Picture','partno/partnoviewpic.aspx',100,'en-US')

--BOM manager

INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (200, 'B.O.M', NULL, NULL, '*',1,'en-US')

--INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
--     values(2,'BOM','Bill of Material','main.aspx',null)
--insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
--     values(22,'Comp Input','Component Input','bom/cinput.aspx',2)
--insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
--     values(24,'Comp Search','Component Search','bom/scomponent.aspx',2)     
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(206,'Add New BOM','Add New BOM','bom/input.aspx',200,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(208,'Search B.O.M','Search BOM','bom/sbom.aspx',200,'en-US')
--insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
--     values(210,'Bom Copy','BOM Copy','bom/copyto.aspx',2)

--Supply Manager
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (300, 'Supplier', NULL, NULL, '*',1,'en-US')

--INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
--     values(3,'Supply','Supply manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(301,'Add New Supplier','Add New Supply','supply/input.aspx',300,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(302,'Search Supplier','Search Supply','supply/ssupply.aspx',300,'en-US')

--Warehouse
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (400, 'Inventory', NULL, NULL, '*',1,'en-US')

--INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
--     values(4,'Warehouse','Warehouse manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(401,'Add New Orders ','Warehouse Product Receiving List  Input','warehouse/input.aspx',400,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(402,'Search Order','Warehouse Product Receiving List Edit','warehouse/search.aspx',400,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(404,'Add New Inbound','Supply Search','warehouse/inbound.aspx',400,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(406,'Search Inventory','Supply Search','warehouse/inventory.aspx',400,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(408,'Set Min & Max Inventory','Set Min and Max Inventory','warehouse/minormaxset.aspx',400,'en-US')

--Client Manager
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (500, 'Customer', NULL, NULL, '*',1,'en-US')

--INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
--     values(6,'Client','Client manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(501,'Add New Customer','Customer input','client/input.aspx',500,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(502,'Search Customer','Customer Search','client/sclient.aspx',500,'en-US')

--Purchase Order Manager
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (600, 'Purchase.Order', NULL, NULL, '*',1,'en-US')

--INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
--     values(6,'Client','Client manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(601,'Add New P.O.','PO input','PO/input.aspx',600,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(602,'Search P.O.','PO Search','PO/POSearch.aspx',600,'en-US')

--Invoice Manager
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (700, 'Invoice', NULL, NULL, '*',1,'en-US')

--INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
--     values(6,'Client','Client manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(701,'Add New Invoice','Invoice input','Invoice/input.aspx',700,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(702,'Search Invoice','Invoice Search','Invoice/sinvoice.aspx',700,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(704,'Print Invoice','Invoice Print','Invoice/CrystalINV.aspx',700,'en-US')

--System Manager
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (900, 'Miscellaneous', NULL, NULL, '*',1,'en-US')

--INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
--     values(99,'System','System manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(901,'Add/Edit Category','Accessories information','ddefault.aspx',900,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(905,'Active User','Active User','admin/activeuser.aspx',900,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(910,'User Menu Set','User Menu Set','admin/usermenuset.aspx',900,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(915,'Change Password','Change Password','admin/usersChgPWD.aspx',900,'en-US')
INSERT INTO SiteMap (ID, Title, Description, Url, Parent,[Language])
     values(920,'User Login List','User Login List','admin/loginhist.aspx',900,'en-US')



--INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent)
--VALUES (1000, 'Logout', NULL, 'admin/logout.aspx', '*',1,'en-US')


go


if exists(select * from sysobjects where name='proc_GetSiteMap')
	drop proc proc_GetSiteMap
 go
 
CREATE PROCEDURE proc_GetSiteMap 
      @p_users           varchar(35),
      @p_language        varchar(12)
       AS
       
    if(@p_users='infocccadmin')
    
    SELECT [ID], [Title], [Description], [Url], [Roles], [Parent]
    FROM [SiteMap] where Language=@p_language ORDER BY [ID]
    
    else
    
    SELECT [ID], [Title], [Description], [Url], [Roles], [Parent]
    FROM [SiteMap]  s
    left join user_menu u on s.ID=u.menu_id
    where u.users_code=@p_users and  Language=@p_language 
    union  
    SELECT [ID], [Title], [Description], [Url], [Roles], [Parent]
   from [SiteMap] where ( ID in (select distinct parent from SiteMap where ID in ( select menu_id from user_menu where users_code=@p_users))
   or ID=1) and Language=@p_language 
     ORDER BY [ID]
     
GO


/*
--PartNo Manager
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(1,'PartNo','PartNo Manager','main.aspx',null)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(10,'Input','PartNo Input','partno/input.aspx',1)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(12,'Search','PartNo Search','partno/partno.aspx',1)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(14,'IMG Upload','PartNo Image Upload','partno/uploadimg.aspx',1)

--BOM manager
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(2,'BOM','Bill of Material','main.aspx',null)
--insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
--     values(22,'Comp Input','Component Input','bom/cinput.aspx',2)
--insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
--     values(24,'Comp Search','Component Search','bom/scomponent.aspx',2)     
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(26,'Bom Input','BOM Input','bom/input.aspx',2)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(28,'BOM Search','BOM Search','bom/sbom.aspx',2)
--insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
--     values(210,'Bom Copy','BOM Copy','bom/copyto.aspx',2)

--Supply Manager
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(3,'Supply','Supply manager','main.aspx',null)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(30,'Input','Supply input','supply/input.aspx',3)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(32,'Search','Supply Search','supply/ssupply.aspx',3)

--Warehouse
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(4,'Warehouse','Warehouse manager','main.aspx',null)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(40,'Input','Warehouse Product Receiving List  Input','warehouse/input.aspx',4)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(42,'Receipt Check','Warehouse Product Receiving List Edit','warehouse/search.aspx',4)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(44,'Inbound','Supply Search','warehouse/inbound.aspx',4)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(46,'Inventory','Supply Search','warehouse/inventory.aspx',4)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(48,'Min&Max Set','Minimun set Set','warehouse/minormaxset.aspx',4)

--Client Manager
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(6,'Client','Client manager','main.aspx',null)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(60,'Input','Client input','client/input.aspx',6)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(62,'Search','Client Search','client/sclient.aspx',6)

--System Manager
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(99,'System','System manager','main.aspx',null)
insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
     values(990,'Accessories','Add Accessories information','ddefault.aspx',99)
--insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
--     values(991,'Add User','User input','system/input.aspx',99)
--insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
--     values(992,'User Search','User Search','system/search.aspx',99)
--insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
--     values(994,'User Right','User Search','system/userright.aspx',99)
--insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
--     values(996,'Category','Category Management','system/category.aspx',99)

*/