# Install Java JDK if not present
apt-get update
apt-get install -y openjdk-17-jdk

# Set JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Make gradlew executable
chmod +x ./gradlew

# Run gradle build to download dependencies and build project
./gradlew build --no-daemon