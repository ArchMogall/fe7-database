/*------FIRE EMBLEM: BLAZING BLADE - a not-quite-exhaustive database------

-----------------------------By Angela Enns-------------------------------

------------------------(Fire Emblem © Nintendo)--------------------------*/




USE master;
CREATE DATABASE FireEmblem;
GO

USE FireEmblem;
GO




--CREATING THE SCHEMAS

CREATE SCHEMA Inventory;
GO

CREATE SCHEMA Units;
GO

CREATE SCHEMA Chapters;
GO





--CREATING THE TABLES

CREATE TABLE Inventory.WeaponTypes (
    TypeID int IDENTITY NOT NULL,
    Name varchar(15) NOT NULL,
	CONSTRAINT PkWeaponTypes PRIMARY KEY (TypeID),
	CONSTRAINT UqWeaponType UNIQUE (Name)
);

CREATE TABLE Inventory.WeaponElements (
    ElementID int IDENTITY NOT NULL,
    Name varchar(15) NOT NULL,
	CONSTRAINT PkWeaponElements PRIMARY KEY (ElementID),
	CONSTRAINT UqWeaponElement UNIQUE (Name)
);

CREATE TABLE Inventory.WeaponEffects (
	EffectID int IDENTITY NOT NULL,
	Description varchar(100) NOT NULL,
	CONSTRAINT PkWeaponEffects PRIMARY KEY (EffectID)
);

CREATE TABLE Inventory.ItemEffects (
	EffectID int IDENTITY NOT NULL,
	Description varchar(100) NOT NULL,
	CONSTRAINT PkItemEffects PRIMARY KEY (EffectID)
);

CREATE TABLE Units.ClassNotes (
	NoteID int IDENTITY NOT NULL,
	Description varchar(50) NOT NULL,
	CONSTRAINT PkClassNotes PRIMARY KEY (NoteID)
);

CREATE TABLE Units.Affinities (
	AffinityID int IDENTITY NOT NULL,
	Name varchar(10) NOT NULL,
	CONSTRAINT PkAffinities PRIMARY KEY (AffinityID),
	CONSTRAINT UqAffinity UNIQUE (Name)
);

CREATE TABLE Units.CharGrowthRates (
	GrowthRateID int IDENTITY NOT NULL,
	HP tinyint NOT NULL,
	StrengthMagic tinyint NOT NULL,
	Skill tinyint NOT NULL,
	Speed tinyint NOT NULL,
	Luck tinyint NOT NULL,
	Defense tinyint NOT NULL,
	Resistance tinyint NOT NULL,
	CONSTRAINT PkCharGrowthRates PRIMARY KEY (GrowthRateID)
);

CREATE TABLE Inventory.Items (
	ItemID int IDENTITY NOT NULL,
	Name varchar(25) NOT NULL,
	Uses tinyint,
	Cost int,
	CONSTRAINT PkItems PRIMARY KEY (ItemID)
);

CREATE TABLE Chapters.Notes (
	NoteID int IDENTITY NOT NULL,
	Description varchar(50) NOT NULL
	CONSTRAINT PkChapterNotes PRIMARY KEY (NoteID)
);

CREATE TABLE Chapters.Objectives (
	ObjectiveID int IDENTITY NOT NULL,
	Description varchar(50) NOT NULL,
	CONSTRAINT PkChapterObjectives PRIMARY KEY (ObjectiveID)
);

CREATE TABLE Chapters.Requirements (
	RequirementID int IDENTITY NOT NULL,
	Description varchar(150) NOT NULL,
	CONSTRAINT PkChapterRequirements PRIMARY KEY (RequirementID)
);

CREATE TABLE Chapters.ShopTypes (
	TypeID int IDENTITY NOT NULL,
	Name varchar(10) NOT NULL,
	CONSTRAINT PkShopTypes PRIMARY KEY (TypeID),
	CONSTRAINT UqShopType UNIQUE (Name)
);
GO

CREATE TABLE Inventory.Weapons (
    WeaponID int IDENTITY NOT NULL,
    Name varchar(25) NOT NULL,
	TypeID int NOT NULL,
	ElementID int,
	WeaponRank varchar(3),
	Uses tinyint,
	Weight tinyint,
	Might tinyint,
	Hit tinyint,
	Crit tinyint,
	Range varchar(15),
	Cost int,
	CONSTRAINT PkWeapons PRIMARY KEY (WeaponID),
	CONSTRAINT FkWeaponType FOREIGN KEY (TypeID)
		REFERENCES Inventory.WeaponTypes (TypeID)
		ON DELETE CASCADE,
	CONSTRAINT FkWeaponElement FOREIGN KEY (ElementID)
		REFERENCES Inventory.WeaponElements (ElementID)
		ON DELETE CASCADE,
	CONSTRAINT CkWeaponRank CHECK (WeaponRank IN ('E', 'D', 'C', 'B', 'A', 'S', 'Prf'))
);

CREATE TABLE Units.Classes (
    ClassID int IDENTITY NOT NULL,
    Name varchar(25) NOT NULL,
	Movement tinyint,
	CONSTRAINT PkClasses PRIMARY KEY (ClassID),
	CONSTRAINT UqClass UNIQUE (Name)
);

CREATE TABLE Units.PromotionGains (
	GainID int IDENTITY NOT NULL,
	HP tinyint NOT NULL,
	StrengthMagic tinyint NOT NULL,
	Skill tinyint NOT NULL,
	Speed tinyint NOT NULL,
	Defense tinyint NOT NULL,
	Resistance tinyint NOT NULL,
	Movement tinyint NOT NULL,
	Constitution tinyint NOT NULL,
	Gender char(1),
	CONSTRAINT PkGains PRIMARY KEY (GainID),
	CONSTRAINT CkPromotionGainGender CHECK (Gender IN ('M', 'F'))
);
/*Some classes (Archer and Mage) have different promotion gains depending on
whether the promoting unit is male or female, hence the Gender column in PromotionGains.
Another way to handle this would've been to treat the male and female versions of these classes as separate classes,
but that seemed counter-intuitive.*/

CREATE TABLE Chapters.Chapters (
	ChapterID int IDENTITY NOT NULL,
	Name varchar(40) NOT NULL,
	ObjectiveID int NOT NULL,
	RequirementID int,
	CONSTRAINT PkChapters PRIMARY KEY (ChapterID),
	CONSTRAINT FkChapterObjective FOREIGN KEY (ObjectiveID)
		REFERENCES Chapters.Objectives (ObjectiveID)
		ON DELETE CASCADE,
	CONSTRAINT FkChapterReqs FOREIGN KEY (RequirementID)
		REFERENCES Chapters.Requirements (RequirementID),
	CONSTRAINT UqChapter UNIQUE (Name)
);
GO

CREATE TABLE Units.Promotions (
	PromotionID int IDENTITY NOT NULL,
	BaseClassID int,
	PromotedClassID int,
	GainID int,
	CONSTRAINT PkPromotions PRIMARY KEY (PromotionID),
	CONSTRAINT FkBaseClass FOREIGN KEY (BaseClassID)
		REFERENCES Units.Classes(ClassID)
		ON DELETE NO ACTION,
	CONSTRAINT FkPromotedClass FOREIGN KEY (PromotedClassID)
		REFERENCES Units.Classes (ClassID)
		ON DELETE NO ACTION,
	CONSTRAINT FkGain FOREIGN KEY (GainID)
		REFERENCES Units.PromotionGains (GainID)
		ON DELETE NO ACTION
);

CREATE TABLE Units.Characters (
	CharID int IDENTITY NOT NULL,
	Name varchar(15) NOT NULL,
	Gender char(1) NOT NULL,
	StartingClassID int NOT NULL,
	AffinityID int NOT NULL,
	GrowthRateID int NOT NULL,
	StartingLevel tinyint,
	BaseHP tinyint,
	BaseStrengthMagic tinyint,
	BaseSkill tinyint,
	BaseSpeed tinyint,
	BaseLuck tinyint,
	BaseDefense tinyint,
	BaseResistance tinyint,
	BaseConstitution tinyint,
	CONSTRAINT PkCharacters PRIMARY KEY (CharID),
	CONSTRAINT FkStartingClass FOREIGN KEY (StartingClassID)
		REFERENCES Units.Classes (ClassID)
		ON DELETE NO ACTION,
	CONSTRAINT FkAffinity FOREIGN KEY (AffinityID)
		REFERENCES Units.Affinities (AffinityID)
		ON DELETE CASCADE,
	CONSTRAINT FkCharGrowthRate FOREIGN KEY (GrowthRateID)
		REFERENCES Units.CharGrowthRates (GrowthRateID)
		ON DELETE CASCADE,
	CONSTRAINT CkCharacterGender CHECK (Gender IN ('M', 'F')),
	CONSTRAINT UqCharacter UNIQUE (Name)
);

CREATE TABLE Units.Bosses (
	BossID int IDENTITY NOT NULL,
	Name varchar(15) NOT NULL,
	ChapterID int NOT NULL,
	ClassID int NOT NULL,
	Level tinyint,
	HP tinyint,
	StrengthMagic tinyint,
	Skill tinyint,
	Speed tinyint,
	Luck tinyint,
	Defense tinyint,
	Resistance tinyint,
	Constitution tinyint,
	CONSTRAINT PkBosses PRIMARY KEY (BossID),
	CONSTRAINT FkBossChapter FOREIGN KEY (ChapterID)
		REFERENCES Chapters.Chapters (ChapterID)
		ON DELETE NO ACTION,
	CONSTRAINT FkBossClass FOREIGN KEY (ClassID)
		REFERENCES Units.Classes (ClassID)
		ON DELETE NO ACTION
);

CREATE TABLE Chapters.Shops (
	ShopID int IDENTITY NOT NULL,
	TypeID int NOT NULL,
	ChapterID int NOT NULL,
	CONSTRAINT PkShops PRIMARY KEY (ShopID),
	CONSTRAINT FkShopType FOREIGN KEY (TypeID)
		REFERENCES Chapters.ShopTypes (TypeID)
		ON DELETE CASCADE,
	CONSTRAINT FkShopChapter FOREIGN KEY (ChapterID)
		REFERENCES Chapters.Chapters (ChapterID)
		ON DELETE NO ACTION
);
GO

CREATE TABLE Units.Supports (
	SupportID int IDENTITY NOT NULL,
	Char1ID int NOT NULL,
	Char2ID int NOT NULL,
	StartingPoints tinyint,
	PointsPerTurn tinyint,
	CONSTRAINT PkSupports PRIMARY KEY (SupportID),
	CONSTRAINT FkSupportChar1 FOREIGN KEY (Char1ID)
		REFERENCES Units.Characters (CharID)
		ON DELETE NO ACTION,
	CONSTRAINT FkSupportChar2 FOREIGN KEY (Char2ID)
		REFERENCES Units.Characters (CharID)
		ON DELETE NO ACTION
);

--INTERSECT TABLES
--These are named by combining the names of the tables they link

--The intersect table linking Chapters.Shops and Inventory.Weapons
CREATE TABLE Chapters.ShopWeapons (
	ShopID int NOT NULL,
	WeaponID int NOT NULL,
	CONSTRAINT PkShopWeapons PRIMARY KEY (ShopID, WeaponID),
	CONSTRAINT FkSWShop FOREIGN KEY (ShopID)
		REFERENCES Chapters.Shops (ShopID)
		ON DELETE NO ACTION,
	CONSTRAINT FkShopWeapon FOREIGN KEY (WeaponID)
		REFERENCES Inventory.Weapons (WeaponID)
		ON DELETE NO ACTION
);

--The intersect table linking Chapters.Shops and Inventory.Items
CREATE TABLE Chapters.ShopItems (
	ShopID int NOT NULL,
	ItemID int NOT NULL,
	CONSTRAINT PkShopItems PRIMARY KEY (ShopID, ItemID),
	CONSTRAINT FkSIShop FOREIGN KEY (ShopID)
		REFERENCES Chapters.Shops (ShopID)
		ON DELETE NO ACTION,
	CONSTRAINT FkShopItem FOREIGN KEY (ItemID)
		REFERENCES Inventory.Items (ItemID)
		ON DELETE NO ACTION
);

--The intersect table linking Units.Classes and Inventory.WeaponTypes
CREATE TABLE Units.ClassWeaponTypes (
    ClassID int NOT NULL,
	TypeID int,
	CONSTRAINT PkClassWeaponTypes PRIMARY KEY (ClassID, TypeID),
	CONSTRAINT FkClasses FOREIGN KEY (ClassID)
		REFERENCES Units.Classes (ClassID)
		ON DELETE CASCADE,
	CONSTRAINT FkWType FOREIGN KEY (TypeID)
		REFERENCES Inventory.WeaponTypes (TypeID)
		ON DELETE NO ACTION
);

--The intersect table linking Inventory.WeaponEffects and Inventory.Weapons
CREATE TABLE Inventory.WeaponWeaponEffects (
	WeaponID int NOT NULL,
	EffectID int NOT NULL,
	CONSTRAINT PkWeaponWeaponEffects PRIMARY KEY (WeaponID, EffectID),
	CONSTRAINT FkEffect FOREIGN KEY (EffectID)
		REFERENCES Inventory.WeaponEffects (EffectID)
		ON DELETE CASCADE,
	CONSTRAINT FkWeapon FOREIGN KEY (WeaponID)
		REFERENCES Inventory.Weapons (WeaponID)
		ON DELETE NO ACTION
);

--The intersect table linking Inventory.ItemEffects and Inventory.Items
CREATE TABLE Inventory.ItemItemEffects (
	ItemID int NOT NULL,
	EffectID int NOT NULL,
	CONSTRAINT PkItemItemEffects PRIMARY KEY (ItemID, EffectID),
	CONSTRAINT FkItemEffect FOREIGN KEY (EffectID)
		REFERENCES Inventory.ItemEffects (EffectID)
		ON DELETE CASCADE,
	CONSTRAINT FkItem FOREIGN KEY (ItemID)
		REFERENCES Inventory.Items (ItemID)
		ON DELETE NO ACTION
);

--The intersect table linking Units.Classes and Units.ClassNotes
CREATE TABLE Units.ClassClassNotes (
	ClassID int NOT NULL,
	NoteID int NOT NULL,
	CONSTRAINT PkClassClassNotes PRIMARY KEY (ClassID, NoteID),
	CONSTRAINT FkClass FOREIGN KEY (ClassID)
		REFERENCES Units.Classes (ClassID)
		ON DELETE NO ACTION,
	CONSTRAINT FkNote FOREIGN KEY (NoteID)
		REFERENCES Units.ClassNotes (NoteID)
		ON DELETE CASCADE
);

--The intersect table linking Chapters.Chapters and Chapters.Notes
CREATE TABLE Chapters.ChapterNotes (
	ChapterID int NOT NULL,
	NoteID int NOT NULL,
	CONSTRAINT PkChapterChapterNotes PRIMARY KEY (ChapterID, NoteID),
	CONSTRAINT FkChapter FOREIGN KEY (ChapterID)
		REFERENCES Chapters.Chapters (ChapterID)
		ON DELETE NO ACTION,
	CONSTRAINT FkChapterNote FOREIGN KEY (NoteID)
		REFERENCES Chapters.Notes (NoteID)
		ON DELETE CASCADE
);
GO




--INDEXES

--Foreign keys
CREATE NONCLUSTERED INDEX IxWeapons_TypeID
ON Inventory.Weapons (TypeID);

CREATE NONCLUSTERED INDEX IxWeapons_ElementID
ON Inventory.Weapons (ElementID);

CREATE NONCLUSTERED INDEX IxClassPromotions_BaseClassID
ON Units.Promotions (BaseClassID);

CREATE NONCLUSTERED INDEX IxPromotions_PromotedClassID
ON Units.Promotions (PromotedClassID);

CREATE NONCLUSTERED INDEX IxPromotions_GainID
ON Units.Promotions (GainID);

CREATE NONCLUSTERED INDEX IxClassWeaponTypes_ClassID
ON Units.ClassWeaponTypes (ClassID);

CREATE NONCLUSTERED INDEX IxClassWeaponTypes_TypeID
ON Units.ClassWeaponTypes (TypeID);

CREATE NONCLUSTERED INDEX IxWeaponWeaponEffects_WeaponID
ON Inventory.WeaponWeaponEffects (WeaponID);

CREATE NONCLUSTERED INDEX IxWeaponWeaponEffects_EffectID
ON Inventory.WeaponWeaponEffects (EffectID);

CREATE NONCLUSTERED INDEX IxClassClassNotes_ClassID
ON Units.ClassClassNotes (ClassID);

CREATE NONCLUSTERED INDEX IxClassClassNotes_NoteID
ON Units.ClassClassNotes (NoteID);

CREATE NONCLUSTERED INDEX IxCharacters_StartingClassID
ON Units.Characters (StartingClassID);

CREATE NONCLUSTERED INDEX IxCharacters_AffinityID
ON Units.Characters (AffinityID);

CREATE NONCLUSTERED INDEX IxCharacters_GrowthRateID
ON Units.Characters (GrowthRateID);

CREATE NONCLUSTERED INDEX IxBosses_ChapterID
ON Units.Bosses (ChapterID);

CREATE NONCLUSTERED INDEX IxBosses_ClassID
ON Units.Bosses (ClassID);

CREATE NONCLUSTERED INDEX IxSupports_Char1ID
ON Units.Supports (Char1ID);

CREATE NONCLUSTERED INDEX IxSupports_Char2ID
ON Units.Supports (Char2ID);

CREATE NONCLUSTERED INDEX IxItemItemEffects_ItemID
ON Inventory.ItemItemEffects (ItemID);

CREATE NONCLUSTERED INDEX IxItemItemEffects_EffectID
ON Inventory.ItemItemEffects (EffectID);

CREATE NONCLUSTERED INDEX IxChapterNotes_ChapterID
ON Chapters.ChapterNotes (ChapterID);

CREATE NONCLUSTERED INDEX IxChapterNotes_NoteID
ON Chapters.ChapterNotes (NoteID);

CREATE NONCLUSTERED INDEX IxChapters_ObjectiveID
ON Chapters.Chapters (ObjectiveID);

CREATE NONCLUSTERED INDEX IxChapters_RequirementID
ON Chapters.Chapters (RequirementID);

CREATE NONCLUSTERED INDEX IxShops_TypeID
ON Chapters.Shops (TypeID);

CREATE NONCLUSTERED INDEX IxShops_ChapterID
ON Chapters.Shops (ChapterID);

CREATE NONCLUSTERED INDEX IxShopWeapons_ShopID
ON Chapters.ShopWeapons (ShopID);

CREATE NONCLUSTERED INDEX IxShopWeapons_WeaponID
ON Chapters.ShopWeapons (WeaponID);

CREATE NONCLUSTERED INDEX IxShopItems_ShopID
ON Chapters.ShopItems (ShopID);

CREATE NONCLUSTERED INDEX IxShopItems_ItemID
ON Chapters.ShopItems (ItemID);




--INSERTING DATA

INSERT INTO Inventory.WeaponTypes
	(Name)
VALUES
	('Sword'),
	('Axe'),
	('Lance'),
	('Bow'),
	('Anima'),
	('Light'),
	('Dark'),
	('Staff');

INSERT INTO Inventory.WeaponElements
	(Name)
VALUES
	('Fire'),
	('Thunder'),
	('Wind'),
	('Light'),
	('Dark');

INSERT INTO Inventory.WeaponEffects
	(Description)
VALUES
	('Strong against swords'),
	('Strong against axes'),
	('Strong against lances'),
	('Weak against swords'),
	('Weak against axes'),--5
	('Weak against lances'),
	('Strong against armoured units'),
	('Strong against mounted units'),
	('Strong against flying units'),
	('Strong against dragon units'),--10
	('Strong against Mercenaries/Heroes/Myrmidons/Swordmasters/Blade Lords'),
	('Allows user to strike twice'),
	('Cannot be countered'),
	('May inflict damage to the user'),
	('Inflicts Poison'),--15
	('Inflicts magic damage at range'),
	('Targets enemy Resistance'),
	('Restores HP to user equal to damage dealt'),
	('Negates enemy Resistance'),
	('Halves enemy HP'),--20
	('Myrmidons/Swordmasters/Blade Lords only'),
	('Lyn only'),
	('Eliwood only'),
	('Hector only'),
	('Athos only'),--25
	('Strength +5'),
	('Defense +5'),
	('Luck +5'),
	('Resistance +5'),
	('Max HP +17, Strength +5, Skill +4, Speed +9, Defense +4, Resistance +14'),--30
	('Restores ally HP equal to Magic +10'),
	('Restores ally HP equal to Magic +20'),
	('Fully restores ally HP'),
	('Restores HP to all allies in range equal to Magic +10'),
	('Lights an area in Fog of War'),--35
	('Unlocks a door'),
	('Removes ally status effects'),
	('Repairs a weapon'),
	('Increases ally Resistance'),
	('Inflicts Silence'),--40
	('Inflicts Sleep'),
	('Inflicts Berserk'),
	('Teleports ally to user'),
	('Teleports ally away from user');

INSERT INTO Units.ClassNotes
	(Description)
VALUES
	('Armoured'),
	('Mounted'),
	('Flying'),
	('Dragon'),
	('Enemy class'),--5
	('NPC class'),
	('+15 Crit'),
	('Can steal items'),
	('Can cross mountains'),
	('Can cross water'),--10
	('Can use ballistae'),
	('Can allow an ally to move again'),
	('Can store items'),
	('Cannot move'),
	('Silencer'),--15
	('Silences all characters within range'),
	('Exclusive to Athos'),
	('Exclusive to Nergal'),
	('Exclusive to Nils'),
	('Exclusive to Ninian'),--20
	('Exclusive to Kishuna');
GO

INSERT INTO Inventory.Weapons
	(Name, TypeID, ElementID, WeaponRank, Uses, Weight, Might, Hit, Crit, Range, Cost)
VALUES
	--Swords
	('Iron Sword', 1, NULL, 'E', 46, 5, 5, 90, 0, '1', 460),
	('Slim Sword', 1, NULL, 'E', 30, 2, 3, 100, 5, '1', 480),
	('Poison Sword', 1, NULL, 'D', 40, 6, 3, 70, 0, '1', NULL),
	('Steel Sword', 1, NULL, 'D', 30, 10, 8, 75, 0, '1', 600),
	('Iron Blade', 1, NULL, 'D', 35, 12, 9, 70, 0, '1', 980),--5
	('Armorslayer', 1, NULL, 'D', 18, 11, 8, 80, 0, '1', 1260),
	('Longsword', 1, NULL, 'D', 18, 11, 6, 85, 0, '1', 1260),
	('Wo Dao', 1, NULL, 'D', 20, 5, 8, 75, 35, '1', 1200),
	('Steel Blade', 1, NULL, 'C', 25, 14, 11, 65, 0, '1', 1250),
	('Killing Edge', 1, NULL, 'C', 20, 7, 9, 75, 30, '1', 1300),--10
	('Wyrmslayer', 1, NULL, 'C', 20, 5, 7, 75, 0, '1', 3000),
	('Light Brand', 1, 4, 'C', 25, 9, 9, 70, 0, '1-2', 1250),
	('Lancereaver', 1, NULL, 'C', 15, 9, 9, 75, 5, '1', 1800),
	('Brave Sword', 1, NULL, 'B', 30, 12, 9, 75, 0, '1', 3000),
	('Wind Sword', 1, 3, 'B', 40, 9, 9, 70, 0, '1-2', 8000),--15
	('Silver Sword', 1, NULL, 'A', 20, 8, 13, 80, 0, '1', 1500),
	('Silver Blade', 1, NULL, 'A', 15, 13, 14, 60, 0, '1', 1800),
	('Runesword', 1, 5, 'A', 15, 11, 12, 65, 0, '1-2', 3500),
	('Regal Blade', 1, NULL, 'S', 25, 9, 20, 85, 0, '1', 15000),
	('Mani Katti', 1, NULL, 'Prf', 45, 3, 8, 80, 20, '1', NULL),--20
	('Sol Katti', 1, NULL, 'Prf', 30, 14, 12, 95, 25, '1', NULL),
	('Rapier', 1, NULL, 'Prf', 40, 5, 7, 95, 10, '1', 6000),
	('Durandal', 1, NULL, 'Prf', 20, 16, 17, 90, 0, '1', NULL),
	--Axes
	('Iron Axe', 2, NULL, 'E', 45, 10, 8, 75, 0, '1', 270),
	('Hand Axe', 2, NULL, 'E', 20, 12, 7, 60, 0, '1-2', 300),--25
	('Steel Axe', 2, NULL, 'E', 30, 15, 11, 65, 0, '1', 360),
	('Devil Axe', 2, NULL, 'E', 20, 18, 18, 55, 0, '1', 900),
	('Poison Axe', 2, NULL, 'D', 40, 10, 4, 60, 0, '1', NULL),
	('Halberd', 2, NULL, 'D', 18, 15, 10, 60, 0, '1', 810),
	('Hammer', 2, NULL, 'D', 20, 15, 10, 55, 0, '1', 800),--30
	('Dragon Axe', 2, NULL, 'C', 40, 11, 10, 60, 0, '1', 6000),
	('Killer Axe', 2, NULL, 'C', 20, 11, 11, 65, 30, '1', 1000),
	('Swordreaver', 2, NULL, 'C', 15, 13, 11, 65, 5, '1', 2100),
	('Swordslayer', 2, NULL, 'C', 20, 13, 11, 80, 5, '1', 2000),
	('Brave Axe', 2, NULL, 'B', 30, 16, 10, 65, 0, '1', 2250),--35
	('Tomahawk', 2, NULL, 'A', 15, 14, 13, 65, 0, '1-2', 3000),
	('Silver Axe', 2, NULL, 'A', 20, 12, 15, 70, 0, '1', 1000),
	('Basilikos', 2, NULL, 'S', 25, 13, 22, 75, 0, '1', 15000),
	('Wolf Beil', 2, NULL, 'Prf', 30, 10, 10, 75, 5, '1', 6000),
	('Armads', 2, NULL, 'Prf', 25, 18, 18, 85, 0, '1', NULL),--40
	--Lances
	('Iron Lance', 3, NULL, 'E', 45, 8, 7, 80, 0, '1', 360),
	('Slim Lance', 3, NULL, 'E', 30, 4, 4, 85, 5, '1', 450),
	('Javelin', 3, NULL, 'E', 20, 11, 6, 65, 0, '1-2', 400),
	('Poison Lance', 3, NULL, 'E', 40, 8, 4, 60, 0, '1', NULL),
	('Steel Lance', 3, NULL, 'D', 30, 13, 10, 70, 0, '1', 480),--45
	('Heavy Spear', 3, NULL, 'D', 16, 14, 9, 70, 0, '1', 1200),
	('Horseslayer', 3, NULL, 'D', 16, 13, 7, 70, 0, '1', 1040),
	('Short Spear', 3, NULL, 'C', 18, 12, 9, 60, 0, '1-2', 900),
	('Killer Lance', 3, NULL, 'C', 20, 9, 10, 70, 30, '1', 1200),
	('Axereaver', 3, NULL, 'C', 15, 11, 10, 70, 5, '1', 1950),--50
	('Brave Lance', 3, NULL, 'B', 30, 14, 10, 70, 0, '1', 7500),
	('Spear', 3, NULL, 'B', 15, 10, 12, 70, 5, '1-2', 9000),
	('Uber Spear', 3, NULL, 'B', 15, 10, 12, 70, 0, '1-2', 1500),
	('Silver Lance', 3, NULL, 'A', 20, 10, 14, 75, 0, '1', 1200),
	('Rex Hasta', 3, NULL, 'S', 25, 11, 21, 80, 0, '1', 15000),--55
	--Bows
	('Iron Bow', 4, NULL, 'E', 45, 5, 6, 85, 0, '2', 540),
	('Poison Bow', 4, NULL, 'D', 40, 5, 4, 65, 0, '2', NULL),
	('Short Bow', 4, NULL, 'D', 22, 3, 5, 85, 10, '2', 1760),
	('Longbow', 4, NULL, 'D', 20, 10, 5, 65, 0, '2-3', 2000),
	('Steel Bow', 4, NULL, 'D', 30, 9, 9, 70, 0, '2', 720),--60
	('Killer Bow', 4, NULL, 'C', 20, 7, 9, 75, 30, '2', 1400),
	('Brave Bow', 4, NULL, 'B', 30, 12, 10, 70, 0, '2', 7500),
	('Silver Bow', 4, NULL, 'A', 20, 6, 13, 75, 0, '2', 1600),
	('Rienfleche', 4, NULL, 'S', 25, 7, 20, 80, 0, '2', 15000),
	('Ballista', 4, NULL, 'E', 5, 20, 8, 70, 0, '3-10', NULL),--65
	('Killer Ballista', 4, NULL, 'E', 5, 20, 12, 65, 10, '3-10', NULL),
	('Iron Ballista', 4, NULL, 'E', 5, 20, 13, 60, 0, '3-15', NULL),
	--Anima
	('Fire', 5, 1, 'E', 40, 4, 5, 90, 0, '1-2', 560),
	('Thunder', 5, 2, 'D', 35, 6, 8, 80, 5, '1-2', 700),
	('Elfire', 5, 1, 'C', 30, 10, 10, 85, 0, '1-2', 1200),--70
	('Bolting', 5, 2, 'B', 5, 20, 12, 60, 0, '3-10', 2500),
	('Fimbulvetr', 5, 3, 'A', 20, 12, 13, 80, 0, '1-2', 6000),
	('Excalibur', 5, 3, 'S', 25, 13, 18, 90, 10, '1-2', 25000),
	('Forblaze', 5, 1, 'Prf', 20, 11, 14, 85, 5, '1-2', NULL),
	--Light
	('Lightning', 6, 4, 'E', 36, 6, 4, 95, 5, '1-2', 630),--75
	('Shine', 6, 4, 'D', 30, 8, 6, 90, 8, '1-2', 900),
	('Divine', 6, 4, 'C', 25, 12, 8, 85, 10, '1-2', 2500),
	('Purge', 6, 4, 'B', 5, 20, 10, 75, 5, '3-10', 3000),
	('Aura', 6, 4, 'A', 20, 15, 12, 85, 15, '1-2', 8000),
	('Aureola', 6, 4, 'S', 20, 14, 15, 90, 5, '1-2', NULL),--80
	('Luce', 6, 4, 'S', 25, 16, 16, 95, 25, '1-2', 30000),
	--Dark
	('Flux', 7, 5, 'D', 45, 8, 7, 80, 0, '1-2', 900),
	('Luna', 7, 5, 'C', 35, 12, 0, 95, 20, '1-2', 5250),
	('Nosferatu', 7, 5, 'C', 20, 14, 10, 70, 0, '1-2', 3200),
	('Eclipse', 7, 5, 'B', 5, 12, NULL, 30, 0, '3-10', 4000),--85
	('Fenrir', 7, 5, 'A', 20, 18, 15, 70, 0, '1-2', 9000),
	('Gespenst', 7, 5, 'S', 25, 20, 23, 80, 0, '1-2', 35000),
	('Ereshkigal', 7, 5, NULL, NULL, 12, 20, 95, 0, '1-2', NULL),
	--Staves
	('Heal', 8, NULL, 'E', 30, NULL, NULL, NULL, NULL, '1', 600),
	('Mend', 8, NULL, 'D', 20, NULL, NULL, NULL, NULL, '1', 1000),--90
	('Torch', 8, NULL, 'D', 10, NULL, NULL, NULL, NULL, '1-Magic/2', 1000),
	('Unlock', 8, NULL, 'D', 10, NULL, NULL, NULL, NULL, '1-2', 1500),
	('Recover', 8, NULL, 'C', 15, NULL, NULL, NULL, NULL, '1', 2250),
	('Restore', 8, NULL, 'C', 10, NULL, NULL, NULL, NULL, '1', 3000),
	('Hammerne', 8, NULL, 'C', 3, NULL, NULL, NULL, NULL, '1', 2000),--95
	('Barrier', 8, NULL, 'C', 15, NULL, NULL, NULL, NULL, '1', 2250),
	('Physic', 8, NULL, 'B', 15, NULL, NULL, NULL, NULL, '1-Magic/2', 3750),
	('Silence', 8, NULL, 'B', 3, NULL, NULL, NULL, NULL, '1-Magic/2', 1200),
	('Sleep', 8, NULL, 'B', 3, NULL, NULL, NULL, NULL, '1-Magic/2', 1500),
	('Berserk', 8, NULL, 'B', 3, NULL, NULL, NULL, NULL, '1-Magic/2', 1800),--100
	('Rescue', 8, NULL, 'B', 3, NULL, NULL, NULL, NULL, '1-Magic/2', 1800),
	('Fortify', 8, NULL, 'A', 8, NULL, NULL, NULL, NULL, '1-Magic/2', 8000),
	('Warp', 8, NULL, 'A', 5, NULL, NULL, NULL, NULL, '1', 7500);

INSERT INTO Inventory.ItemEffects
	(Description)
VALUES
	('Negates enemy effective bonus towards flying units'),
	('Negates enemy critical attacks'),
	('Raises ally Attack by 10 for 1 turn'),
	('Raises ally Crit by 10 for 1 turn'),
	('Raises ally Defense and Resistance by 10 for 1 turn'),--5
	('Raises ally Avoid by 10 for 1 turn'),
	('Permanently increases all growth rates by 5'),
	('Unlocks a door'),
	('Unlocks a chest'),
	('Restores 10 HP'),--10
	('Restores all HP'),
	('Removes Poison'),
	('Lights an area in Fog of War'),
	('Halts movement and does 10 damage to anyone who steps on it'),
	('Temporarily makes a map tile untraversable'),--15
	('Increases Resistance'),
	('Thieves/Assassins only'),
	('User can buy items in shops for half price'),
	('User can access secret shops'),
	('Can be sold for 2500G'),--20
	('Can be sold for 5000G'),
	('Can be sold for 10000G'),
	('Permanently increases max HP by 7'),
	('Permamnetly increases Strength/Magic by 2'),
	('Permanently increases Skill by 2'),--25
	('Permanently increases Speed by 2'),
	('Permanently increases Luck by 2'),
	('Permanently increases Defense by 2'),
	('Permanently increases Resistance by 2'),
	('Permanently increases Movement by 2'),--30
	('Permanently increases Constitution by 2'),
	('Promotes level 10+ Fighters/Mercenaries/Myrmidons'),
	('Promotes level 10+ Cavaliers/Knights'),
	('Promotes level 10+ Archers/Nomads'),
	('Promotes level 10+ Pegasus Knights/Wyvern Riders'),--35
	('Promotes level 10+ Clerics/Mages/Monks/Shamans/Troubadours'),
	('Promotes any level 10+ unit except Lords/Thieves/Pirates'),
	('Promotes level 10+ Lords'),
	('Promotes level 10+ Thieves'),
	('Promotes level 10+ Pirates');--40

INSERT INTO Inventory.Items
	(Name, Uses, Cost)
VALUES
	('Delphi Shield', NULL, 10000),
	('Iron Rune', NULL, 5000),
	('Filla''s Might', 15, NULL),
	('Thor''s Ire', 15, NULL),
	('Ninis'' Grace', 15, NULL),--5
	('Set''s Litany', 15, NULL),
	('Afa''s Drops', 1, NULL),
	('Door Key', 1, 50),
	('Chest Key', 1, 300),
	('Chest Key', 5, 1500),--10
	('Vulnerary', 3, 300),
	('Elixir', 3, 3000),
	('Antitoxin', 3, 450),
	('Torch', 5, 500),
	('Mine', 1, 500),--15
	('Light Rune', 1, 800),
	('Pure Water', 3, 900),
	('Lockpick', 15, 1200),
	('Silver Card', NULL, 4000),
	('Member Card', NULL, 6000),--20
	('Red Gem', NULL, 5000),
	('Blue Gem', NULL, 10000),
	('White Gem', NULL, 20000),
	('Angelic Robe', 1, 8000),
	('Energy Ring', 1, 8000),--25
	('Secret Book', 1, 8000),
	('Speedwing', 1, 8000),
	('Goddess Icon', 1, 8000),
	('Dracoshield', 1, 8000),
	('Talisman', 1, 8000),--30
	('Boots', 1, 8000),
	('Body Ring', 1, 8000),
	('Hero Crest', 1, 10000),
	('Knight Crest', 1, 10000),
	('Orion''s Bolt', 1, 10000),--35
	('Elysian Whip', 1, 10000),
	('Guiding Ring', 1, 10000),
	('Earth Seal', 1, 20000),
	('Heaven''s Seal', 1, 20000),
	('Fell Contract', 1, 50000),--40
	('Ocean Seal', 1, 50000);
GO

INSERT INTO Inventory.ItemItemEffects
	(ItemID, EffectID)
VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 5),
	(6, 6),
	(7, 7),
	(8, 8),
	(9, 9),
	(10, 9),
	(11, 10),
	(12, 11),
	(13, 12),
	(14, 13),
	(15, 14),
	(16, 15),
	(17, 16),
	(18, 8),
	(18, 9),
	(18, 17),
	(19, 18),
	(20, 19),
	(21, 20),
	(22, 21),
	(23, 22),
	(24, 23),
	(25, 24),
	(26, 25),
	(27, 26),
	(28, 27),
	(29, 28),
	(30, 29),
	(31, 30),
	(32, 31),
	(33, 32),
	(34, 33),
	(35, 34),
	(36, 35),
	(37, 36),
	(38, 37),
	(39, 38),
	(40, 39),
	(41, 40);

INSERT INTO Units.Classes
	(Name, Movement)
VALUES
	('Lord (Lyn)', 5),
	('Blade Lord', 6),
	('Lord (Eliwood)', 5),
	('Knight Lord', 7),
	('Lord (Hector)', 5),--5
	('Great Lord', 5),
	('Mercenary', 5),
	('Hero', 6),
	('Myrmidon', 5),
	('Swordmaster', 6),--10
	('Thief', 6),
	('Assassin', 6),
	('Knight', 4),
	('General', 5),
	('Soldier', 5),--15
	('Fighter', 5),
	('Warrior', 6),
	('Brigand', 5),
	('Pirate', 5),
	('Corsair', 5),--20
	('Berserker', 6),
	('Archer', 5),
	('Sniper', 6),
	('Nomad', 7),
	('Nomad Trooper', 8),--25
	('Cavalier', 7),
	('Paladin', 8),
	('Pegasus Knight', 7),
	('Falcon Knight', 8),
	('Wyvern Rider', 7),--30
	('Wyvern Lord', 8),
	('Mage', 5),
	('Sage', 6),
	('Monk', 5),
	('Cleric', 5),--35
	('Bishop', 6),
	('Shaman', 5),
	('Druid', 6),
	('Dark Druid', 6),
	('Troubadour', 7),--40
	('Valkyrie', 8),
	('Archsage', 6),
	('Bard', 5),
	('Dancer', 5),
	('Transporter (Tent)', 0),--45
	('Transporter (Wagon)', 5),
	('Magic Seal', 6),
	('Fire Dragon', 8),
	('Civilian', 5),
	('Prince', 5);--50

INSERT INTO Units.PromotionGains
	(HP, StrengthMagic, Skill, Speed, Defense, Resistance, Movement, Constitution, Gender)
VALUES
	(3, 2, 2, 0, 3, 5, 1, 1, NULL),
	(4, 2, 0, 1, 1, 3, 2, 2, NULL),
	(3, 0, 2, 3, 1, 5, 0, 2, NULL),
	(2, 1, 1, 1, 2, 1, 1, 2, NULL),
	(4, 2, 2, 3, 2, 3, 1, 2, NULL),--5
	(4, 0, 2, 2, 2, 2, 1, 1, NULL),
	(5, 2, 0, 0, 2, 1, 1, 1, NULL),
	(3, 1, 0, 0, 2, 2, 0, 0, NULL),
	(3, 1, 2, 2, 2, 3, 1, 1, 'M'),
	(4, 3, 1, 1, 2, 2, 1, 1, 'F'),--10
	(3, 2, 1, 1, 3, 3, 1, 1, NULL),
	(4, 0, 2, 2, 0, 2, 1, 1, NULL),
	(4, 1, 0, 0, 3, 3, 1, 1, 'M'),
	(3, 1, 1, 0, 3, 3, 1, 1, 'F'),
	(3, 2, 1, 0, 3, 2, 1, 1, NULL),--15
	(3, 1, 2, 1, 2, 2, 1, 1, NULL),
	(4, 0, 0, 3, 2, 2, 1, 1, NULL),
	(3, 1, 2, 0, 3, 3, 1, 2, NULL),
	(4, 1, 1, 1, 2, 2, 1, 3, NULL),
	(5, 2, 0, 0, 2, 2, 1, 1, NULL),--20
	(3, 2, 1, 0, 2, 3, 1, 1, NULL),
	(0, 0, 0, 0, 0, 0, 5, 0, NULL);
GO

INSERT INTO Units.Promotions
	(BaseClassID, PromotedClassID, GainID)
VALUES
	(1, 2, 1),
	(3, 4, 2),
	(5, 6, 3),
	(7, 8, 6),
	(9, 10, 7),
	(11, 12, 8),
	(13, 14, 5),
	(15, NULL, NULL),
	(16, 17, 18),
	(18, 21, 19),
	(19, 21, 19),
	(20, NULL, NULL),
	(22, 23, 9),
	(22, 23, 10),
	(24, 25, 11),
	(26, 27, 4),
	(28, 29, 20),
	(30, 31, 12),
	(32, 33, 13),
	(32, 33, 14),
	(34, 36, 15),
	(35, 36, 16),
	(37, 38, 17),
	(NULL, 39, NULL),
	(40, 41, 21),
	(NULL, 42, NULL),
	(43, NULL, NULL),
	(44, NULL, NULL),
	(45, 46, 22),
	(NULL, 47, NULL),
	(NULL, 48, NULL),
	(49, NULL, NULL),
	(50, NULL, NULL);

INSERT INTO Units.ClassClassNotes
	(ClassID, NoteID)
VALUES
	(4, 2),
	(6, 1),
	(10, 7),
	(11, 8),
	(12, 15),
	(13, 1),
	(14, 1),
	(15, 5),
	(15, 6),
	(18, 5),
	(18, 9),
	(19, 10),
	(20, 5),
	(20, 10),
	(21, 7),
	(21, 9),
	(21, 10),
	(22, 11),
	(23, 11),
	(24, 2),
	(25, 2),
	(26, 2),
	(27, 2),
	(28, 3),
	(29, 3),
	(30, 3),
	(30, 4),
	(31, 3),
	(31, 4),
	(39, 18),
	(40, 2),
	(41, 2),
	(42, 17),
	(43, 12),
	(43, 19),
	(44, 12),
	(44, 20),
	(45, 13),
	(45, 14),
	(46, 13),
	(47, 16),
	(47, 21),
	(48, 4),
	(48, 5),
	(49, 6),
	(50, 6);

INSERT INTO Units.ClassWeaponTypes
	(ClassID, TypeID)
VALUES
	(1, 1),
	(2, 1),
	(2, 4),
	(3, 1),
	(4, 1),
	(4, 3),
	(5, 2),
	(6, 1),
	(6, 2),
	(7, 1),
	(8, 1),
	(8, 2),
	(9, 1),
	(10, 1),
	(11, 1),
	(12, 1),
	(13, 3),
	(14, 2),
	(14, 3),
	(15, 3),
	(16, 2),
	(17, 2),
	(17, 4),
	(18, 2),
	(19, 2),
	(20, 2),
	(21, 2),
	(22, 4),
	(23, 4),
	(24, 4),
	(25, 1),
	(25, 4),
	(26, 1),
	(26, 3),
	(27, 1),
	(27, 2),
	(27, 3),
	(28, 3),
	(29, 1),
	(29, 3),
	(30, 3),
	(31, 1),
	(31, 3),
	(32, 5),
	(33, 5),
	(33, 8),
	(34, 6),
	(35, 8),
	(36, 6),
	(36, 8),
	(37, 7),
	(38, 7),
	(38, 8),
	(39, 5),
	(39, 6),
	(39, 7),
	(39, 8),
	(40, 8),
	(41, 5),
	(41, 8),
	(42, 5),
	(42, 6),
	(42, 7),
	(42, 8),
	(50, 1);

INSERT INTO Inventory.WeaponWeaponEffects
	(WeaponID, EffectID)
VALUES
	(3, 15),
	(6, 7),
	(7, 8),
	(8, 21),
	(11, 10),
	(12, 16),
	(12, 17),
	(13, 3),
	(13, 5),
	(14, 12),
	(15, 9),
	(15, 16),
	(15, 17),
	(18, 16),
	(18, 17),
	(18, 18),
	(20, 7),
	(20, 8),
	(20, 22),
	(21, 10),
	(21, 22),
	(21, 29),
	(22, 7),
	(22, 8),
	(22, 23),
	(23, 10),
	(23, 23),
	(23, 26),
	(27, 14),
	(28, 15),
	(29, 8),
	(30, 7),
	(31, 10),
	(33, 1),
	(33, 6),
	(34, 1),
	(34, 6),
	(34, 11),
	(35, 12),
	(39, 7),
	(39, 8),
	(39, 24),
	(40, 10),
	(40, 24),
	(40, 27),
	(44, 15),
	(46, 7),
	(47, 8),
	(50, 2),
	(50, 4),
	(51, 12),
	(53, 30),
	(56, 9),
	(57, 9),
	(57, 15),
	(58, 9),
	(59, 9),
	(60, 9),
	(61, 9),
	(62, 9),
	(62, 12),
	(63, 9),
	(64, 9),
	(65, 9),
	(65, 13),
	(66, 9),
	(66, 13),
	(67, 9),
	(67, 13),
	(71, 13),
	(74, 10),
	(74, 25),
	(74, 28),
	(78, 13),
	(80, 10),
	(80, 29),
	(83, 19),
	(84, 18),
	(85, 13),
	(85, 20),
	(89, 31),
	(90, 32),
	(91, 35),
	(92, 36),
	(93, 33),
	(94, 37),
	(95, 38),
	(96, 39),
	(97, 31),
	(98, 40),
	(99, 41),
	(100, 42),
	(101, 43),
	(102, 34),
	(103, 44);

INSERT INTO Units.Affinities
	(Name)
VALUES
	('Fire'),
	('Ice'),
	('Thunder'),
	('Wind'),
	('Anima'),
	('Light'),
	('Dark');

INSERT INTO Units.CharGrowthRates
	(HP, StrengthMagic, Skill, Speed, Luck, Defense, Resistance)
VALUES
	(70, 40, 60, 60, 55, 20, 30),
	(80, 45, 50, 40, 45, 30, 35),
	(90, 60, 45, 35, 30, 50, 25),
	(80, 60, 35, 40, 35, 20, 20),
	(85, 40, 50, 45, 20, 25, 25),--5
	(60, 40, 50, 55, 50, 15, 35),
	(75, 50, 50, 40, 40, 20, 25),
	(80, 60, 40, 20, 45, 25, 15),
	(50, 50, 30, 40, 60, 15, 55),
	(65, 40, 40, 50, 30, 20, 40),--10
	(80, 50, 40, 50, 30, 10, 25),
	(75, 30, 40, 70, 50, 25, 20),
	(85, 5, 5, 70, 80, 30, 70),
	(55, 60, 50, 40, 20, 10, 60),
	(70, 45, 40, 20, 30, 35, 35),--15
	(65, 30, 50, 25, 30, 15, 35),
	(90, 30, 30, 30, 50, 40, 30),
	(60, 40, 50, 60, 50, 15, 30),
	(85, 50, 35, 40, 30, 30, 25),
	(90, 40, 30, 30, 35, 55, 30),--20
	(75, 30, 50, 70, 45, 15, 25),
	(120, 0, 90, 90, 100, 30, 15),
	(45, 40, 50, 40, 65, 15, 50),
	(85, 55, 40, 45, 35, 25, 15),
	(70, 45, 40, 35, 25, 25, 45),--25
	(70, 65, 20, 60, 35, 20, 15),
	(70, 35, 60, 50, 30, 20, 50),
	(60, 25, 45, 60, 60, 25, 25),
	(75, 30, 35, 50, 45, 20, 25),
	(80, 50, 50, 45, 20, 30, 20),--30
	(50, 40, 30, 25, 40, 20, 35),
	(85, 50, 30, 40, 40, 20, 20),
	(50, 30, 20, 40, 40, 30, 35),
	(60, 40, 40, 40, 30, 20, 30),
	(70, 30, 50, 50, 30, 10, 15),--35
	(80, 35, 30, 40, 20, 30, 25),
	(55, 50, 55, 60, 45, 15, 50),
	(65, 15, 40, 35, 20, 30, 30),
	(60, 45, 25, 40, 30, 25, 15),
	(60, 40, 30, 35, 15, 20, 40),--40
	(0, 0, 0, 0, 0, 0, 0),
	(75, 50, 40, 45, 45, 25, 30),
	(60, 25, 45, 55, 40, 10, 20);
GO

INSERT INTO Units.Characters
	(Name, Gender, StartingClassID, AffinityID, GrowthRateID, StartingLevel, BaseHP, BaseStrengthMagic, BaseSkill, BaseSpeed, BaseLuck, BaseDefense, BaseResistance, BaseConstitution)
VALUES
	('Lyn', 'F', 1, 4, 1, 4, 18, 5, 10, 11, 5, 2, 0, 5),
	('Eliwood', 'M', 3, 5, 2, 1, 18, 5, 5, 7, 7, 5, 0, 7),
	('Hector', 'M', 5, 3, 3, 1, 19, 7, 4, 5, 3, 8, 0, 13),
	('Sain', 'M', 26, 4, 4, 1, 19, 8, 4, 6, 4, 6, 0, 9),
	('Kent', 'M', 26, 5, 5, 1, 20, 6, 6, 7, 2, 5, 1, 9),--5
	('Florina', 'F', 28, 6, 6, 1, 17, 5, 7, 9, 7, 4, 4, 4),
	('Wil', 'M', 22, 4, 7, 2, 20, 6, 5, 5, 6, 5, 0, 6),
	('Dorcas', 'M', 16, 1, 8, 3, 30, 7, 7, 6, 3, 3, 0, 14),
	('Serra', 'F', 35, 3, 9, 1, 17, 2, 5, 8, 6, 2, 5, 4),
	('Erk', 'M', 32, 3, 10, 1, 17, 5, 6, 7, 3, 2, 4, 5),--10
	('Rath', 'M', 24, 7, 11, 7, 25, 8, 9, 10, 5, 7, 2, 8),
	('Matthew', 'M', 11, 4, 12, 2, 18, 4, 4, 11, 2, 3, 0, 7),
	('Nils', 'M', 43, 2, 13, 1, 14, 0, 0, 12, 10, 5, 4, 3),
	('Lucius', 'M', 34, 6, 14, 3, 18, 7, 6, 10, 2, 1, 6, 6),
	('Wallace', 'M', 13, 3, 15, 12, 30, 13, 7, 5, 10, 15, 2, 13),--15
	('Marcus', 'M', 27, 2, 16, 1, 32, 9, 14, 11, 10, 9, 8, 11),
	('Lowen', 'M', 26, 1, 17, 2, 23, 7, 5, 7, 3, 7, 0, 10),
	('Rebecca', 'F', 22, 1, 18, 1, 17, 4, 5, 6, 4, 3, 1, 5),
	('Bartre', 'M', 16, 3, 19, 2, 29, 9, 5, 3, 4, 4, 0, 13),
	('Oswin', 'M', 13, 5, 20, 9, 29, 13, 9, 5, 3, 13, 3, 14),--20
	('Guy', 'M', 9, 1, 21, 3, 21, 6, 11, 11, 5, 5, 0, 5),
	('Merlinus', 'M', 45, 7, 22, 5, 18, 0, 4, 5, 12, 5, 0, 25),
	('Priscilla', 'F', 40, 4, 23, 3, 16, 6, 6, 8, 7, 3, 6, 4),
	('Raven', 'M', 7, 2, 24, 5, 25, 8, 11, 13, 2, 5, 1, 8),
	('Canas', 'M', 37, 5, 25, 8, 21, 10, 9, 8, 7, 5, 8, 7),--25
	('Dart', 'M', 19, 1, 26, 8, 34, 12, 8, 8, 3, 6, 1, 10),
	('Fiora', 'F', 28, 4, 27, 7, 21, 8, 11, 13, 6, 6, 7, 5),
	('Legault', 'M', 11, 2, 28, 12, 26, 8, 11, 15, 10, 8, 3, 9),
	('Ninian', 'F', 44, 2, 13, 1, 14, 0, 0, 12, 10, 5, 4, 4),
	('Isadora', 'F', 27, 7, 29, 1, 28, 13, 12, 16, 10, 8, 6, 6),--30
	('Heath', 'M', 30, 3, 30, 7, 28, 11, 8, 7, 7, 10, 1, 9),
	('Hawkeye', 'M', 21, 4, 31, 4, 50, 18, 14, 11, 13, 14, 10, 16),
	('Geitz', 'M', 17, 3, 32, 3, 40, 17, 12, 13, 10, 11, 3, 13),
	('Pent', 'M', 33, 2, 33, 6, 33, 18, 21, 17, 14, 11, 16, 8),
	('Louise', 'F', 23, 6, 34, 4, 28, 12, 14, 17, 16, 9, 12, 6),--35
	('Karel', 'M', 10, 6, 35, 8, 31, 16, 23, 20, 15, 13, 12, 9),
	('Harken', 'M', 8, 1, 36, 8, 38, 21, 20, 17, 12, 15, 10, 11),
	('Nino', 'F', 32, 1, 37, 5, 19, 7, 8, 11, 10, 4, 7, 3),
	('Jaffar', 'M', 12, 2, 38, 13, 34, 19, 25, 24, 10, 15, 11, 8),
	('Vaida', 'F', 31, 1, 39, 9, 43, 20, 19, 13, 11, 21, 6, 12),--40
	('Renault', 'M', 36, 5, 40, 16, 43, 12, 22, 20, 10, 15, 18, 9),
	('Athos', 'M', 42, 5, 41, 20, 40, 30, 24, 20, 25, 20, 28, 9),
	('Farina', 'F', 28, 5, 42, 12, 24, 10, 13, 14, 10, 10, 12, 5),
	('Karla', 'F', 10, 7, 43, 5, 29, 14, 21, 18, 16, 11, 12, 7);
GO

INSERT INTO Units.Supports
	(Char1ID, Char2ID, StartingPoints, PointsPerTurn)
VALUES
	(1, 2, 10, 2),
	(1, 3, 0, 3),
	(1, 6, 76, 4),
	(1, 11, 15, 4),
	(1, 5, 20, 3),
	(1, 7, 17, 3),
	(1, 15, 15, 2),
	(2, 3, 72, 3),
	(2, 29, 0, 5),
	(2, 16, 25, 2),
	(2, 17, 20, 2),
	(2, 37, 25, 3),
	(2, 27, 0, 2),
	(3, 20, 20, 2),
	(3, 12, 20, 3),
	(3, 6, 5, 2),
	(3, 9, 15, 1),
	(3, 43, 0, 1),
	(4, 5, 30, 3),
	(4, 27, 0, 2),
	(4, 9, 0, 2),
	(4, 18, 0, 2),
	(4, 23, 0, 2),
	(4, 35, 0, 1),
	(4, 30, 0, 1),
	(5, 27, 0, 3),
	(5, 43, 0, 1),
	(5, 15, 15, 2),
	(5, 31, 0, 2),
	(6, 43, 35, 3),
	(6, 27, 35, 4),
	(6, 29, 0, 4),
	(6, 38, 0, 2),
	(6, 9, 0, 1),
	(7, 18, 30, 3),
	(7, 11, 0, 2),
	(7, 26, 20, 3),
	(7, 15, 0, 2),
	(7, 24, 0, 1),
	(8, 19, 15, 3),
	(8, 33, 0, 3),
	(8, 20, 0, 2),
	(8, 40, 0, 2),
	(8, 43, 0, 1),
	(9, 12, 5, 1),
	(9, 20, 10, 1),
	(9, 14, 0, 2),
	(9, 10, 2, 1),
	(10, 35, 20, 2),
	(10, 38, 0, 3),
	(10, 34, 25, 3),
	(10, 23, 15, 3),
	(11, 21, 0, 4),
	(12, 39, 0, 1),
	(12, 21, 10, 3),
	(12, 20, 5, 2),
	(12, 28, 0, 2),
	(14, 24, 30, 3),
	(14, 23, 20, 3),
	(14, 41, 0, 2),
	(14, 36, 0, 1),
	(15, 41, 0, 2),
	(15, 40, 0, 2),
	(16, 22, 0, 2),
	(16, 17, 20, 3),
	(16, 30, 15, 3),
	(16, 37, 20, 2),
	(17, 30, 10, 3),
	(17, 37, 15, 3),
	(17, 18, 5, 2),
	(18, 26, 35, 3),
	(18, 35, 0, 3),
	(18, 24, 0, 2),
	(18, 38, 0, 3),
	(19, 24, 0, 1),
	(19, 25, 0, 2),
	(19, 44, 5, 4),
	(19, 41, 0, 1),
	(20, 23, 0, 2),
	(21, 36, 5, 3),
	(21, 23, 0, 2),
	(21, 35, 0, 1),
	(22, 38, 0, 2),
	(22, 40, 0, 1),
	(23, 24, 20, 3),
	(23, 31, 0, 2),
	(25, 34, 0, 3),
	(25, 38, 0, 3),
	(25, 41, 0, 2),
	(25, 40, 0, 2),
	(26, 43, 0, 2),
	(26, 33, 0, 2),
	(26, 36, 0, 2),
	(27, 43, 30, 3),
	(27, 34, 10, 2),
	(27, 33, 0, 1),
	(28, 38, 0, 2),
	(28, 30, 0, 1),
	(28, 39, 5, 1),
	(28, 31, 0, 2),
	(29, 32, 0, 3),
	(30, 37, 40, 4),
	(30, 33, 0, 2),
	(30, 41, 0, 1),
	(31, 40, 0, 2),
	(31, 35, 0, 1),
	(32, 34, 20, 3),
	(32, 35, 20, 3),
	(33, 36, 0, 2),
	(34, 35, 241, 0),
	(36, 44, 25, 2),
	(37, 40, 0, 1),
	(38, 39, 25, 3),
	(40, 44, 0, 2),
	(43, 44, 0, 2);

INSERT INTO Chapters.Notes
	(Description)
VALUES
	('Exclusive to Eliwood''s route'),
	('Exclusive to Hector''s route'),
	('Side chapter'),
	('Has an arena'),
	('Fog of War'),
	('Weather effects');

INSERT INTO Chapters.Objectives
	(Description)
VALUES
	('Seize throne'),
	('Rout enemy'),
	('Defeat boss'),
	('Seize gate'),
	('Protect Natalie for 7 turns'),--5
	('Protect Merlinus for 7 turns'),
	('Protect the throne for 7 turns'),
	('Protect the throne for 11 turns'),
	('Protect Zephiel for 15 turns'),
	('Trigger 3 switches'),--10
	('Speak to Fargus'),
	('Survive for 11 turns'),
	('Survive for 11 turns or defeat boss'),
	('Protect Nils for 11 turns or defeat boss'),
	('Seize 3 forts'),--15
	('Purchase supplies in 5 turns');

INSERT INTO Chapters.Requirements
	(Description)
VALUES
	('Complete the previous chapter in 15 or fewer turns'),
	('In the previous chapter, visit the northwestern village'),
	('At least 1 Caelin soldier must survive the previous chapter'),
	('Get Nils to level 7 or above in Lyn''s route, then defeat Kishuna in Imprisoner of Magic'),
	('Gain more than 700 EXP for your party in the previous chapter, and Hawkeye must survive'),--5
	('The sum of Lyn, Eliwood and Hector''s levels must be 50 or greater'),
	('The sum of Lyn, Eliwood and Hector''s levels must be 49 or less'),
	('Erk, Serra, Priscilla and Lucius'' total gained EXP is greater than or equal to Guy, Dorcas, Bartre and Raven''s total gained EXP'),
	('Erk, Serra, Priscilla and Lucius'' total gained EXP is less than Guy, Dorcas, Bartre and Raven''s total gained EXP'),
	('Recruit Nino and have her talk to Jaffar in the previous chapter, and both must survive'),--10
	('Complete the previous chapter in 20 or fewer turns');
GO

INSERT INTO Chapters.Chapters
	(Name, ObjectiveID, RequirementID)
VALUES
	('A Girl from the Plains', 1, NULL),
	('Footsteps of Fate', 2, NULL),
	('Sword of Spirits', 1, NULL),
	('Band of Mercenaries', 2, NULL),
	('In Occupation''s Shadow', 5, NULL),--5
	('Beyond the Borders', 2, NULL),
	('Blood of Pride', 10, NULL),
	('Siblings Abroad', 3, NULL),
	('The Black Shadow', 2, 1),
	('Vortex of Strategy', 2, NULL),--10
	('A Grim Reunion', 4, NULL),
	('The Distant Plains', 4, NULL),
	('Taking Leave', 4, NULL),
	('Another Journey', 3, NULL),
	('Birds of a Feather', 2, NULL),--15
	('In Search of Truth', 4, NULL),
	('The Peddler Merlinus', 6, 2),
	('False Friends', 2, NULL),
	('Talons Alight', 7, NULL),
	('Noble Lady of Caelin', 4, NULL),--20
	('Whereabouts Unknown', 1, NULL),
	('The Port of Badon', 11, 3),
	('Pirate Ship', 13, NULL),
	('The Dread Isle', 3, NULL),
	('Imprisoner of Magic', 4, 1),--25
	('A Glimpse in Time', 1, 4),
	('Dragon''s Gate', 1, NULL),
	('New Resolve', 3, NULL),
	('Kinship''s Bond', 14, NULL),
	('Living Legend', 2, NULL),--30
	('Genesis', 2, 5),
	('Four-Fanged Offense (Linus)', 3, 6),
	('Four-Fanged Offense (Lloyd)', 3, 7),
	('Crazed Beast', 15, NULL),
	('Unfulfilled Heart', 12, NULL),--35
	('Pale Flower of Darkness (Kenneth)', 1, 8),
	('Pale Flower of Darkness (Jerme)', 2, 9),
	('Battle Before Dawn', 9, NULL),
	('Night of Farewells', 1, 10),
	('Cog of Destiny', 2, NULL),--40
	('Valorous Roland', 1, NULL),
	('The Berserker', 1, NULL),
	('Sands of Time', 8, NULL),
	('Battle Preparations', 16, NULL),
	('Victory or Death', 4, NULL),--45
	('The Value of Life', 3, 11),
	('Light', 3, NULL);
GO

INSERT INTO Chapters.ChapterNotes
	(ChapterID, NoteID)
VALUES
	(9, 3),
	(11, 5),
	(12, 6),
	(13, 1),
	(14, 2),
	(17, 3),
	(17, 5),
	(18, 6),
	(19, 2),
	(22, 3),
	(22, 4),
	(24, 5),
	(25, 3),
	(26, 2),
	(26, 3),
	(26, 5),
	(28, 4),
	(28, 5),
	(31, 3),
	(32, 4),
	(33, 4),
	(33, 5),
	(36, 6),
	(37, 6),
	(38, 5),
	(39, 3),
	(41, 1),
	(42, 2),
	(44, 3),
	(44, 4),
	(46, 2),
	(46, 3);

INSERT INTO Units.Bosses
	(Name, ChapterID, ClassID, Level, HP, StrengthMagic, Skill, Speed, Luck, Defense, Resistance, Constitution)
VALUES
	('Batta', 1, 18, 2, 21, 5, 1, 3, 2, 3, 0, 10),
	('Zugu', 2, 18, 4, 23, 6, 2, 4, 1, 4, 0, 11),
	('Glass', 3, 7, 3, 20, 5, 4, 5, 0, 3, 0, 9),
	('Migal', 4, 18, 6, 25, 7, 3, 5, 2, 5, 0, 12),
	('Carjiga', 5, 18, 8, 27, 6, 5, 4, 2, 7, 0, 15),
	('Bug', 6, 18, 9, 29, 8, 4, 6, 1, 8, 0, 15),
	('Bool', 7, 13, 5, 26, 8, 4, 2, 1, 10, 0, 13),
	('Heintz', 8, 37, 5, 22, 3, 5, 7, 3, 3, 5, 9),
	('Beyard', 9, 7, 7, 24, 6, 8, 7, 4, 5, 1, 10),
	('Yogi', 10, 13, 6, 25, 9, 7, 3, 2, 11, 1, 12),
	('Eagler', 11, 27, 1, 30, 10, 6, 7, 2, 10, 5, 12),
	('Lundgren', 12, 14, 5, 35, 12, 8, 5, 6, 14, 7, 15),
	('Groznyi', 13, 18, 5, 25, 7, 4, 4, 1, 4, 2, 12),
	('Wire', 14, 13, 7, 25, 9, 6, 3, 3, 13, 3, 13),
	('Zagan', 15, 16, 9, 32, 11, 4, 6, 2, 6, 5, 14),
	('Boies', 16, 13, 13, 27, 12, 8, 4, 1, 13, 7, 13),
	('Puzon', 17, 7, 10, 26, 10, 8, 9, 5, 6, 6, 11),
	('Erik', 18, 26, 14, 28, 8, 9, 8, 6, 8, 9, 10),
	('Sealen', 19, 24, 15, 26, 10, 9, 7, 10, 7, 6, 7),
	('Bauker', 20, 13, 18, 31, 13, 10, 4, 4, 11, 11, 14),
	('Bernard', 21, 14, 1, 29, 14, 9, 3, 2, 13, 10, 15),
	('Fargus', 22, 21, 18, 58, 24, 15, 14, 15, 18, 17, 15),
	('Damian', 22, 27, 5, 34, 12, 7, 5, 2, 14, 13, 11),
	('Zoldam', 23, 37, 18, 28, 12, 11, 10, 8, 7, 15, 7),
	('Uhai', 24, 25, 7, 33, 15, 13, 12, 4, 12, 13, 10),
	('Aion', 25, 33, 4, 32, 12, 9, 12, 9, 6, 16, 7),
	('Kishuna', 25, 47, 1, 50, 0, 0, 24, 0, 13, 0, 7),
	('Teodor', 26, 38, 17, 30, 16, 15, 12, 3, 9, 18, 8),
	('Cameron', 27, 27, 4, 31, 9, 10, 12, 5, 10, 11, 11),
	('Darin', 27, 14, 5, 34, 14, 9, 8, 2, 15, 13, 15),
	('Oleg', 28, 17, 5, 42, 16, 9, 7, 3, 12, 7, 13),
	('Eubans', 29, 27, 6, 38, 14, 10, 9, 5, 12, 14, 11),
	('Paul', 30, 17, 8, 47, 19, 12, 12, 2, 11, 9, 13),
	('Jasmine', 30, 17, 9, 46, 17, 14, 14, 6, 8, 11, 13),
	('Kishuna', 31, 47, 10, 54, 4, 3, 25, 0, 14, 3, 7),
	('Linus', 32, 8, 12, 45, 21, 18, 12, 14, 14, 12, 14),
	('Lloyd', 33, 10, 12, 41, 18, 19, 19, 16, 8, 15, 9),
	('Pascal', 34, 27, 14, 48, 17, 13, 10, 11, 13, 8, 12),
	('Vaida', 35, 31, 10, 43, 20, 19, 13, 0, 21, 6, 12),
	('Kenneth', 36, 36, 13, 41, 19, 16, 13, 6, 9, 21, 10),
	('Jerme', 37, 12, 13, 46, 18, 18, 17, 10, 10, 14, 6),
	('Ursula', 38, 41, 15, 36, 18, 19, 22, 12, 12, 28, 7),
	('Maxime', 38, 27, 6, 40, 14, 12, 13, 5, 9, 15, 11),
	('Sonia', 39, 33, 17, 44, 19, 18, 18, 0, 19, 23, 7),
	('Lloyd', 40, 10, 18, 52, 20, 23, 21, 16, 15, 19, 9),
	('Linus', 40, 8, 18, 58, 24, 20, 15, 14, 19, 15, 14),
	('Georg', 41, 21, 15, 60, 27, 17, 13, 0, 18, 21, 15),
	('Kaim', 42, 8, 16, 60, 20, 18, 15, 0, 15, 22, 13),
	('Denning', 43, 23, 19, 51, 18, 18, 18, 0, 14, 22, 8),
	('Limstella', 45, 33, 20, 68, 24, 20, 17, 0, 24, 27, 7),
	('Kishuna', 46, 47, 18, 58, 8, 5, 25, 0, 15, 6, 7),
	('Uhai', 47, 25, 20, 55, 22, 26, 25, 0, 18, 18, 11),
	('Kenneth', 47, 36, 20, 56, 23, 19, 18, 0, 14, 29, 10),
	('Brendan', 47, 17, 20, 65, 29, 20, 17, 0, 19, 17, 15),
	('Darin', 47, 14, 20, 62, 23, 18, 15, 0, 29, 15, 15),
	('Ursula', 47, 41, 20, 48, 24, 22, 22, 0, 16, 25, 7),
	('Jerme', 47, 12, 20, 53, 19, 28, 23, 0, 19, 16, 6),
	('Lloyd', 47, 10, 20, 52, 21, 26, 27, 0, 18, 22, 9),
	('Linus', 47, 8, 20, 60, 24, 23, 19, 0, 21, 19, 14),
	('Nergal', 47, 39, 20, 75, 30, 18, 15, 20, 28, 30, 10),
	('Dragon', 47, 48, 20, 120, 17, 25, 15, 24, 20, 30, 25);

INSERT INTO Chapters.ShopTypes
	(Name)
VALUES
	('Armory'),
	('Vendor'),
	('Secret');
GO

INSERT INTO Chapters.Shops
	(TypeID, ChapterID)
VALUES
	(1, 4),
	(1, 6),
	(2, 8),
	(1, 10),
	(1, 12),--5
	(2, 12),
	(2, 13),
	(1, 15),
	(2, 15),
	(1, 16),--10
	(2, 16),
	(1, 18),
	(2, 18),
	(1, 20),
	(1, 20),--15
	(2, 20),
	(2, 22),
	(1, 23),
	(2, 23),
	(1, 28),--20
	(1, 28),
	(2, 28),
	(2, 28),
	(1, 32),
	(1, 32),--25
	(2, 32),
	(2, 32),
	(1, 33),
	(1, 33),
	(2, 33),--30
	(2, 33),
	(1, 34),
	(2, 34),
	(1, 35),
	(2, 35),--35
	(1, 40),
	(2, 40),
	(1, 44),
	(1, 44),
	(1, 44),--40
	(1, 44),
	(2, 44),
	(2, 44),
	(3, 27),
	(3, 27),--45
	(3, 29),
	(3, 32),
	(3, 33),
	(3, 43),
	(3, 45);--50
GO

INSERT INTO Chapters.ShopWeapons
	(ShopID, WeaponID)
VALUES
	(1, 1),
	(1, 41),
	(2, 25),
	(2, 43),
	(2, 56),
	(3, 68),
	(3, 89),
	(4, 1),
	(4, 24),
	(4, 41),
	(4, 56),
	(5, 6),
	(5, 30),
	(5, 46),
	(5, 60),
	(6, 68),
	(6, 69),
	(6, 75),
	(6, 89),
	(8, 1),
	(8, 24),
	(8, 41),
	(8, 56),
	(10, 1),
	(10, 25),
	(10, 43),
	(10, 56),
	(11, 89),
	(12, 1),
	(12, 24),
	(12, 41),
	(12, 56),
	(13, 68),
	(13, 89),
	(14, 1),
	(14, 2),
	(14, 4),
	(14, 24),
	(14, 25),
	(14, 26),
	(15, 41),
	(15, 42),
	(15, 43),
	(15, 45),
	(15, 56),
	(15, 60),
	(16, 68),
	(16, 89),
	(17, 68),
	(17, 69),
	(17, 75),
	(17, 89),
	(17, 90),
	(18, 1),
	(18, 4),
	(18, 25),
	(18, 26),
	(18, 43),
	(18, 45),
	(18, 56),
	(18, 60),
	(19, 68),
	(19, 69),
	(19, 75),
	(19, 82),
	(19, 89),
	(19, 90),
	(20, 1),
	(20, 24),
	(20, 25),
	(20, 41),
	(20, 43),
	(20, 56),
	(21, 4),
	(21, 26),
	(21, 45),
	(21, 60),
	(22, 68),
	(22, 69),
	(22, 75),
	(22, 82),
	(22, 89),
	(22, 90),
	(24, 4),
	(24, 13),
	(24, 26),
	(24, 33),
	(24, 45),
	(24, 50),
	(24, 60),
	(25, 1),
	(25, 24),
	(25, 25),
	(25, 41),
	(25, 43),
	(25, 56),
	(26, 89),
	(26, 90),
	(26, 94),
	(27, 68),
	(27, 69),
	(27, 75),
	(27, 82),
	(28, 4),
	(28, 26),
	(28, 45),
	(28, 60),
	(29, 69),
	(29, 75),
	(29, 82),
	(29, 90),
	(30, 10),
	(30, 25),
	(30, 32),
	(30, 43),
	(30, 49),
	(30, 61),
	(31, 70),
	(31, 76),
	(31, 82),
	(31, 89),
	(31, 90),
	(32, 1),
	(32, 16),
	(32, 24),
	(32, 37),
	(32, 41),
	(32, 54),
	(32, 56),
	(32, 63),
	(33, 68),
	(33, 69),
	(33, 70),
	(33, 75),
	(33, 76),
	(33, 82),
	(33, 89),
	(34, 1),
	(34, 2),
	(34, 4),
	(34, 10),
	(34, 13),
	(34, 16),
	(35, 41),
	(35, 42),
	(35, 43),
	(35, 45),
	(35, 49),
	(35, 50),
	(35, 54),
	(36, 24),
	(36, 25),
	(36, 26),
	(36, 32),
	(36, 33),
	(36, 37),
	(37, 56),
	(37, 58),
	(37, 59),
	(37, 60),
	(37, 61),
	(37, 63),
	(38, 68),
	(38, 69),
	(38, 70),
	(38, 75),
	(38, 76),
	(38, 77),
	(38, 82),
	(39, 89),
	(39, 90),
	(39, 93),
	(39, 94),
	(44, 10),
	(44, 32),
	(44, 49),
	(44, 61),
	(45, 5),
	(45, 9),
	(45, 17),
	(45, 92),
	(45, 97),
	(46, 91),
	(46, 92),
	(46, 96),
	(46, 97),
	(47, 6),
	(47, 7),
	(47, 29),
	(47, 30),
	(47, 46),
	(47, 47),
	(48, 6),
	(48, 7),
	(48, 29),
	(48, 30),
	(48, 46),
	(48, 47),
	(50, 92),
	(50, 96),
	(50, 97);

INSERT INTO Chapters.ShopItems
	(ShopID, ItemID)
VALUES
	(3, 11),
	(6, 11),
	(7, 11),
	(9, 11),
	(11, 11),
	(13, 11),
	(16, 8),
	(16, 11),
	(19, 8),
	(19, 11),
	(23, 8),
	(23, 11),
	(23, 13),
	(23, 17),
	(26, 11),
	(26, 13),
	(33, 8),
	(39, 8),
	(39, 11),
	(39, 12),
	(39, 17),
	(44, 10),
	(44, 12),
	(44, 18),
	(46, 10),
	(46, 12),
	(46, 18),
	(47, 41),
	(49, 33),
	(49, 34),
	(49, 35),
	(49, 36),
	(49, 37),
	(50, 38),
	(50, 40),
	(50, 41);
GO




--VIEWS

--Weapon names, types, elements and effects
CREATE VIEW Inventory.VwWeaponDetails
AS
	SELECT W.Name AS 'Weapon',
		WT.Name AS 'Type',
		WE.Name AS 'Element',
		WEf.Description AS 'Effect'
	FROM Inventory.Weapons AS W
	JOIN Inventory.WeaponTypes AS WT
		ON W.TypeID = WT.TypeID
	LEFT JOIN Inventory.WeaponElements AS WE
		ON W.ElementID = WE.ElementID
	LEFT JOIN Inventory.WeaponWeaponEffects AS WWEf
		ON WWEf.WeaponID = W.WeaponID
	LEFT JOIN Inventory.WeaponEffects AS WEf
		ON WEf.EffectID = WWEf.EffectID;
GO

--Item names, uses, costs and effects
CREATE VIEW Inventory.VwItemDetails
AS
	SELECT I.Name AS 'Item',
		I.Uses,
		I.Cost,
		IE.Description AS 'Effect'
	FROM Inventory.Items AS I
	JOIN Inventory.ItemItemEffects AS IIE
		ON I.ItemID = IIE.ItemID
	JOIN Inventory.ItemEffects AS IE
		ON IE.EffectID = IIE.EffectID;
GO

--Chapters, their bosses, objectives, unlock requirements and notes
CREATE VIEW Chapters.VwChapterDetails
AS
	SELECT C.Name AS 'Chapter',
		O.Description AS 'Objective',
		B.Name AS 'Boss',
		R.Description AS 'Unlock requirements',
		N.Description AS 'Notes'
	FROM Chapters.Chapters AS C
	LEFT JOIN Units.Bosses AS B
		ON C.ChapterID = B.ChapterID
	JOIN Chapters.Objectives AS O
		ON C.ObjectiveID = O.ObjectiveID
	LEFT JOIN Chapters.ChapterNotes AS CN
		ON C.ChapterID = CN.ChapterID
	LEFT JOIN Chapters.Notes AS N
		ON CN.NoteID = N.NoteID
	LEFT JOIN Chapters.Requirements AS R
		ON R.RequirementID = C.RequirementID;
GO

--Classes, their notes and weapon types
CREATE VIEW Units.VwClassDetails
AS
	SELECT C.Name AS 'Class',
		N.Description AS 'Notes',
		WT.Name AS 'Weapon types'
	FROM Units.Classes AS C
	LEFT JOIN Units.ClassWeaponTypes AS CW
		ON C.ClassID = CW.ClassID
	JOIN Inventory.WeaponTypes AS WT
		ON CW.TypeID = WT.TypeID
	LEFT JOIN Units.ClassClassNotes AS CCN
		ON C.ClassID = CCN.ClassID
	LEFT JOIN Units.ClassNotes AS N
		ON CCN.NoteID = N.NoteID;
GO

--Class promotions and gains
CREATE VIEW Units.VwPromotionDetails
AS
	SELECT C1.Name AS 'Base Class',
		C2.Name AS 'Promoted Class',
		PG.HP AS 'HP gain',
		PG.StrengthMagic AS 'StrengthMagic gain',
		PG.Skill AS 'Skill gain',
		PG.Speed AS 'Speed gain',
		PG.Defense AS 'Defense gain',
		PG.Resistance AS 'Resistance gain',
		PG.Movement AS 'Movement gain',
		PG.Constitution AS 'Constitution gain',
		PG.Gender
	FROM Units.Promotions AS P
	JOIN Units.Classes AS C1
		ON P.BaseClassID = C1.ClassID
	JOIN Units.Classes AS C2
		ON P.PromotedClassID = C2.ClassID
	JOIN Units.PromotionGains AS PG
		ON P.GainID = PG.GainID;
GO

--Character starting classes and affinities
CREATE VIEW Units.VwCharDetails
AS
	SELECT CH.Name AS 'Character', C.Name AS 'Starting class', A.Name AS 'Affinity'
	FROM Units.Characters AS CH
	JOIN Units.Classes AS C
		ON CH.StartingClassID = C.ClassID
	JOIN Units.Affinities AS A
		ON CH.AffinityID = A.AffinityID;
GO

--Character growth rates
CREATE VIEW Units.VwCharGrowthRates
AS
	SELECT C.Name AS 'Character',
		GR.HP, GR.StrengthMagic,
		GR.Skill,
		GR.Speed,
		GR.Luck,
		GR.Defense,
		GR.Resistance
	FROM Units.Characters AS C
	JOIN Units.CharGrowthRates AS GR
		ON C.GrowthRateID = GR.GrowthRateID;
GO

--All possible character supports
CREATE VIEW Units.VwCharSupports
AS
	SELECT C1.Name AS 'Character 1',
		C2.Name AS 'Character 2',
		S.StartingPoints AS 'Starting points',
		S.PointsPerTurn AS 'Points gained per turn'
	FROM Units.Supports AS S
	JOIN Units.Characters AS C1
		ON S.Char1ID = C1.CharID
	JOIN Units.Characters AS C2
		ON S.Char2ID = C2.CharID;
GO

--Shops, their types and locations
CREATE VIEW Chapters.VwShopDetails
AS
	SELECT S.ShopID AS 'ShopID',
		T.Name AS 'Type',
		C.Name AS 'Chapter'
	FROM Chapters.Shops AS S
	JOIN Chapters.ShopTypes AS T
		ON T.TypeID = S.TypeID
	JOIN Chapters.Chapters AS C
		ON C.ChapterID = S.ChapterID;
GO
/*ShopID is included in VwShopDetails for the sake of the SpViewShopStock stored procedure,
which takes ShopID as a parameter. An easy way to look it up was needed.*/

--Bosses, their chapters and classes
CREATE VIEW Units.VwBossDetails
AS
	SELECT B.Name,
		CH.Name AS 'Chapter',
		C.Name AS 'Class'
	FROM Units.Bosses AS B
	JOIN Chapters.Chapters AS CH
		ON B.ChapterID = CH.ChapterID
	JOIN Units.Classes AS C
		ON B.ClassID = C.ClassID;
GO




--STORED PROCEDURES

--Viewing a character's supports
CREATE PROC SpViewSupports
	@Name varchar(15)
AS
	IF EXISTS (
		SELECT *
		FROM Units.Supports AS S
		JOIN Units.Characters AS C1
			ON S.Char1ID = C1.CharID
		JOIN Units.Characters AS C2
			ON S.Char2ID = C2.CharID
		WHERE C1.Name = @Name
			OR C2.Name = @Name)

		SELECT C1.Name AS 'Character 1',
			C2.Name AS 'Character 2',
			S.StartingPoints AS 'Starting points',
			S.PointsPerTurn AS 'Points gained per turn'
		FROM Units.Supports AS S
		JOIN Units.Characters AS C1
			ON S.Char1ID = C1.CharID
		JOIN Units.Characters AS C2
			ON S.Char2ID = C2.CharID
		WHERE C1.Name = @Name
			OR C2.Name = @Name;

	ELSE IF @Name = 'Nils'
		PRINT('Nils has no supports.');
	
	ELSE
		PRINT('That character was not found.');
GO

--Viewing a shop's stock
CREATE PROC SpViewShopStock
	@ShopID int
AS
	IF EXISTS (
		SELECT *
		FROM Chapters.ShopWeapons AS SW
		WHERE SW.ShopID = @ShopID)

		IF EXISTS (
			SELECT *
			FROM Chapters.ShopItems AS SI
			WHERE SI.ShopID = @ShopID)

			SELECT W.Name AS 'Weapon or item name',
				W.Cost
			FROM Inventory.Weapons AS W
			JOIN Chapters.ShopWeapons AS SW
				ON SW.WeaponID = W.WeaponID
			WHERE @ShopID = SW.ShopID
			UNION
			SELECT I.Name,
				I.Cost
			FROM Inventory.Items AS I
			JOIN Chapters.ShopItems AS SI
				ON I.ItemID = SI.ItemID
			WHERE @ShopID = SI.ShopID;

		ELSE
			SELECT W.Name AS 'Weapon name',
				W.Cost
			FROM Inventory.Weapons AS W
			JOIN Chapters.ShopWeapons AS SW
				ON SW.WeaponID = W.WeaponID
			WHERE @ShopID = SW.ShopID;

	ELSE IF EXISTS (
		SELECT *
		FROM Chapters.ShopItems AS SI
		WHERE SI.ShopID = @ShopID)

		SELECT I.Name AS 'Item name',
			I.Cost
		FROM Inventory.Items AS I
		JOIN Chapters.ShopItems AS SI
			ON I.ItemID = SI.ItemID
		WHERE @ShopID = SI.ShopID;
	
	ELSE
		PRINT('That shop was not found.');
GO
