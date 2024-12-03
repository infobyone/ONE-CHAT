#!/bin/bash

# Exit on any error
set -e

# Function to check command success
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed"
        exit 1
    fi
}

# Function to safely change directory
safe_cd() {
    cd "$1"
    check_command "Failed to change to directory: $1"
}

# Set up environment variables
ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-/opt/android-sdk}"
CMDLINE_TOOLS_DIR="$ANDROID_SDK_ROOT/cmdline-tools"
JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}"

# Install JDK
echo "Installing JDK..."
apt-get update
check_command "apt-get update"
apt-get install -y openjdk-17-jdk wget unzip
check_command "JDK installation"

# Set up PATH
export PATH="$JAVA_HOME/bin:$PATH"

# Install Android SDK
echo "Installing Android SDK..."
if [ -d "$ANDROID_SDK_ROOT" ]; then
    rm -rf "$ANDROID_SDK_ROOT"
fi
mkdir -p "$CMDLINE_TOOLS_DIR"
check_command "Failed to create Android SDK directory"

safe_cd "$CMDLINE_TOOLS_DIR"
wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
check_command "Failed to download Android command line tools"

unzip commandlinetools-linux-10406996_latest.zip
check_command "Failed to unzip command line tools"

mkdir -p latest
check_command "Failed to create latest directory"

mv cmdline-tools/* latest/
check_command "Failed to move command line tools"

rm -rf cmdline-tools
safe_cd -

# Set Android SDK environment variables
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

# Accept licenses
echo "Accepting Android SDK licenses..."
yes | sdkmanager --licenses
check_command "Failed to accept Android SDK licenses"

# Install required SDK packages
echo "Installing Android SDK packages..."
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
check_command "Failed to install Android SDK packages"

# Create local.properties
echo "Creating local.properties..."
echo "sdk.dir=$ANDROID_SDK_ROOT" > local.properties
check_command "Failed to create local.properties"

# Create app directory if it doesn't exist
if [ ! -d "app" ]; then
    mkdir -p app
    check_command "Failed to create app directory"
fi

# Create minimal google-services.json
echo "Creating google-services.json..."
cat > app/google-services.json << 'EOL'
{
  "project_info": {
    "project_number": "000000000000",
    "project_id": "dummy-project",
    "storage_bucket": "dummy-project.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:000000000000:android:0000000000000000",
        "android_client_info": {
          "package_name": "com.one.onechat"
        }
      },
      "api_key": [
        {
          "current_key": "dummy_api_key"
        }
      ]
    }
  ]
}
EOL
check_command "Failed to create google-services.json"

# Make gradlew executable
echo "Making gradlew executable..."
chmod +x ./gradlew
check_command "Failed to make gradlew executable"

# Run initial build
echo "Running initial build..."
./gradlew build --no-daemon
check_command "Initial build failed"

echo "Setup completed successfully!"