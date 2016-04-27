ALTER TABLE db_version CHANGE COLUMN required_z2683_a0002_01_mangos_mangos_string required_z2683_a0003_01_mangos_spell_bonus_data bit;

UPDATE `mangos_string` SET `content_default` = 'Spell %u %s = %f (*1.88 = %f) DB = %f' WHERE `entry` = 1202;

ALTER TABLE `spell_bonus_data` DROP COLUMN `ap_bonus`, DROP COLUMN `ap_dot_bonus`; 