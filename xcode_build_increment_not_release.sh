# NOT RELEASE BUILD VERSION INCREMENT
# sudo chmod 777 xcode_build_increment_not_release.sh

# Instructions:
# 1. Add a new Run Script in Xcode Build Phases: "$SRCROOT/YOUR_SCRIPTS_FOLDER/xcode_build_increment_not_release.sh" or "${SRCROOT}/Scripts/xcode_build_increment_not_release.sh"
# 2. Run this script after the 'Copy Bundle Resources' build phase.
# 3. Check "Run script only when installing" to run the script only when archiving.
# Even before the project is compiled, Xcode copies the current .plist file to a build folder and uses that file to bundle the final archive when you are submitting to the App Store.

set -x

PLISTBUDDY="/usr/libexec/PlistBuddy"
TARGET_BUILD_NUMBER=$($PLISTBUDDY -c "Print CFBundleVersion" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}")
TIMESTAMP=$(date +%s)

# Change target and DSYM Info.plist
if [ "${CONFIGURATION}" != "Release" ]; then
echo "--------------------------------------------------------------------------"
echo
echo "${CONFIGURATION}"
echo "Updating target build number from $TARGET_BUILD_NUMBER to $TIMESTAMP in ${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

$PLISTBUDDY -c "Set :CFBundleVersion $TIMESTAMP" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

if [ -f "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}.dSYM/Contents/Info.plist" ]; then
echo "Updating DSYM build number from $TARGET_BUILD_NUMBER to $TIMESTAMP in ${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}.dSYM/Contents/Info.plist"
$PLISTBUDDY -c "Set :CFBundleVersion $TIMESTAMP" "${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}.dSYM/Contents/Info.plist"
fi

echo "--------------------------------------------------------------------------"
fi
