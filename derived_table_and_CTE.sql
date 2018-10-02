-- SQLite

-- derived table
SELECT * 
FROM Sale AS s
JOIN (
  SELECT Name, Year, CarID
  FROM car
  WHERE Year = 2015) AS t
    ON s.CarID = t.CarID;

-- common table expression
WITH Janis_sched AS (
  SELECT period_id, s.name
  FROM teachers AS t
  JOIN classes AS c
    ON t.ID = c.subject_id
  JOIN subjects AS s
    ON s.ID = c.subject_id
  WHERE t.ID = 391
)
SELECT p.id, j.name
FROM periods AS p
LEFT OUTER JOIN Janis_sched AS j
  ON p.id = j.period_ID;
