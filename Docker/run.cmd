docker pull mayanedms/mayanedms:s4
docker pull postgres:12.9-alpine
docker pull redis:6.2-alpine

mkdir -p ~/docker-volumes/mayan-edms/postgres
mkdir -p ~/docker-volumes/mayan-edms/redis
mkdir -p ~/docker-volumes/mayan-edms/media

docker run \
-d \
--name mayan-edms-postgres \
--restart=always \
-p 5432:5432 \
-e POSTGRES_USER=mayan \
-e POSTGRES_DB=mayan \
-e POSTGRES_PASSWORD=mayanuserpass \
-v /Users/neeraj/docker-volumes/mayan-edms/postgres:/var/lib/postgresql/data \
postgres:12.9-alpine


docker run -d \
--name mayan-edms-redis \
--restart=always \
-p 6379:6379 \
-v /Users/neeraj/docker-volumes/mayan-edms/redis:/data \
redis:6.2-alpine \
redis-server \
--databases \
"3" \
--maxmemory-policy \
allkeys-lru \
--save \
"" \
--requirepass mayanredispassword


docker run -d \
--privileged \
--name mayan-edms \
--restart=always \
-p 80:8000 \
-e MAYAN_CELERY_BROKER_URL="redis://:mayanredispassword@172.17.0.1:6379/0" \
-e MAYAN_CELERY_RESULT_BACKEND="redis://:mayanredispassword@172.17.0.1:6379/1" \
-e MAYAN_DATABASES="{'default':{'ENGINE':'django.db.backends.postgresql','NAME':'mayan','PASSWORD':'mayanuserpass','USER':'mayan','HOST':'172.17.0.1'}}" \
-e MAYAN_LOCK_MANAGER_BACKEND="mayan.apps.lock_manager.backends.redis_lock.RedisLock" \
-e MAYAN_LOCK_MANAGER_BACKEND_ARGUMENTS="{'redis_url':'redis://:mayanredispassword@172.17.0.1:6379/2'}" \
-v /Users/neeraj/docker-volumes/mayan-edms/media:/var/lib/mayan \
mayanedms/mayanedms:s4
