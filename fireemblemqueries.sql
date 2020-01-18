--Obtaining and rating characters' total growths: practice with CONVERT, CASE, CTEs
WITH T AS (
	SELECT G.GrowthRateID,
		   SUM(CONVERT(int, G.HP) +
			   CONVERT(int, G.StrengthMagic) +
			   CONVERT(int, G.Skill) +
			   CONVERT(int, G.Speed) +
			   CONVERT(int, G.Luck) +
			   CONVERT(int, G.Defense) +
			   CONVERT(int, G.Resistance)
	) AS 'TotalGrowths'
	FROM Units.CharGrowthRates AS G
	GROUP BY G.GrowthRateID
)
SELECT C.Name AS 'Character',
	T.TotalGrowths,
	CASE WHEN T.TotalGrowths >= 350
			THEN 'A+'
		WHEN T.TotalGrowths >= 330
			THEN 'A'
		WHEN T.TotalGrowths >= 315
			THEN 'B+'
		WHEN T.TotalGrowths >= 305
			THEN 'B'
		WHEN T.TotalGrowths >= 300
			THEN 'C+'
		WHEN T.TotalGrowths >= 285
			THEN 'C'
		WHEN T.TotalGrowths >= 270
			THEN 'D+'
		WHEN T.TotalGrowths >= 250
			THEN 'D'
		ELSE 'F'
		END AS 'Grade'
FROM Units.Characters AS C
JOIN T
	ON C.GrowthRateID = T.GrowthRateID
ORDER BY T.TotalGrowths DESC;


--Shops that sell only vulneraries: practice with subqueries (semi-joins & anti-joins), "red marble logic"
SELECT S.ShopID,
	S.Type,
	S.Chapter
FROM Chapters.VwShopDetails AS S
WHERE S.ShopID IN (
		SELECT SI.ShopID
		FROM Chapters.ShopItems AS SI
		)
	AND S.ShopID NOT IN (
		SELECT SI2.ShopID
		FROM Chapters.ShopItems AS SI2
		JOIN Inventory.Items AS I
			ON SI2.ItemID = I.ItemID
		WHERE I.Name <> 'Vulnerary'
		)
	AND S.ShopID NOT IN (
		SELECT SW.ShopID
		FROM Chapters.ShopWeapons AS SW
		)
ORDER BY S.ShopID;


--Shops that sell only items (no weapons): EXCEPT example
SELECT SI.ShopID,
	SD.Type,
	SD.Chapter
FROM Chapters.ShopItems AS SI
JOIN Chapters.VwShopDetails AS SD
	ON SI.ShopID = SD.ShopID
EXCEPT
SELECT SW.ShopID,
	SD.Type,
	SD.Chapter
FROM Chapters.ShopWeapons AS SW
JOIN Chapters.VwShopDetails AS SD
	ON SW.ShopID = SD.ShopID;


--The ten strongest weapons: practice with SELECT TOP, window functions, correlated subqueries
SELECT TOP 10 W.Name, (
	SELECT WT.Name
	FROM Inventory.WeaponTypes AS WT
	WHERE W.TypeID = WT.TypeID
	) AS 'Type',
	W.Might AS 'Might',
	RANK() OVER(ORDER BY W.Might DESC) AS 'Rank'
FROM Inventory.Weapons AS W
ORDER BY 'Rank', W.Name;


--The tenth strongest weapon: practice with OFFSET & FETCH
SELECT W.Name, (
	SELECT WT.Name
	FROM Inventory.WeaponTypes AS WT
	WHERE W.TypeID = WT.TypeID
	) AS 'Type',
	W.Might AS 'Might'
FROM Inventory.Weapons AS W
ORDER BY W.Might DESC
	OFFSET 9 ROWS
	FETCH NEXT 1 ROWS ONLY;


--The ten weakest weapons (excluding those with NULL Might): more OFFSET practice
SELECT W.Name, (
	SELECT WT.Name
	FROM Inventory.WeaponTypes AS WT
	WHERE W.TypeID = WT.TypeID
	) AS 'Type',
	W.Might AS 'Might'
FROM Inventory.Weapons AS W
WHERE W.Might IS NOT NULL
ORDER BY W.Might DESC, W.Name
	OFFSET (
		SELECT COUNT(*)
		FROM Inventory.Weapons AS W
		WHERE W.Might IS NOT NULL
		) - 10 ROWS;


--Average character growth rates by gender: practice with aggregates & GROUP BY
SELECT C.Gender,
	COUNT(C.CharID) AS 'Total Characters',
	AVG(G.HP) AS 'Avg HP growth',
	AVG(G.StrengthMagic) AS 'Avg Strength/Magic growth',
	AVG(G.Skill) AS 'Avg Skill growth',
	AVG(G.Speed) AS 'Avg Speed growth',
	AVG(G.Luck) AS 'Avg Luck growth',
	AVG(G.Defense) AS 'Avg Defense growth',
	AVG(G.Resistance) AS 'Avg Resistance growth'
FROM Units.Characters AS C
JOIN Units.CharGrowthRates AS G
	ON C.GrowthRateID = G.GrowthRateID
GROUP BY C.Gender;


--Characters' Speed growths compared to the average: more subquery practice
SELECT C.Name,
	G.Speed AS 'Speed growth',
	G.Speed - (
		SELECT AVG(G.Speed)
		FROM Units.CharGrowthRates AS G
		) AS 'Deviation from avg'
FROM Units.Characters AS C
JOIN Units.CharGrowthRates AS G
	ON C.GrowthRateID = G.GrowthRateID
ORDER BY 'Deviation from avg' DESC, C.Name;


--Enemy bosses who are also playable characters: INTERSECT example
SELECT C.Name
FROM Units.Characters AS C
INTERSECT
SELECT B.Name
FROM Units.Bosses AS B;


--Chapters with more than one boss: self join practice
SELECT DISTINCT C.Name AS 'Chapters with multiple bosses'
FROM Chapters.Chapters AS C
JOIN Units.Bosses AS B1
	ON C.ChapterID = B1.ChapterID
JOIN Units.Bosses AS B2
	ON B1.ChapterID = B2.ChapterID
	AND B1.Name <> B2.Name
ORDER BY C.Name;