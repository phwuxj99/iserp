

INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (11, '退出', '退出', 'admin/logout.aspx', '*',11,'zh-CN')

--PartNo Manager
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (1100, '物料编号', NULL, NULL, '*',11,'zh-CN')

--INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
--     values(1,'PartNo','PartNo Manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1101,'物料编号输入','输入新的物料编号','partno/input.aspx',1100,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1102,'物料编号查询','物料编号查询','partno/partno.aspx',1100,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1104,'图片上载','物料编号图片上载','partno/uploadimg.aspx',1100,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1107,'批量转入物料编号','批量转入物料编号','partno/uploadpartno.aspx',1100,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1109,'物料编号图片预览','物料编号图片预览','partno/partnoviewpic.aspx',1100,'zh-CN')

--BOM manager

INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (1200, '材料明细表', NULL, NULL, '*',11,'zh-CN')

--INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
--     values(2,'BOM','Bill of Material','main.aspx',null)
--insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
--     values(22,'Comp Input','Component Input','bom/cinput.aspx',2)
--insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
--     values(24,'Comp Search','Component Search','bom/scomponent.aspx',2)     
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1206,'材料明细表清单输入','材料明细表清单输入','bom/input.aspx',1200,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1208,'材料明细表清单查询','材料明细表清单查询','bom/sbom.aspx',1200,'zh-CN')
--insert sys_menu(menu_id,m_name,m_description,m_link,parent_id)
--     values(210,'Bom Copy','BOM Copy','bom/copyto.aspx',2)

--Supply Manager
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (1300, '供应商管理', NULL, NULL, '*',11,'zh-CN')

--INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
--     values(3,'Supply','Supply manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1301,'增加新供应商','增加新供应商','supply/input.aspx',1300,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1302,'供应商查询','供应商查询','supply/ssupply.aspx',1300,'zh-CN')

--Warehouse
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (1400, '库存量管理', NULL, NULL, '*',11,'zh-CN')

--INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
--     values(4,'Warehouse','Warehouse manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1401,'仓库订单输入 ','仓库订单输入','warehouse/input.aspx',1400,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1402,'仓库订单查询','仓库订单查询','warehouse/search.aspx',1400,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1404,'入库输入','入库输入','warehouse/inbound.aspx',1400,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1406,'库存查询','库存查询','warehouse/inventory.aspx',1400,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1408,'库存最大最小值设定','库存最大最小值设定','warehouse/minormaxset.aspx',1400,'zh-CN')

--Client Manager
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (1500, '客户管理', NULL, NULL, '*',11,'zh-CN')

--INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
--     values(6,'Client','Client manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1501,'增加新客户','增加新客户','client/input.aspx',1500,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1502,'客户查询','客户查询','client/sclient.aspx',1500,'zh-CN')

--Purchase Order Manager
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (1600, '客户订单', NULL, NULL, '*',11,'zh-CN')

--INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
--     values(6,'Client','Client manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1601,'客户订单输入','客户订单输入','PO/input.aspx',1600,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1602,'客户订单查询','客户订单查询','PO/POSearch.aspx',1600,'zh-CN')

--Invoice Manager
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (1700, '发票管理', NULL, NULL, '*',11,'zh-CN')

--INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
--     values(6,'Client','Client manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1701,'发票输入','发票输入','Invoice/input.aspx',1700,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1702,'发票查询','发票查询','Invoice/sinvoice.aspx',1700,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1704,'发票打印','发票打印','Invoice/CrystalINV.aspx',1700,'zh-CN')

--System Manager
INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
VALUES (1900, '杂项管理', NULL, NULL, '*',11,'zh-CN')

--INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
--     values(99,'System','System manager','main.aspx',null)
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1901,'物料编号类别管理','物料编号类别管理','ddefault.aspx',1900,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1905,'用户激活','用户激活','admin/activeuser.aspx',1900,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1910,'用户菜单设置','用户菜单设置','admin/usermenuset.aspx',1900,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1915,'修改密码','修改密码','admin/usersChgPWD.aspx',1900,'zh-CN')
INSERT INTO SiteMap (ID, Title, Description, Url,  Parent,[Language])
     values(1920,'用户登录记录','用户登录记录','admin/loginhist.aspx',1900,'zh-CN')



--INSERT INTO SiteMap (ID, Title, Description, Url, Roles, Parent,[Language])
--VALUES (1000, 'Logout', NULL, 'admin/logout.aspx', '*',1,'zh-CN')


go
