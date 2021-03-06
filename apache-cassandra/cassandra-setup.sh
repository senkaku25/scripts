#!/bin/sh
#
# This shell script installs an Apache Cassandra installation for Ubuntu, enables
# password authentication, adds new user roles, and changes the default
# administrator account password.

# Runs a command 5 times with a 5 second delay, or until the command returns
# success.
#
# All output from the command is redirected to /dev/null.
#
# Parameters:
#   1: Command to execute.
#   2: Message to print before running the command each time.
#   3: Message to print if the loops finish but the command never returned
#      success.
# Returns whether the command eventually returned success.
loop_check_for_success() {
  COMMAND=$1
  LOOP_MESSAGE=$2
  FAILURE_MESSAGE=$3

  STATUS=1
  for i in 1 2 3 4 5 6 7 8 9 10
  do
    echo "$LOOP_MESSAGE"
    $COMMAND > /dev/null 2>&1
    STATUS=$?
    if [ $STATUS -eq 0 ] ; then
      break
    fi
    sleep 5
  done

  if [ "$STATUS" != 0 ] ; then
      echo "$FAILURE_MESSAGE" >&2
      exit $STATUS
  fi
}

# Monitors the startup status of Cassandra and returns whether it started up
# successfully.
#
# Parameters: None.
# Returns whether startup was succesful.
wait_for_cassandra_start() {

  COMMAND="nodetool status"
  LOOP_MESSAGE="Checking if Cassandra is running..."
  FAILURE_MESSAGE="Unsuccessful startup of Cassandra."
  loop_check_for_success "$COMMAND" "$LOOP_MESSAGE" "$FAILURE_MESSAGE"

  STATUS=$?
  if [ "$STATUS" != 0 ] ; then
    exit $STATUS
  fi

  echo "Cassandra started up successfully."

  COMMAND="netstat -l | grep 9042 > /dev/null 2>&1"
  LOOP_MESSAGE="Checking if Cassandra is ready to receive connections..."
  FAILURE_MESSAGE="Could not connect to Cassandra."
  loop_check_for_success "$COMMAND" "$LOOP_MESSAGE" "$FAILURE_MESSAGE"

  STATUS=$?
  if [ "$STATUS" != 0 ] ; then
    exit $STATUS
  fi

  echo "Cassandra is ready for connections."
}

# Executes a single command through cqlsh using the default administrator
# account.
#
# Parameters:
#   1: Command to run in cqlsh.
cqlsh_run() {
  COMMAND=$1
  cqlsh -u cassandra -p cassandra -e "$COMMAND"
}

if [ "$(id -u)" != "0" ] ; then
    echo "This script must be run with root permissions." >&2
    exit 1
fi

echo "Installing cURL package..."
apt-get update
apt-get install -y curl

echo "Installing Java 8 package..."
sudo add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install -y openjdk-8-jre

echo "Installing Cassandra package..."
echo "deb http://www.apache.org/dist/cassandra/debian 310x main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl https://www.apache.org/dist/cassandra/KEYS | apt-key add -
apt-get update
apt-get install -y cassandra

echo "Enabling authentication and restarting Cassandra..."
sed -i 's/authenticator: AllowAllAuthenticator/authenticator: PasswordAuthenticator/g' /etc/cassandra/cassandra.yaml
sed -i 's/authorizer: AllowAllAuthorizer/authorizer: CassandraAuthorizer/g' /etc/cassandra/cassandra.yaml
service cassandra restart

wait_for_cassandra_start
STATUS=$?
if [ $STATUS != 0 ] ; then
  echo "Setup was unsuccessful." >&2
  exit "$STATUS"
fi

echo "Adding users..."
cqlsh_run "CREATE USER username WITH PASSWORD 'password' SUPERUSER;"
cqlsh_run "CREATE USER backend WITH PASSWORD 'password' NOSUPERUSER;"

echo "Changing the default administrator account password..."
cqlsh_run "ALTER USER cassandra WITH PASSWORD 'password';"

echo "Setup complete."
