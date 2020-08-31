--Q1
CREATE DATABASE Dossier1
GO
USE Dossier1
GO
CREATE TABLE Medicament(
NumMedicament INT NOT NULL,
designation NVARCHAR(255),
forme NVARCHAR(255),
datePeremption DATE ,
StockActuel INT,
StockMin INT,
CONSTRAINT PK_Medicament PRIMARY KEY (NumMedicament),
)
GO
CREATE TABLE Medecin(
NumMedecin INT NOT NULL,
NomMd NVARCHAR(255),
PrenomMd NVARCHAR(255),
Specialité NVARCHAR(255),
loginMd NVARCHAR(255) UNIQUE,
passMd NVARCHAR(255),
CONSTRAINT PK_Medecin PRIMARY KEY (NumMedecin),
)
GO
CREATE TABLE Pharmacien(
NumPh INT NOT NULL,
NomPh NVARCHAR(255),
PrenomPh NVARCHAR(255),
loginPh NVARCHAR(255) UNIQUE,
passPh NVARCHAR(255),
CONSTRAINT PK_Pharmacien PRIMARY KEY (NumPh),
)
GO
CREATE TABLE Patient(
NumPatient INT NOT NULL,
nomP NVARCHAR(255),
prenomP NVARCHAR(255),
DateNaissance DATE,
CONSTRAINT PK_Patient PRIMARY KEY (NumPatient),
)
GO
CREATE TABLE Ordonnance(
NumOrdonnance INT NOT NULL IDENTITY(1,1),
NumPatient INT NOT NULL,
NumMedecin INT NOT NULL,
DateOrdonnance DATE,
CONSTRAINT PK_Ordonnance PRIMARY KEY (NumOrdonnance),
CONSTRAINT FK_Ordonnance_Patient FOREIGN KEY (NumPatient) REFERENCES Patient(NumPatient),
CONSTRAINT FK_Ordonnance_Medecin FOREIGN KEY (NumMedecin) REFERENCES Medecin(NumMedecin),
)
GO
CREATE TABLE DetailOrdonnance(
NumOrdonnance INT NOT NULL,
NumMedicament INT NOT NULL,
QttePrescrite INT,
CONSTRAINT PK_DetailOrdonnance PRIMARY KEY (NumOrdonnance,NumMedicament),
CONSTRAINT FK_DetailOrdonnance_Ordonnance FOREIGN KEY (NumOrdonnance) REFERENCES Ordonnance(NumOrdonnance),
CONSTRAINT FK_DetailOrdonnance_Medicament FOREIGN KEY (NumMedicament) REFERENCES Medicament(NumMedicament),
)
GO
INSERT INTO Medicament VALUES (1,'Med 1','Sirop',DATEADD(YEAR,2,GETDATE()),20,5),(2,'Med 2','Comprimes',DATEADD(YEAR,2,GETDATE()),30,5),(3,'Med 3','Injection',DATEADD(YEAR,2,GETDATE()),10,5)
INSERT INTO Medecin VALUES (1,'Md 1','Pren 1','cardiologue','MD1','MD123456'),(2,'Md 2','Pren 2','Ophtalmologue','MD2','MD123456'),(3,'Md 3','Pren 3','cardiologue','MD3','MD123456')
INSERT INTO Pharmacien VALUES (1,'PH 1','Pren 1','PH1','PH123456'),(2,'PH 2','Pren 2','PH2','PH123456'),(3,'PH 3','Pren 3','PH3','PH123456')
INSERT INTO Patient VALUES (1,'PH 1','Pren 1',DATEADD(YEAR,-21,GETDATE())),(2,'PH 2','Pren 2',DATEADD(YEAR,-23,GETDATE())),(3,'PH 3','Pren 3',DATEADD(YEAR,-24,GETDATE()))
INSERT INTO Ordonnance VALUES (1,1,GETDATE()),(2,1,GETDATE())
INSERT INTO DetailOrdonnance VALUES(1,1,3), (1,2,1),(1,3,5),(2,3,2)
GO
--Q2
ALTER TABLE Medicament ADD CONSTRAINT CHK_Forme CHECK (forme = 'Comprimes' OR forme =  'Gélules' OR forme = 'Sirop' OR forme = 'Spray' OR forme ='Pommade' OR forme = 'Injection')
ALTER TABLE Medicament ADD CONSTRAINT CHK_STK CHECK (StockActuel >= StockMin)
ALTER TABLE Medecin ADD CONSTRAINT CHK_MDP CHECK (passMd IS NOT NULL)
ALTER TABLE Pharmacien ADD CONSTRAINT CHK_MDPPH CHECK (passPh IS NOT NULL)
--Q3
SELECT TOP 5  M.designation,SUM(D.QttePrescrite) AS [Qte Consomme] FROM Medicament M,DetailOrdonnance D WHERE M.NumMedicament = D.NumMedicament GROUP BY M.designation  ORDER BY SUM(D.QttePrescrite) DESC
GO
--Q4
CREATE FUNCTION dbo.F_NbOrdMed(@idMd INT)
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(NumOrdonnance) FROM Ordonnance WHERE NumMedecin = @idMd)
END
GO
--Q5
CREATE PROCEDURE dbo.PS_LsMed(@sp NVARCHAR(255))
AS
BEGIN
	SELECT M.NomMd,M.PrenomMd FROM Medecin M,Ordonnance O 
	WHERE O.NumMedecin = M.NumMedecin AND M.Specialité = @sp 
	AND DATEPART(MONTH,O.DateOrdonnance) = DATEPART(MONTH,GETDATE()) 
	AND DATEPART(YEAR,O.DateOrdonnance) = DATEPART(YEAR,GETDATE()) 
	GROUP BY M.NomMd,M.PrenomMd 
	HAVING COUNT(NumOrdonnance)>50
END
GO
--Q6
CREATE TRIGGER T_Med ON DetailOrdonnance INSTEAD OF INSERT 
AS
BEGIN
	DECLARE @idP INT, @idMed INT, @date Date,@qte INT
	SET @date = (SELECT DateOrdonnance FROM Ordonnance WHERE NumOrdonnance = (SELECT NumOrdonnance FROM inserted))
	SET @idP =(SELECT NumPatient FROM Ordonnance WHERE NumOrdonnance = (SELECT NumOrdonnance FROM inserted))
	SET @idMed = (SELECT NumMedicament FROM inserted)
	SET @qte = (SELECT SUM(D.QttePrescrite) FROM Ordonnance O ,Patient P,DetailOrdonnance D 
	WHERE O.NumPatient = P.NumPatient 
	AND O.NumOrdonnance = D.NumOrdonnance 
	AND D.NumMedicament = @idMed
	AND DATEPART(MONTH,O.DateOrdonnance) = DATEPART(MONTH,@date)
	AND DATEPART(YEAR,O.DateOrdonnance) = DATEPART(YEAR,@date) )
	IF(@qte+(SELECT QttePrescrite FROM inserted)<=20)
	BEGIN
		INSERT INTO DetailOrdonnance SELECT * FROM inserted
		UPDATE Medicament SET StockActuel = StockActuel- (SELECT QttePrescrite FROM inserted) WHERE NumMedicament = @idMed
	END
END
GO
--Q7
CREATE PROCEDURE dbo.PS_DeductStkMin(@taux FLOAT)
AS
BEGIN
	UPDATE Medicament SET StockMin = StockMin-(StockMin*@taux) WHERE NumMedicament NOT IN (SELECT NumMedicament FROM DetailOrdonnance)
END




	