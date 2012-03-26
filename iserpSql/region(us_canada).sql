----------------------------------------------------------------------
----------------------------------------------------------------------
if exists (select * from sysobjects where name = 'location_region' and type = 'U')
     drop table location_region
  go
create table dbo.location_region
(
 id_num                 int identity         not null,
 country                varchar(35),
 region                 varchar(35),
 abbreviation           char(55),
 city                   char(150),
 flag                   int default 1,
 note                   char(253), 
)
go
create unique index location_region_country_region on location_region(country,region) with ignore_dup_key
go


insert location_region(country,flag)   values('USA','0')
insert location_region(country,flag)   values('CANADA','0')

----------------------------------------------------------------------
----------------------------------------------------------------------
insert location_region(country,region,abbreviation)   values('USA','Alabama','AL')
insert location_region(country,region,abbreviation)   values('USA','Alaska','AK')
insert location_region(country,region,abbreviation)   values('USA','Arizona','AZ')
insert location_region(country,region,abbreviation)   values('USA','Arkansas','AR')
insert location_region(country,region,abbreviation)   values('USA','California','CA')
insert location_region(country,region,abbreviation)   values('USA','Colorado','CO')
insert location_region(country,region,abbreviation)   values('USA','Connecticut','CT')
insert location_region(country,region,abbreviation)   values('USA','Delaware','DE')
insert location_region(country,region,abbreviation)   values('USA','Florida','DC')
insert location_region(country,region,abbreviation)   values('USA','Georgia','FL')
insert location_region(country,region,abbreviation)   values('USA','Hawaii','GA')
insert location_region(country,region,abbreviation)   values('USA','Idaho','HI')
insert location_region(country,region,abbreviation)   values('USA','Illinois','ID')
insert location_region(country,region,abbreviation)   values('USA','Indiana','IL')
insert location_region(country,region,abbreviation)   values('USA','Iowa','IN')
insert location_region(country,region,abbreviation)   values('USA','Kansas','IA')
insert location_region(country,region,abbreviation)   values('USA','Kentucky','KS')
insert location_region(country,region,abbreviation)   values('USA','Louisiana','KY')
insert location_region(country,region,abbreviation)   values('USA','Maine','LA')
insert location_region(country,region,abbreviation)   values('USA','Maryland','ME')
insert location_region(country,region,abbreviation)   values('USA','Massachusetts','MD')
insert location_region(country,region,abbreviation)   values('USA','Michigan','MA')
insert location_region(country,region,abbreviation)   values('USA','Minnesota','MI')
insert location_region(country,region,abbreviation)   values('USA','Mississippi','MN')
insert location_region(country,region,abbreviation)   values('USA','Missouri','MS')
insert location_region(country,region,abbreviation)   values('USA','Montana','MO')
insert location_region(country,region,abbreviation)   values('USA','Nebraska','MT')
insert location_region(country,region,abbreviation)   values('USA','Nevada','NE')
insert location_region(country,region,abbreviation)   values('USA','New Hampshire','NV')
insert location_region(country,region,abbreviation)   values('USA','New Jersey','NH')
insert location_region(country,region,abbreviation)   values('USA','New Mexico','NJ')
insert location_region(country,region,abbreviation)   values('USA','New York','NM')
insert location_region(country,region,abbreviation)   values('USA','North Carolina','NY')
insert location_region(country,region,abbreviation)   values('USA','North Dakota','ND')
insert location_region(country,region,abbreviation)   values('USA','Ohio','OH')
insert location_region(country,region,abbreviation)   values('USA','Oklahoma','OK')
insert location_region(country,region,abbreviation)   values('USA','Oregon','OR')
insert location_region(country,region,abbreviation)   values('USA','Pennsylvania','PA')
insert location_region(country,region,abbreviation)   values('USA','Rhode Island','PR')
insert location_region(country,region,abbreviation)   values('USA','South Carolina','RI')
insert location_region(country,region,abbreviation)   values('USA','South Dakota','SC')
insert location_region(country,region,abbreviation)   values('USA','Tennessee','SD')
insert location_region(country,region,abbreviation)   values('USA','Texas','TN')
insert location_region(country,region,abbreviation)   values('USA','Utah','TX')
insert location_region(country,region,abbreviation)   values('USA','Vermont','UT')
insert location_region(country,region,abbreviation)   values('USA','Virginia','VT')
insert location_region(country,region,abbreviation)   values('USA','Washington','VA')
insert location_region(country,region,abbreviation)   values('USA','Washington, D.C.','WA')
insert location_region(country,region,abbreviation)   values('USA','West Virginia','WI')
insert location_region(country,region,abbreviation)   values('USA','Wisconsin','WV')
insert location_region(country,region,abbreviation)   values('USA','Wyoming','WY')
insert location_region(country,region,abbreviation)   values('CANADA','Alberta                     ','AB')
insert location_region(country,region,abbreviation)   values('CANADA','British Columbia            ','BC')
insert location_region(country,region,abbreviation)   values('CANADA','Manitoba                    ','MB')
insert location_region(country,region,abbreviation)   values('CANADA','New Brunswick               ','NB')
insert location_region(country,region,abbreviation)   values('CANADA','Newfoundland and Labrador   ','NF')
insert location_region(country,region,abbreviation)   values('CANADA','Northwest Territories       ','NT')
insert location_region(country,region,abbreviation)   values('CANADA','Nova Scotia                 ','NS')
insert location_region(country,region,abbreviation)   values('CANADA','Nunavut                     ','NU')
insert location_region(country,region,abbreviation)   values('CANADA','Ontario                     ','ON')
insert location_region(country,region,abbreviation)   values('CANADA','Prince Edward Island        ','PE')
insert location_region(country,region,abbreviation)   values('CANADA','Quebec                      ','QC')
insert location_region(country,region,abbreviation)   values('CANADA','Saskatchewan                ','SK')
insert location_region(country,region,abbreviation)   values('CANADA','Yukon Territory             ','YT')
go 
