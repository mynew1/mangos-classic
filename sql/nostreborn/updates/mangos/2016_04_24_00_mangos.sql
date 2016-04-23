-- Removing extra mining nodes that were stacked on each other in the entrace to Deadmines (Outside instance)
DELETE FROM gameobject
WHERE guid IN (
78905,
78906,
78910,
78912,
78914,
78915,
78917,
78918,
78920,
78921,
78932,
78933,
78940,
78942,
78943,
78945,
78953,
78954,
78956,
78957,
78958,
78960,
78998,
78999,
79037,
79038,
79124,
79125,
79165,
79167,
79175,
79176,
79187,
79188,
79214,
79215,
79309,
79311,
79342,
79344,
79372,
79374,
105205,
105207);

-- Removed some Defias Thugs at human starting zone. 
DELETE FROM creature
WHERE guid IN (
80150,
80171,
80187,
80189,
80199,
80200,
80209,
80223,
80244,
80258,
80259); 

-- Added adiitional quest object Milly's Harvest
INSERT INTO gameobject (id, position_x, position_y, position_z)
VALUES 
(161557, 9055.840820, -350.161163, 73.452797),
(161557, 9069.029297, -340.000397, 73.452797 ),
(161557, 9086.000977, -352.894165, 73.452797 ),
(161557, 9063.222656, -292.664307, 73.452797 ),
(161557, 9087.000977, -347.779144, 73.452797 ),
(161557, 9063.184570, -368.830017, 73.452797 );

-- Added Mailbox to Kharanos
INSERT INTO gameobject (id,position_x,position_y,position_z)
VALUES (171699, 5596.737305, -506.451141, 401.063782); 

-- Changed the respawn time of Elites in Redridge. 
UPDATE creature SET spawntimesecs = 600 WHERE id IN(4065, 436, 4064, 486, 4462, 4464, 334, 435);

-- Move Old Serra'kis mob in BFD so it is not stuck in wall
UPDATE creature SET position_x = -787.940735, position_y = -174.017853, position_z = -39.832016 WHERE id = 4830;

--  Delete the extra Blackrock Sentry in Redridge
DELETE FROM creature WHERE id IN (18435);

-- Set permissions for GMs (No world-altering commands included) 
UPDATE command SET security = 1 WHERE name IN ('character rename', 'npc say', 'npc yell', 'baninfo account','baninfo character','account characters');  
UPDATE command SET security=1 WHERE name LIKE 'lookup%';  
