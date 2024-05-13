#!/opt/homebrew/bin/bash

## variables
container_name="mongo"
container_host="localhost"
container_username="admin"
container_password="admin123"
container_db="admin"

json_content=$(cat <<EOF
db.createUser({
	user: "$container_username",
	pwd: "$container_password",
	roles: [{
		role: "readWrite",
		db: "$container_db"
	}]
});
EOF
)

check_container(){
   echo "Checking availability container"
   docker_mongo_container_check_cmd="docker ps | grep $container_name"
   is_present=$(eval $docker_mongo_container_check_cmd)
   if [ $? -ne 0 ]
   then
      echo "Mongo db container is not available, creating it"
      docker run -dit -p 27017:27017 --name=$container_name mongo:latest
      sleep 45
      is_present=$(eval $docker_mongo_container_check_cmd)
      [[ $? -ne 0 ]] && echo "unable to install container" && exit 1
   fi
   echo -e "Container is available - $container_name \n"
}
check_db(){
   echo "Checking if db is available"
   is_db_present=$(docker exec -i $container_name sh -c "mongosh  -eval 'show dbs'" | grep $container_db)
   [[ $? -ne 0 ]] &&  echo "DB is not available" && exit 1
   echo -e "DB is available - $container_db \n"
}
check_authentication(){
   echo "Checking if user is available"
   is_authenticated=$(docker exec $container_name sh -c "mongosh  --username $container_username --password $container_password --authenticationDatabase $container_db --quiet")
   if [[ $? -ne 0 ]]
   then
      echo "Unable to find user, creating it"
      docker exec $container_name mongosh --quiet --eval "use $container_db" --eval "${json_content}"
      [[ $? -ne 0 ]] && echo "unable to create user" && exit 1
      echo "Successfully able to create user - "
   fi
   echo "User is already available - $container_username@$container_db"
}

## check if mongo db is present in docker
check_container
check_db
check_authentication
   




