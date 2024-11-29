# Run spotless to format code if available
./gradlew spotlessApply --no-daemon

# Run ktlint to check Kotlin style
./gradlew ktlintCheck --no-daemon

# Run Android lint
./gradlew lint --no-daemon

# Run unit tests
./gradlew test --no-daemon

# Run instrumented tests if an emulator is available
# ./gradlew connectedAndroidTest --no-daemon