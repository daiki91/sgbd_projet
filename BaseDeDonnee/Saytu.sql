-- Active: 1712455733471@@192.168.0.10@3306@Saytu
CREATE TABLE Departements(
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                nom VARCHAR(50) NOT NULL,
                CONSTRAINT un_nom UNIQUE(nom)
)ENGINE=NDBCLUSTER;
INSERT INTO Departements (nom) VALUES ('Informatique');

CREATE TABLE Classes(
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                nom VARCHAR(50) NOT NULL,
                departement INT NOT NULL,
                CONSTRAINT un_nom UNIQUE(nom),
                CONSTRAINT fk_departement FOREIGN KEY(departement) REFERENCES Departements(id)
)ENGINE=NDBCLUSTER;
INSERT INTO Classes(nom,departement) VALUES('GLSIB','1');

CREATE TABLE Utilisateurs(
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                numero VARCHAR(10) NOT NULL,
                passwd VARCHAR(256) NOT NULL, 
                mail VARCHAR(200) NOT NULL,
                telephone VARCHAR(20) NOT NULL,
                prenom VARCHAR(200) NOT NULL,
                nom VARCHAR(200) NOT NULL,
                classe INT NOT NULL,
                departement INT NOT NULL,
                CONSTRAINT un_numero UNIQUE(numero),
                CONSTRAINT un_mail UNIQUE(mail),
                CONSTRAINT un_telephone UNIQUE(telephone),
                CONSTRAINT fk_classe FOREIGN KEY(classe) REFERENCES Classes(id),
                CONSTRAINT fk_departement_Utilisateurs FOREIGN KEY(departement) REFERENCES Departements(id)
)ENGINE=NDBCLUSTER;

INSERT INTO Utilisateurs(numero, passwd, mail, telephone, prenom, nom, classe,departement) VALUES 
('2021AS2', SHA2('Passer', 256), 'massina@gmail.com', '221775753051', 'Massina', 'bassene', 1,1),
('2021BS2', SHA2('Passer', 256), 'alassane@gmail.com', '221775753052', 'Alassane', 'SARR', 1,1),
('2021CS2', SHA2('Passer', 256), 'arphan@gmail.com', '221775753053', 'Arphan', 'BODIAN', 1,1),
('2021DS2', SHA2('Passer', 256), 'simon@gmail.com', '221775753054', 'Simon', 'KAMATE', 1,1),
('2021ES2', SHA2('Passer', 256), 'momar@gmail.com', '221775753055', 'Momar', 'DIENG', 1,1);

-- drop table Utilisateurs;
-- drop table Classes;
-- drop table Departements;
-- drop table Roles;
-- drop table uRoles;

desc Utilisateurs;
SELECT * FROM Utilisateurs;

CREATE TABLE Roles(
                 id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                 nom VARCHAR(200) NOT NULL,
                 CONSTRAINT un_nom_role UNIQUE(nom)
)ENGINE=NDBCLUSTER;

INSERT INTO Roles(nom) VALUES
                ('admin'),
                ('etudiant'),
                ('enseignant'),
                ('respClasse'),
                ('membreCommissionPeda'),
                ('estDedie'),
                ('respPeda'),
                ('chefDep'),
                ('directeurEtude');


CREATE TABLE uRoles(
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                utilisateur INT NOT NULL,
                role INT NOT NULL,
                CONSTRAINT fk_utilisateur_uRole FOREIGN KEY(utilisateur) REFERENCES Utilisateurs(id),
                CONSTRAINT fk_role_uRole FOREIGN KEY(role) REFERENCES Roles(id)
)ENGINE=NDBCLUSTER;
INSERT INTO uRoles(utilisateur,role) VALUES 
                (1,1),
                (1,2),
                (1,3),
                (1,4),
                (1,5),
                (1,6),
                (1,7),
                (1,8),
                (1,9);

CREATE TABLE UE(
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                nom VARCHAR(200) NOT NULL,
                CONSTRAINT un_nom_UE UNIQUE(nom)
)ENGINE=NDBCLUSTER;

INSERT INTO UE(nom) VALUES
                ("Formation Humaine 1"),
                ("Formation Scientifique"),
                ("Algorithme et Langages Avancés 1"),
                ("Système et Réseaux 1"),
                ("Gestion de Données"),
                ("Ingénierie Logiciel 1");

CREATE TABLE EC(
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                nom VARCHAR(200) NOT NULL,
                ue INT NOT NULL,
                enseignant INT NOT NULL,                
                CONSTRAINT un_nom_EC UNIQUE(nom),
                CONSTRAINT fk_ue_EC FOREIGN KEY(ue) REFERENCES UE(id),
                CONSTRAINT fk_enseignant_EC FOREIGN KEY(enseignant) REFERENCES Utilisateurs(id)
)ENGINE=NDBCLUSTER;

INSERT INTO EC(nom, ue, enseignant) VALUES
                ("Anglais Technique",1, 1),
                ("Aspects Juridiques et Ethique des TIC",1, 2),
                ("Technique d expression ",1, 3),
                ("Recherche Opérationnelle", 2, 4),
                ("Probabilités et Statistiques", 2, 5);

CREATE TABLE Evaluations(
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                avis VARCHAR(1000) NOT NULL,
                etudiant INT NOT NULL,
                ec INT NOT NULL,
                CONSTRAINT fk_ec_Evaluation FOREIGN KEY(ec) REFERENCES EC(id),
                CONSTRAINT fk_etudiant_EC FOREIGN KEY(etudiant) REFERENCES Utilisateurs(id)
)ENGINE=NDBCLUSTER;
INSERT INTO Evaluations(avis,etudiant,ec) VALUES
                ("Rien à signaler", 1, 1),
                ("Rien à signaler1", 1, 2),
                ("Rien à signaler2", 1, 3),
                ("RAS", 2, 1);

CREATE TABLE RapportDepDir(
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                avis VARCHAR(1500) NOT NULL,
                de INT NOT NULL,
                cd INT NOT NULL,
                CONSTRAINT fk_de_RapportDepDir FOREIGN KEY(de) REFERENCES Utilisateurs(id),
                CONSTRAINT fk_cd_RapportDepDir FOREIGN KEY(cd) REFERENCES Utilisateurs(id)
)ENGINE=NDBCLUSTER;
INSERT INTO RapportDepDir(avis, de, cd) VALUES
                ("RAS pour les cours",1, 1),
                ("RAS pour les cours",1, 2),
                ("RAS pour les cours",1, 3),
                ("RAS pour les cours",1, 4);

CREATE TABLE PV(
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                avis VARCHAR(1500) NOT NULL,
                mc INT NOT NULL,
                cd INT NOT NULL,
                rapportDepDir INT NOT NULL,
                CONSTRAINT fk_mc_PV FOREIGN KEY(mc) REFERENCES Utilisateurs(id),
                CONSTRAINT fk_cd_PV FOREIGN KEY(cd) REFERENCES Utilisateurs(id),
                CONSTRAINT fk_rapportDepDir_PV FOREIGN KEY(rapportDepDir) REFERENCES RapportDepDir(id)
)ENGINE=NDBCLUSTER;
INSERT INTO PV(avis, mc, cd,rapportDepDir) VALUES
                ("RAS obs",2, 1,1),
                ("RAS Obs",2, 2,1),
                ("RAS Obs",2, 3,1),
                ("RAS Obs",2, 4,1);

CREATE TABLE RapportRespCom(
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                avis VARCHAR(1500) NOT NULL,
                mc INT NOT NULL,
                rp INT NOT NULL,
                pv INT NOT NULL,
                CONSTRAINT fk_mc_RapportRespCom FOREIGN KEY(mc) REFERENCES Utilisateurs(id),
                CONSTRAINT fk_rp_RapportRespCom FOREIGN KEY(rp) REFERENCES Utilisateurs(id),
                CONSTRAINT fk_pv_RapportRespCom FOREIGN KEY(pv) REFERENCES PV(id)
)ENGINE=NDBCLUSTER;

INSERT INTO RapportRespCom(avis,mc,rp,pv) VALUES
                ("RAS obs",2,1,1),
                ("RAS Obs",2,2,1),
                ("RAS Obs",2,3,1),
                ("RAS Obs",2,4,1);

CREATE TABLE Chapitres(
                id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                nom VARCHAR(100) NOT NULL,
                dateDeb DATE NOT NULL,
                dateFin DATE NOT NULL,
                ec INT NOT NULL,
                CONSTRAINT fk_ec_Chapitres FOREIGN KEY(ec) REFERENCES EC(id)
)ENGINE=NDBCLUSTER;

INSERT INTO Chapitres(nom,dateDeb, dateFin,ec) VALUES 
                ("Chapitre 1 : ", CURRENT_DATE, CURRENT_DATE, 1),
                ("Chapitre 2 : ", CURRENT_DATE, CURRENT_DATE, 1),
                ("Chapitre 1 : ", CURRENT_DATE, CURRENT_DATE, 2),
                ("Chapitre 2 : ", CURRENT_DATE, CURRENT_DATE, 2),
                ("Chapitre 1 : ", CURRENT_DATE, CURRENT_DATE, 3);


