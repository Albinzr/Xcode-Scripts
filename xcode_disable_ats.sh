# Disables ATS in DEBUG builds.
# sudo chmod 777 xcode_disable_ats.sh

# Instructions:
# 1. Add a new Run Script in Xcode Build Phases: "$SRCROOT/YOUR_SCRIPTS_FOLDER/xcode_disable_ats.sh" or "${SRCROOT}/Scripts/xcode_disable_ats.sh"

set -x


PLISTBUDDY="/usr/libexec/PlistBuddy"
ATS_STATUS=$($PLISTBUDDY -c "Print :NSAppTransportSecurity:NSAllowsArbitraryLoads" "$INFOPLIST_FILE")

if [ -z $ATS_STATUS ]; then
  echo "NSAllowsArbitraryLoads key doesn't exists; the key will be added.";
  $PLISTBUDDY -c "Add :NSAppTransportSecurity:NSAllowsArbitraryLoads bool false" "$INFOPLIST_FILE"
else
  echo "NSAllowsArbitraryLoads key exists."
fi

case "${CONFIGURATION}" in

"Release"|"Adhoc")
echo "Enabling ATS"
$PLISTBUDDY -c "Set :NSAppTransportSecurity:NSAllowsArbitraryLoads NO" "$INFOPLIST_FILE"
;;

"Debug")
echo "Disabling ATS"
$PLISTBUDDY -c "Set :NSAppTransportSecurity:NSAllowsArbitraryLoads YES" "$INFOPLIST_FILE"
;;

*)
echo "Enabling ATS"
$PLISTBUDDY -c "Set :NSAppTransportSecurity:NSAllowsArbitraryLoads NO" "$INFOPLIST_FILE"
;;

esac
