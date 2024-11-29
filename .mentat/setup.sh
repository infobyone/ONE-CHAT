# Install JDK
apt-get update
apt-get install -y openjdk-17-jdk wget unzip

# Set JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Install Android SDK
mkdir -p /opt/android-sdk/cmdline-tools
cd /opt/android-sdk/cmdline-tools
wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
unzip commandlinetools-linux-10406996_latest.zip
mv cmdline-tools latest
cd -

# Set Android SDK environment variables
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# Accept licenses
yes | sdkmanager --licenses

# Install required SDK packages
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Create local.properties
echo "sdk.dir=/opt/android-sdk" > local.properties

# Create minimal google-services.json
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

# Make gradlew executable and build
chmod +x ./gradlew
./gradlew build --no-daemon