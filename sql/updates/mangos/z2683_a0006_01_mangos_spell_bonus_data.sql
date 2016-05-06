ALTER TABLE db_version CHANGE COLUMN required_z2683_a0005_01_mangos_spell_bonus_data required_z2683_a0006_01_mangos_spell_bonus_data bit;

DELETE FROM `spell_bonus_data` WHERE `entry` = 25742;
INSERT INTO `spell_bonus_data` (`entry`, `comments`) VALUES
(25742, 'Paladin - Holy Light trigger');

DELETE FROM `spell_chain` WHERE `spell_id` IN (25742, 25740, 25739, 25738, 25737, 25736, 25735, 25713);
INSERT INTO `spell_chain` (`spell_id`, `prev_spell`, `first_spell`, `rank`) VALUES
(25742, 0, 25742, 1),
(25740, 25742, 25742, 2),
(25739, 25740, 25742, 3),
(25738, 25739, 25742, 4),
(25737, 25738, 25742, 5),
(25736, 25737, 25742, 6),
(25735, 25736, 25742, 7),
(25713, 25735, 25742, 8);