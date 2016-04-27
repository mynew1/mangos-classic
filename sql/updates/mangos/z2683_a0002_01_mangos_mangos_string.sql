ALTER TABLE db_version CHANGE COLUMN required_z2683_a0001_01_mangos_spell_elixir required_z2683_a0002_01_mangos_mangos_string bit;

UPDATE `mangos_string` SET `content_default`='Legionnaire ' WHERE `entry`= 1421;