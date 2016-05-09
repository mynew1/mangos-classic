ALTER TABLE db_version CHANGE COLUMN required_z2683_a0007_01_mangos_spell_bonus_data required_z2683_a0008_01_mangos_spell_bonus_data bit;

DELETE FROM `spell_bonus_data` WHERE `entry` IN (20911, 20912, 20913, 20914, 18220, 18937, 18938, 8680, 8685, 8689, 11335, 11336, 2818, 2819, 11353, 11354, 25349);
INSERT INTO `spell_bonus_data` (`entry`, `comments`) VALUES
(20911, 'Paladin - Blessing of Sanctuary'),
(18220, 'Warlock - Dark Pact'),
(2818, 'Rogue - Deadly Poison'),
(8680, 'Rogue - Instant Poison');