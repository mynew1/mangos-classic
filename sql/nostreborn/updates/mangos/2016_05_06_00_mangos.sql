-- Prevent Horde Warlock to take twice the quest "In Search of Menara Voidrender"
-- Alliance quests already had their exclusive group set.
-- This closes #825
UPDATE quest_template SET ExclusiveGroup = 4737 WHERE entry IN (4736, 4739);

-- Prevent Shamans to take twice the quest "Call of Water"
-- This closes #826
UPDATE quest_template SET ExclusiveGroup = 1528 WHERE entry = 2986;

-- Fixed stats of NPC 5458 (Centipaad Worker)
-- This closes #828. Thanks @Phatcat for pointing.
UPDATE creature_template SET DamageMultiplier=1, MinMeleeDmg=81, MaxMeleeDmg=110, MinRangedDmg=0, MaxRangedDmg=0, MeleeAttackPower=200, RangedAttackPower=19, MeleeBaseAttackTime=2000, RangedBaseAttackTime=2000 WHERE Entry=5458;

-- Added start scripts for quest 5821 and 5943 in Desolace

-- Timers
SET @TIMER_RESPAWN := 10 * 60;
SET @TIMER_WAIT := 10 * 60;
SET @TIMER_YELL := 5 * 60;


SET @TEXTID  := 2000000399;
SET @FACTION := 113;

-- Set Kodos' GUIDs
SET @KODO1 := 27289;
SET @KODO2 := 28290;
SET @CORK := (SELECT `guid` FROM `creature` WHERE `id` = 11625);

-- Set quest scripts
UPDATE `quest_template` SET `StartScript` = 5821 WHERE `entry` = 5821;
UPDATE `quest_template` SET `StartScript` = 5943 WHERE `entry` = 5943;

-- Quest start scripts
DELETE FROM `dbscripts_on_quest_start` WHERE `id` IN (5943, 5821);
INSERT INTO `dbscripts_on_quest_start` VALUES
(5821, 0, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Cork - run off'),
(5821, 1, 25, 0, 0, 11626, 100, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Rigger - run off'),
(5821, 2, 25, 0, 0, 11564, @KODO1, 7 | 0x10, 0, 0, 0, 0, 0, 0, 0, 0, 'Kodo1 - run off'),
(5821, 3, 25, 0, 0, 11564, @KODO2, 7 | 0x10, 0, 0, 0, 0, 0, 0, 0, 0, 'Kodo2 - run off'),
(5821, 1, 29, 1+2, 0x02, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Remove quest and Gossip Flag'),
(5821, 4, 22, @FACTION, 0x01 | 0x08 | 0x12 | 0x20, 11626, 60, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Rigger - faction update'),
(5821, 5, 22, @FACTION, 0x01 | 0x08 | 0x12 | 0x20, 11564, @KODO1, 7 | 0x10, 0, 0, 0, 0, 0, 0, 0, 0, 'Kodo1 - faction update'),
(5821, 6, 22, @FACTION, 0x01 | 0x08 | 0x12 | 0x20, 11564, @KODO2, 7 | 0x10, 0, 0, 0, 0, 0, 0, 0, 0, 'Kodo2 - faction update'),
(5821, 6, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'unpause WP movement');
INSERT INTO `dbscripts_on_quest_start` VALUES
(5943, 0, 25, 0, 0, 11625, 100, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Cork - run off'),
(5943, 0, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Rigger - run off'),
(5943, 0, 25, 0, 0, 11564, @KODO1, 7 | 0x10, 0, 0, 0, 0, 0, 0, 0, 0, 'Kodo1 - run off'),
(5943, 0, 25, 0, 0, 11564, @KODO2, 7 | 0x10, 0, 0, 0, 0, 0, 0, 0, 0, 'Kodo2 - run off'),
(5943, 1, 29, 1+2, 0x02, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Remove quest and Gossip Flag'),
(5943, 0, 22, @FACTION, 0x01 | 0x08 | 0x12 | 0x20, 11625, 60, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Cork - faction update'),
(5943, 0, 22, @FACTION, 0x01 | 0x08 | 0x12 | 0x20, 11564, @KODO1, 7 | 0x10, 0, 0, 0, 0, 0, 0, 0, 0, 'Kodo1 - faction update'),
(5943, 0, 22, @FACTION, 0x01 | 0x08 | 0x12 | 0x20, 11564, @KODO2, 7 | 0x10, 0, 0, 0, 0, 0, 0, 0, 0, 'Kodo2 - faction update'),
(5943, 2, 32, 0, 0, 11625, 40, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Cork - unpause WP movement');

-- Prevent Rigger from being too far on some scripts
UPDATE `dbscripts_on_creature_movement` SET `search_radius` = 100 WHERE `id` IN (1162501, 11625209, 11625197) AND `search_radius` IN (40, 60);

-- Add reinit faction/speed script after "Gizelton Caravan" quest completion
UPDATE `creature_movement_template` SET `script_id` = 1162501 WHERE `entry` = 11625 AND `point` = 241;

-- Various NPC flag updates now SD2 is also in to ensure quests are only available when needed
DELETE FROM `dbscripts_on_creature_movement` WHERE `id` = 1162577 AND `command` = 29 AND `delay` = @TIMER_YELL;
INSERT INTO `dbscripts_on_creature_movement` VALUES
(1162577, @TIMER_YELL, 29, 2, 0x02, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Cork remove questgiver status');
DELETE FROM `dbscripts_on_creature_movement` WHERE `id` = 11625209 AND `command` = 29 AND `delay` = @TIMER_YELL;
INSERT INTO `dbscripts_on_creature_movement` VALUES
(11625209, @TIMER_YELL, 29, 2, 0x02, 11626, 100, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Rigger remove questgiver status');

UPDATE `creature_template` SET `ExtraFlags`='0' WHERE `Entry`='80';


-- Fixed spawn location of NPC 14467 (Kroshius) in Felwood
-- This closes #830
UPDATE creature SET position_x = 5800.89, position_y = -985.82, position_z = 409.78 WHERE id = 14467;


-- Fixed location of GO 300049 (TEMP Kroshius' Remains) in Felwood
-- Also changed it to its correct entry/name values
UPDATE gameobject_template SET entry = 179677, name = "Kroshius' Remains" WHERE entry = 300049;
UPDATE gameobject SET position_x = 5800.89, position_y = -985.82, position_z = 409.78 WHERE id = 300049;
UPDATE gameobject SET id = 179677 WHERE id = 300049;

-- Strider Clutchmother
UPDATE creature SET Spawndist = 0, MovementType = 2 WHERE id = 2172;
DELETE FROM creature_movement WHERE id = 37385;
UPDATE creature_template SET MovementType = 2 WHERE entry = 2172;
DELETE FROM creature_movement_template WHERE entry = 2172;
INSERT INTO creature_movement_template (entry, point, position_x, position_y, position_z, waittime, script_id, orientation, model1, model2) VALUES
(2172,1,4516.77,607.805,31.7845, 0, 0,4.53384, 0, 0),
(2172,2,4519.16,571.186,32.5817, 0, 0,4.43565, 0, 0),
(2172,3,4506.04,545.204,39.1878, 0, 0,3.97226, 0, 0),
(2172,4,4484.27,524.398,43.4054, 0, 0,4.18667, 0, 0),
(2172,5,4475.53,496.37,48.935, 0, 0,3.81125, 0, 0),
(2172,6,4462.23,486.497,50.0938, 0, 0,3.42248, 0, 0),
(2172,7,4448,483.935,50.4496, 0, 0,3.34001, 0, 0),
(2172,8,4414.98,478.825,57.0827, 0, 0,3.29681, 0, 0),
(2172,9,4375.29,464.64,61.9022, 0, 0,3.87801, 0, 0),
(2172,10,4351.72,441.123,60.2804, 0, 0,4.14897, 0, 0),
(2172,11,4346.24,420.217,60.9888, 0, 0,4.48276, 0, 0),
(2172,12,4339.67,403.893,61.593, 0, 0,3.97697, 0, 0),
(2172,13,4322.4,397.517,62.6931, 0, 0,3.16958, 0, 0),
(2172,14,4300.05,404.118,62.2459, 0, 0,2.77688, 0, 0),
(2172,15,4283.83,413.06,60.7891, 0, 0,2.32528, 0, 0),
(2172,16,4276.19,431.525,61.5429, 0, 0,1.65376, 0, 0),
(2172,17,4278.02,448.285,60.9137, 0, 0,1.10006, 0, 0),
(2172,18,4299.49,481.952,60.6362, 0, 0,0.797677, 0, 0),
(2172,19,4369.62,540.487,59.3641, 0, 0,0.648449, 0, 0),
(2172,20,4404.23,564.665,48.7928, 0, 0,0.664157, 0, 0),
(2172,21,4425.79,586.472,42.1827, 0, 0,0.986171, 0, 0),
(2172,22,4430.26,606.587,39.6061, 0, 0,1.40636, 0, 0),
(2172,23,4437.38,624.615,36.918, 0, 0,0.852653, 0, 0),
(2172,24,4455.5,639.752,31.2693, 0, 0,0.825164, 0, 0),
(2172,25,4474.88,666.869,26.2529, 0, 0,0.855009, 0, 0),
(2172,26,4500.03,694.421,24.5656, 0, 0,0.595828, 0, 0),
(2172,27,4513.71,706.448,23.2624, 0, 0,0.0970998, 0, 0),
(2172,28,4528.3,704.51,24.6299, 0, 0,6.03864, 0, 0),
(2172,29,4535.2,690.152,25.2516, 4000, 0,4.69955, 0, 0), -- let sync. with links
(2172,30,4520.51,660.629,24.7118, 0, 0,4.51498, 0, 0);

-- drop
DELETE FROM creature_loot_template WHERE  entry = 2172;
INSERT INTO creature_loot_template (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount, condition_id) VALUES
(2172,785,0.1,0,1,1,0),
(2172,1206,0.03,0,1,1,0),
(2172,1210,0.52,0,1,1,0),
(2172,1497,0.19,0,1,1,0),
(2172,1504,0.19,0,1,1,0),
(2172,1507,0.4,0,1,1,0),
(2172,1510,0.3,0,1,1,0),
(2172,1511,0.3,0,1,1,0),
(2172,1512,0.6,0,1,1,0),
(2172,1514,0.3,0,1,1,0),
(2172,1516,0.3,0,1,1,0),
(2172,1735,0.19,0,1,1,0),
(2172,2214,0.04,0,1,1,0),
(2172,2409,0.03,0,1,1,0),
(2172,2763,0.3,0,1,1,0),
(2172,3312,0.2,0,1,1,0),
(2172,3374,0.3,0,1,1,0),
(2172,3375,0.04,0,1,1,0),
(2172,3394,0.1,0,1,1,0),
(2172,4346,0.1,0,1,1,0),
(2172,4570,0.04,0,1,1,0),
(2172,4681,0.04,0,1,1,0),
(2172,4687,0.04,0,1,1,0),
(2172,4757,74,0,1,1,0),
(2172,4775,34.6032,0,1,1,0),
(2172,4776,12.0635,0,1,1,0),
(2172,5071,0.2,0,1,1,0),
(2172,5114,14,0,1,1,0),
(2172,5115,0.6,0,1,1,0),
(2172,5469,56,0,1,2,0),
(2172,5503,0.1,0,1,1,0),
(2172,6266,4,0,1,1,0),
(2172,6268,5,0,1,1,0),
(2172,6336,4,0,1,1,0),
(2172,6512,5,0,1,1,0),
(2172,6537,0.8,0,1,1,0),
(2172,6539,1.8,0,1,1,0),
(2172,6541,2,0,1,1,0),
(2172,6542,2,0,1,1,0),
(2172,6543,1.4,0,1,1,0),
(2172,6546,1,0,1,1,0),
(2172,6547,1.3,0,1,1,0),
(2172,6548,2,0,1,1,0),
(2172,6549,4,0,1,1,0),
(2172,6550,1.8,0,1,1,0),
(2172,6551,1.2,0,1,1,0),
(2172,6554,0.8,0,1,1,0),
(2172,6555,3,0,1,1,0),
(2172,6556,1.4,0,1,1,0),
(2172,6557,3,0,1,1,0),
(2172,6558,1.7,0,1,1,0),
(2172,6564,0.19,0,1,1,0),
(2172,6565,0.2,0,1,1,0),
(2172,6575,0.2,0,1,1,0),
(2172,6588,1.9048,0,1,1,0),
(2172,9746,0.8,0,1,1,0),
(2172,9747,12,0,1,1,0),
(2172,9748,2,0,1,1,0),
(2172,9749,2,0,1,1,0),
(2172,9755,0.7,0,1,1,0),
(2172,9756,12,0,1,1,0),
(2172,9757,1.2,0,1,1,0),
(2172,9759,0.6,0,1,1,0),
(2172,9762,0.8,0,1,1,0),
(2172,9763,11,0,1,1,0),
(2172,9765,1.4,0,1,1,0),
(2172,9785,1.5,0,1,1,0),
(2172,9786,3,0,1,1,0),
(2172,10405,0.6349,0,1,1,0),
(2172,10407,3.68,0,1,1,0),
(2172,14169,0.1,0,1,1,0),
(2172,15303,0.3,0,1,1,0),
(2172,15485,0.4,0,1,1,0),
(2172,15491,0.3,0,1,1,0),
(2172,17056,11,0,1,1,0),
(2172,24060,1,1,-24060,1,0),
(2172,24061,0.5,1,-24061,1,0),
(2172,24062,1,1,-24062,1,0),
(2172,24064,1,1,-24064,1,0),
(2172,24066,0.5,1,-24066,1,0),
(2172,24078,1,1,-24078,1,0);

-- Foreststrider Fledgling
-- missing added - UDB free guids reused
-- few duplicates removed
DELETE FROM creature WHERE guid IN (60816,36938,36942);
DELETE FROM creature_addon WHERE guid IN (60816,36938,36942);
DELETE FROM creature_movement WHERE id IN (60816,36938,36942);
DELETE FROM game_event_creature WHERE guid IN (60816,36938,36942);
DELETE FROM game_event_creature_data WHERE guid IN (60816,36938,36942);
DELETE FROM creature_battleground WHERE guid IN (60816,36938,36942);
DELETE FROM creature_linking WHERE guid IN (60816,36938,36942) OR master_guid IN (60816,36938,36942);
INSERT INTO creature (guid, id, map, modelid, equipment_id, position_x, position_y, position_z, orientation, spawntimesecs, spawndist, currentwaypoint, curhealth, curmana, DeathState, MovementType) VALUES 
(60816,2321,1,0,0,4519.65,662.168,24.5682,4.7561,275,0,0,222,0,0,0);
UPDATE creature_template SET SpeedWalk = 0.94 WHERE Entry = 2321;
-- links
DELETE FROM creature_linking WHERE guid IN (36692,60816);
INSERT INTO creature_linking (guid, master_guid, flag) VALUES
(36692, 37385, 1+2+128+512),
(60816, 37385, 1+2+128+512);

-- Lady Moongazer
-- movement type may not be correct
UPDATE creature SET Spawndist = 15, MovementType = 1 WHERE id = 2184;
UPDATE creature SET Spawndist = 15, MovementType = 1 WHERE id = 2184;
DELETE FROM creature_movement WHERE id = 37730;

-- drop
DELETE FROM creature_loot_template WHERE  entry = 2184;
INSERT INTO creature_loot_template (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount, condition_id) VALUES
(2184,858,1.1,0,1,1,0),
(2184,954,0.26,0,1,1,0),
(2184,955,0.52,0,1,1,0),
(2184,1179,2.5157,0,1,1,0),
(2184,1210,0.1,0,1,1,0),
(2184,1738,0.13,0,1,1,0),
(2184,1739,0.1,0,1,1,0),
(2184,1742,0.17,0,1,1,0),
(2184,1743,0.2,0,1,1,0),
(2184,1744,0.1,0,1,1,0),
(2184,1764,0.13,0,1,1,0),
(2184,1766,0.15,0,1,1,0),
(2184,1767,0.17,0,1,1,0),
(2184,1768,0.19,0,1,1,0),
(2184,1770,0.1,0,1,1,0),
(2184,1787,0.2,0,1,1,0),
(2184,1789,0.2,0,1,1,0),
(2184,1791,0.2,0,1,1,0),
(2184,1792,0.13,0,1,1,0),
(2184,1793,0.3,0,1,1,0),
(2184,1794,0.3,0,1,1,0),
(2184,1811,0.4,0,1,1,0),
(2184,1812,0.2,0,1,1,0),
(2184,1813,0.19,0,1,1,0),
(2184,1814,0.3,0,1,1,0),
(2184,1815,0.17,0,1,1,0),
(2184,1816,0.4,0,1,1,0),
(2184,1817,0.3,0,1,1,0),
(2184,2216,0.17,0,1,1,0),
(2184,2217,0.2,0,1,1,0),
(2184,2449,0.26,0,1,1,0),
(2184,2453,0.26,0,1,1,0),
(2184,2455,0.87,0,1,1,0),
(2184,2589,21,0,1,1,0),
(2184,2592,19,0,1,1,0),
(2184,2657,0.26,0,1,1,0),
(2184,2698,0.26,0,1,1,0),
(2184,2764,0.2,0,1,1,0),
(2184,2780,0.4,0,1,1,0),
(2184,2781,0.3,0,1,1,0),
(2184,3012,0.78,0,1,1,0),
(2184,3036,0.13,0,1,1,0),
(2184,3309,0.1,0,1,1,0),
(2184,3376,0.17,0,1,1,0),
(2184,4537,4.74,0,1,1,0),
(2184,4567,0.1,0,1,1,0),
(2184,4570,0.1,0,1,1,0),
(2184,4605,4,0,1,1,0),
(2184,5503,0.26,0,1,1,0),
(2184,6536,0.8,0,1,1,0),
(2184,6537,2,0,1,1,0),
(2184,6538,0.5,0,1,1,0),
(2184,6539,8,0,1,1,0),
(2184,6540,1.9,0,1,1,0),
(2184,6541,7,0,1,1,0),
(2184,6542,3,0,1,1,0),
(2184,6543,2,0,1,1,0),
(2184,6545,2,0,1,1,0),
(2184,6546,3,0,1,1,0),
(2184,6547,3,0,1,1,0),
(2184,6548,12,0,1,1,0),
(2184,6550,1.7,0,1,1,0),
(2184,6551,3,0,1,1,0),
(2184,6552,1.2,0,1,1,0),
(2184,6553,2,0,1,1,0),
(2184,6554,3,0,1,1,0),
(2184,6556,1.7,0,1,1,0),
(2184,6557,9,0,1,1,0),
(2184,6558,3,0,1,1,0),
(2184,9748,1.8,0,1,1,0),
(2184,9749,2,0,1,1,0),
(2184,9757,1.9,0,1,1,0),
(2184,9765,2,0,1,1,0),
(2184,9767,0.6,0,1,1,0),
(2184,9768,1.1,0,1,1,0),
(2184,9770,0.5,0,1,1,0),
(2184,9775,0.5,0,1,1,0),
(2184,9777,0.5,0,1,1,0),
(2184,9779,2,0,1,1,0),
(2184,9784,0.7,0,1,1,0),
(2184,9785,3,0,1,1,0),
(2184,9786,7,0,1,1,0),
(2184,9787,0.7,0,1,1,0),
(2184,9788,2,0,1,1,0),
(2184,9789,0.6,0,1,1,0),
(2184,14114,0.15,0,1,1,0),
(2184,15210,0.3,0,1,1,0),
(2184,15268,0.1,0,1,1,0),
(2184,15304,0.19,0,1,1,0),
(2184,15487,0.17,0,1,1,0),
(2184,24060,1,1,-24060,1,0),
(2184,24062,1,1,-24062,1,0),
(2184,24064,1,1,-24064,1,0),
(2184,24070,5,1,-24070,1,0),
(2184,24077,1,1,-24077,1,0),
(2184,24078,1,1,-24078,1,0);

-- Carnivous the Breaker

-- 1st spawn
UPDATE creature SET position_x = 5863.106445, position_y = 311.400116, position_z = 20.810015, orientation = 0.333024 WHERE guid = 51900;
-- 2nd spawn
-- missing added - UDB free guids reused
DELETE FROM creature WHERE guid = 36938;
DELETE FROM creature_addon WHERE guid = 36938;
DELETE FROM creature_movement WHERE id = 36938;
DELETE FROM game_event_creature WHERE guid = 36938;
DELETE FROM game_event_creature_data WHERE guid = 36938;
DELETE FROM creature_battleground WHERE guid = 36938;
DELETE FROM creature_linking WHERE guid = 36938 OR master_guid = 36938;
INSERT INTO creature (guid, id, map, modelid, equipment_id, position_x, position_y, position_z, orientation, spawntimesecs, spawndist, currentwaypoint, curhealth, curmana, DeathState, MovementType) VALUES 
(36938,2186,1,0,0,4904.43,328.846,36.7678,6.16146,9900,0,0,356,0,0,0);

-- Only one can be spawned at at the same time
DELETE FROM pool_template WHERE entry = 1214;
INSERT INTO pool_template (entry, max_limit, description) VALUES 
(1214,1,'Carnivous the Breaker - 2186');
DELETE FROM pool_creature_template WHERE pool_entry = 1214;
INSERT INTO pool_creature_template (id, pool_entry, chance, description) VALUES
(2186, 1214, 0, 'Carnivous the Breaker - 2186');

-- drop
DELETE FROM creature_loot_template WHERE  entry = 2186;
INSERT INTO creature_loot_template (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount, condition_id) VALUES
(2186,856,0.75,0,1,1,0),
(2186,858,1.6,0,1,1,0),
(2186,954,0.5,0,1,1,0),
(2186,955,0.26,0,1,1,0),
(2186,1179,3.8,0,1,1,0),
(2186,1180,0.5,0,1,1,0),
(2186,1206,0.08,0,1,1,0),
(2186,1210,0.5,0,1,1,0),
(2186,1739,0.2,0,1,1,0),
(2186,1740,0.16,0,1,1,0),
(2186,1742,0.3,0,1,1,0),
(2186,1743,0.2,0,1,1,0),
(2186,1744,0.12,0,1,1,0),
(2186,1764,0.14,0,1,1,0),
(2186,1766,0.18,0,1,1,0),
(2186,1767,0.16,0,1,1,0),
(2186,1769,0.4,0,1,1,0),
(2186,1770,0.18,0,1,1,0),
(2186,1787,0.16,0,1,1,0),
(2186,1789,0.3,0,1,1,0),
(2186,1791,0.2,0,1,1,0),
(2186,1792,0.18,0,1,1,0),
(2186,1793,0.1,0,1,1,0),
(2186,1794,1,0,1,1,0),
(2186,1811,0.14,0,1,1,0),
(2186,1812,0.18,0,1,1,0),
(2186,1813,0.18,0,1,1,0),
(2186,1814,0.2,0,1,1,0),
(2186,1815,0.4,0,1,1,0),
(2186,1816,0.3,0,1,1,0),
(2186,1817,0.2,0,1,1,0),
(2186,2217,0.1,0,1,1,0),
(2186,2287,0.08,0,1,1,0),
(2186,2447,0.26,0,1,1,0),
(2186,2455,2.28,0,1,1,0),
(2186,2589,19,0,1,3,0),
(2186,2592,27.1739,0,1,2,0),
(2186,2764,0.14,0,1,1,0),
(2186,2780,0.14,0,1,1,0),
(2186,2781,0.2,0,1,1,0),
(2186,2996,0.26,0,1,1,0),
(2186,3012,0.26,0,1,1,0),
(2186,3040,0.12,0,1,1,0),
(2186,3376,0.16,0,1,1,0),
(2186,3377,0.14,0,1,1,0),
(2186,4537,5,0,1,1,0),
(2186,5578,0.26,0,1,1,0),
(2186,6342,0.26,0,1,1,0),
(2186,6536,3,0,1,1,0),
(2186,6538,4,0,1,1,0),
(2186,6540,5,0,1,1,0),
(2186,6545,4,0,1,1,0),
(2186,6552,4,0,1,1,0),
(2186,6553,5,0,1,1,0),
(2186,6562,2,0,1,1,0),
(2186,6563,2,0,1,1,0),
(2186,6564,1.9,0,1,1,0),
(2186,6565,0.9,0,1,1,0),
(2186,6570,0.8,0,1,1,0),
(2186,6574,1,0,1,1,0),
(2186,6575,1.7,0,1,1,0),
(2186,6576,0.8,0,1,1,0),
(2186,6581,2,0,1,1,0),
(2186,6582,0.8,0,1,1,0),
(2186,6583,2,0,1,1,0),
(2186,6585,1.7,0,1,1,0),
(2186,9766,2,0,1,1,0),
(2186,9767,4,0,1,1,0),
(2186,9768,4,0,1,1,0),
(2186,9770,5,0,1,1,0),
(2186,9771,2,0,1,1,0),
(2186,9772,0.5,0,1,1,0),
(2186,9775,4,0,1,1,0),
(2186,9776,2,0,1,1,0),
(2186,9777,4,0,1,1,0),
(2186,9779,4,0,1,1,0),
(2186,9780,2,0,1,1,0),
(2186,9781,0.5,0,1,1,0),
(2186,9783,1.9,0,1,1,0),
(2186,9784,4,0,1,1,0),
(2186,9787,4,0,1,1,0),
(2186,9788,4,0,1,1,0),
(2186,9789,3,0,1,1,0),
(2186,9812,0.6,0,1,1,0),
(2186,10287,0.7,0,1,1,0),
(2186,10405,0.3,0,1,1,0),
(2186,10407,0.6,0,1,1,0),
(2186,15114,0.1,0,1,1,0),
(2186,15310,0.02,0,1,1,0),
(2186,15508,0.12,0,1,1,0),
(2186,24060,1,1,-24060,1,0),
(2186,24062,1,1,-24062,1,0),
(2186,24070,5,1,-24070,1,0),
(2186,24071,5,1,-24071,1,0),
(2186,24075,1,1,-24075,1,0),
(2186,24076,1,1,-24076,1,0),
(2186,24077,1,1,-24077,1,0),
(2186,24078,1,1,-24078,1,0);
