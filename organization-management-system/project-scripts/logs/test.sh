#!/opt/homebrew/bin/bash

## variables
container_name="mongo"
container_host="localhost"
container_username="tomcat"
container_password="tomcat123"
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
EOF)


echo "json contents  - $json_content"

echo "inserting user into db"

docker exec mongo mongosh --authenticationDatabase $container_db --eval "$json_content"


docker exec $container_name sh -c "mongosh  --username $container_username --password $container_password --authenticationDatabase test --quiet"
