#!/opt/homebrew/bin/bash

# Define the directory of the script
SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
OMS_DIR="$(cd .. &> /dev/null && pwd)"

# Check if java is installed
java_version=$(java -version 2>&1 | grep "1.8")
if [ -z "$java_version" ]; then
    echo "Java 1.8 is not installed."
    exit 1
fi

# Check if Maven is installed
mvn_version=$(mvn -version 2>&1 | grep "Apache Maven")
if [ -z "$mvn_version" ]; then
    echo "Maven is not installed."
    exit 1
fi

## check if logs directory is present
[[ ! -d $SCRIPT_DIR/logs ]] && mkdir $SCRIPT_DIR/logs

## setting up env var
set -a
source $SCRIPT_DIR/application.properties
set +a

modules_list=(
    "config-service=8888"
    "employee-service=8081"
    "department-service=8082"
    "organization-service=8083" 
    "gateway-service=8111"
)

# Define the service function
start_module() {
    module_name=$1
    module_port=$2
    module_properties="$SCRIPT_DIR/application.properties"
    echo "Starting $module_name at port $module_port..."
    cd "$OMS_DIR/$module_name"
    nohup mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=$module_port,--app.profile=dev > $SCRIPT_DIR/logs/${module_name}.logs &
}

for module in "${modules_list[@]}"; do
    module_name="${module%%=*}"
    module_port="${module#*=}"
    start_module "$module_name" $module_port
    sleep 30
done

echo "All modules started successfully."
