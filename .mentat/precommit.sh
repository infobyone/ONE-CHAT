# Exit on any error
set -e

# Run all Gradle tasks in a single invocation to reduce overhead
./gradlew lint testDebug testReleaseUnitTest

# Exit with the status of the Gradle command
exit $?