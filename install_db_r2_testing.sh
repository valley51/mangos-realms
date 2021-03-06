#!/bin/bash

cd playerbot

function run_world_sql
{
	echo "Running $1..."
	mysql -uroot -p1 r2_world_testing < $1
}

function run_characters_sql
{
	echo "Running $1..."
	mysql -uroot -p1 r2_characters_testing < $1
}

function run_realm_sql
{
	echo "Running $1..."
	mysql -uroot -p1 r2_realm_testing < $1
}

function run_sd2_sql
{
	echo "Running $1..."
	mysql -uroot -p1 r2_scripts_testing < $1
}

cd sql/updates
#run_world_sql 12540_01_mangos_command.sql
run_characters_sql 12562_01_characters_various_tables.sql

cd ../../sql_mr

run_world_sql custom_mangos_tables.sql
run_world_sql custom_rerun_every_mangos_DB_update.sql

for sql in $(ls mr*mangos*.sql)
do
	run_world_sql $sql
done

run_characters_sql custom_characters_tables.sql

for sql in $(ls mr*characters*.sql)
do
	run_characters_sql $sql
done

run_realm_sql custom_realmd_tables.sql

for sql in $(ls mr*realmd*.sql)
do
	run_realm_sql $sql
done

cd ../sql
run_characters_sql characters_armory.sql
run_characters_sql characters_armory_2.sql
run_characters_sql characters_auctionhousebot.sql
#run_characters_sql characters_ai_playerbot.sql
#run_characters_sql characters_ai_playerbot_names.sql
run_world_sql mangos_indexes.sql


cd ../src/bindings/scriptdev2r2/sql
run_world_sql mangos_scriptname_clear.sql
run_world_sql mangos_scriptname_full.sql

run_sd2_sql scriptdev2_create_structure_mysql.sql
run_sd2_sql scriptdev2_script_full.sql

cd ../sql_mr/
for sql in $(ls mr*mangos*.sql)
do
	run_world_sql $sql
done

run_world_sql last_mangos_sql_at_every_db_update.sql
run_sd2_sql custom_scriptdev2_bsw_table.sql

for sql in $(ls mr*scriptdev2*.sql)
do
	run_sd2_sql $sql
done

echo "Done. Press ENTER"
read