# RELEASE BUILD VERSION INCREMENT
# sudo chmod 777 xcode_build_increment_release.sh

# Instructions:
# 1. Add a new Run Script in Xcode Build Phases: "$SRCROOT/YOUR_SCRIPTS_FOLDER/xcode_build_increment_release.sh" or "${SRCROOT}/Scripts/xcode_build_increment_release.sh"
# 2. Run this script before the 'Copy Bundle Resources' build phase.
# 3. Check "Run script only when installing" to run the script only when archiving.

set -x

PLISTBUDDY="/usr/libexec/PlistBuddy"
PROJECT_BUILD_NUMBER=$($PLISTBUDDY -c "Print :CFBundleVersion $buildNumber" "$INFOPLIST_FILE")

# Increment build number in project Info.plist
if [ "${CONFIGURATION}" = "Release" ]; then
PROJECT_BUILD_NUMBER_INCREMENTED=$(($PROJECT_BUILD_NUMBER + 1))
echo "--------------------------------------------------------------------------"
echo "${CONFIGURATION}"
echo "Updating project build number from $PROJECT_BUILD_NUMBER to $PROJECT_BUILD_NUMBER_INCREMENTED in $INFOPLIST_FILE"
$PLISTBUDDY -c "Set :CFBundleVersion $PROJECT_BUILD_NUMBER_INCREMENTED" "$INFOPLIST_FILE"
echo "--------------------------------------------------------------------------"
fi
