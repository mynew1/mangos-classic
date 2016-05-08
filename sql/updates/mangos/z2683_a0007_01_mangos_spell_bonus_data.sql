ALTER TABLE db_version CHANGE COLUMN required_z2683_a0006_01_mangos_spell_bonus_data required_z2683_a0007_01_mangos_spell_bonus_data bit;

DELETE FROM `spell_bonus_data` WHERE `entry` IN (20187, 20280, 20281, 20282, 20283, 20284, 20285, 20286, 20424);
INSERT INTO `spell_bonus_data` (`entry`, `direct_bonus`, `comments`) VALUES
(20187, 0.5, 'Paladin - Judgement of Righteousness');

DELETE FROM `spell_chain` WHERE `entry` IN (20187, 20280, 20281, 20282, 20283, 20284, 20285, 20286);
INSERT INTO `spell_chain` (`spell_id`, `prev_spell`, `first_spell`, `rank`) VALUES
(20187, 0, 20187, 1),
(20280, 20187, 20187, 2),
(20281, 20280, 20187, 3),
(20282, 20281, 20187, 4),
(20283, 20282, 20187, 5),
(20284, 20283, 20187, 6),
(20285, 20284, 20187, 7),
(20286, 20285, 20187, 8);