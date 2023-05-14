#!/bin/bash

# Загружаем переменные окружения
source .env

# Определяем имя контейнера базы данных
DB_CONTAINER=app_db

# Определяем имя пользователя и имя базы данных
POSTGRES_USER=$POSTGRES_USER
POSTGRES_DB=$POSTGRES_DB

# Определяем путь к папке для дампов
DUMP_PATH=./pg_dumps

# Создаем папку для дампов, если она еще не существует
mkdir -p $DUMP_PATH

# Определяем имя файла дампа
DUMP_FILE=$DUMP_PATH/pg_dump_$(date +%Y%m%d).sql

# Создаем дамп базы данных
docker exec $DB_CONTAINER pg_dump -U $POSTGRES_USER -d $POSTGRES_DB > "$DUMP_FILE"

# Если в папке с дампами больше 10 файлов, удаляем самый старый
# shellcheck disable=SC2046
# shellcheck disable=SC2012
if [ $(ls $DUMP_PATH/*.sql | wc -l) -gt 10 ]; then
  rm -f $(ls -t $DUMP_PATH/*.sql | tail -1)
fi