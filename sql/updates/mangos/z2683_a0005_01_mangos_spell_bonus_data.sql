ALTER TABLE db_version CHANGE COLUMN required_z2683_a0004_01_mangos_spell_bonus_data required_z2683_a0005_01_mangos_spell_bonus_data bit;

DELETE FROM `spell_bonus_data` WHERE `entry` IN (19968, 19993);
INSERT INTO `spell_bonus_data` (`entry`, `comments`) VALUES
(19968, 'Paladin - Holy Light trigger'),
(19993, 'Paladin - Flash of Light trigger'); 