-----------------------/dossier 1 /question 1
--creation database
create database EFF2015_Pratique_v1_2
use EFF2015_Pratique_v1_2
--creation les tableaux
create table Syndic (
code_syndic int primary key,
nom_syndic nvarchar(50),
prenom_syndic nvarchar(50),
telephone_syndic nvarchar(50),
mot_depasse nvarchar(50)
)
create table Region (
code_region int primary key,
nom_region nvarchar(50),
population_region nvarchar(50),
total_region int default 0
)
create table Ville (
code_ville int primary key,
nom_ville nvarchar(50),
code_region int foreign key references Region(code_region)  ,
total_ville int default 0
) 
create table Quartier (
code_quartier int primary key,    
nom_quartier nvarchar(50),
population_quartier int,
code_ville int foreign key references Ville(code_ville) , 
total_quartier int default 0
)
create table Bien_immobilier (
code_bien int primary key,
adress_bien nvarchar(50),
num_enregistrement int,
superficie int , 
type_bien nvarchar(50),
code_Quartier int foreign key references Quartier(code_Quartier),
date_construction datetime
)
create table Contrat (
numcontrat int primary key,
datecontrat datetime ,
prix_mensuel float ,
code_bien int foreign key references Bien_immobilier(code_bien) ,
code_syndic int foreign key references Syndic(code_syndic),
etat nvarchar(50)
)


--insertion dans les tableaux
select * from Syndic
insert into Syndic values( 1,'nom_syndic1','prenom_syndic1','+212610977788','0105sd')
insert into Syndic values( 2,'nom_syndic2','prenom_syndic2','+212610977787','nj34')
insert into Syndic values( 3,'nom_syndic3','prenom_syndic3','+212699977788','1542')
--
select * from Region
insert into Region(code_region,nom_region ,population_region) values( 1,'sous massa','151243') --hint had table fih champs total_region default 0
insert into Region(code_region,nom_region ,population_region) values( 2,'casa','5222221')
insert into Region(code_region,nom_region ,population_region) values(3,'nord','77743')
--
select * from Ville
insert into Ville(code_ville,nom_ville,code_region) values( 1,'agadir',1) --hint had table fih champs total_ville default 0
insert into Ville(code_ville,nom_ville,code_region) values( 2,'inzigan',2)
insert into Ville(code_ville,nom_ville,code_region) values( 4,'casa',4)
insert into Ville(code_ville,nom_ville,code_region) values( 3,'taddart',3)
--
select * from Quartier
insert into Quartier(code_quartier,nom_quartier,population_quartier,code_ville) values( 1,'nom_quartier1',30,1) --hint had table fih champs total_quartier default 0
insert into Quartier(code_quartier,nom_quartier,population_quartier,code_ville)  values( 2,'nom_quartier2',40,2)
insert into Quartier(code_quartier,nom_quartier,population_quartier,code_ville)  values( 3,'nom_quartier3',10,3)
--
select * from Bien_immobilier
insert into Bien_immobilier values( 1,'adress_bien1',1,1,'type_bien1',1,'2015/12/12')
insert into Bien_immobilier values( 2,'adress_bien2',2,2,'type_bien1',2,'2015/12/11')
insert into Bien_immobilier values( 3,'adress_bien3',3,3,'type_bien1',3,'2015/12/10')
--
select * from Contrat
insert into Contrat values( 1,'2015/12/12',1000,1,1,'etat1')
insert into Contrat values( 2,'2015/12/04',1000,2,2,'etat2')
insert into Contrat values( 3,'2015/12/05',1000,3,3,'etat3')
-----------------------/dossier 1 /question 2
select sum(q.total_quartier) as chifre_total
from Ville as v,Quartier as q,Bien_immobilier as b
where(v.code_ville=q.code_ville) and(q.code_quartier=b.code_Quartier)
and(b.type_bien='californie') and(v.nom_ville='casa')