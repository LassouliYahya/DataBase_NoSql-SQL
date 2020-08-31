create database GestionLogement
use GestionLogement

create table TypeLogement(
idType int primary key  on delete cascade on update cascade,
libelle nvarchar(50) check(libelle in('villa','appartement','bungalow') )
) 
create table Logement(
idLogement int primary key,
libelle nvarchar(50),
prixLoyer float,
idType int references TypeLogement(idType) on delete cascade on update cascade
) 
create table Personne(
idPersonne int primary key,
nomPersonne nvarchar(50),
prenomPersonne nvarchar(50),
emailPersonne nvarchar(50),
mdpPersonne nvarchar(50)
)
create table Louer(
idLouer int primary key,
idPersonne  int  references Personne(idPersonne) on delete cascade on update cascade,
idLogement  int  references Logement(idLogement) on delete cascade on update cascade,
dataArrivee date,
dateSortie date,
dureeLocation int,
montanTotal float
)
create table Degats(
idDegats int primary key,
idLouer  int  references Louer(idLouer) on delete cascade on update cascade,
descriptionDegats nvarchar(50),
coutEstime float
)

insert into TypeLogement values (1,'villa')
insert into TypeLogement values (2,'appartement')
insert into TypeLogement values (3,'villa')
insert into TypeLogement values (4,'bungalow')

insert into Logement values (1,'villa',200,1)
insert into Logement values (2,'appartement',150,2)
insert into Logement values (3,'villa',150,3)
insert into Logement values (4,'bungalow',100,4)


insert into Personne values (1,'ali','iro','ali@gmail.com','ali123')
insert into Personne values (2,'ali2','iro2','ali2@gmail.com','ali1223')
insert into Personne values (3,'ahmed3','ahmediro4','ahmed4@gmail.com','ahmed333')
insert into Personne values (4,'ahmed4','ahmediro4','ahmed4@gmail.com','ahmed444')


insert into Louer values (1,1,1,'2019/10/10','2019/10/20',10,2000)
insert into Louer values (2,2,2,'2019/11/10','2019/11/20',10,1500)
insert into Louer values (3,3,3,'2019/11/10','2019/11/20',10,1500)
insert into Louer values (4,4,4,'2019/11/10','2019/11/20',10,1000)

insert into Degats values (1,1,'simple',150)
insert into Degats values (2,2,'simple',100)
insert into Degats values (3,3,'simple',100)


select * from TypeLogement
select * from Logement
select * from Personne
select * from Louer
select * from Degats