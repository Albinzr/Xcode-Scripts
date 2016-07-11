# Get current git commit hash and save in the project .plist

PLISTBUDDY="/usr/libexec/PlistBuddy"
GIT_HASH=$(git rev-parse --short HEAD)

GIT_KEY=$($PLISTBUDDY -c "Print GitHash" "$INFOPLIST_FILE")

if [ $GIT_KEY -z ]; then
#if length is zero, add a new entry
echo "Git Hash Key not exists"
$PLISTBUDDY -c "Add :GitHash string $GIT_HASH" "$INFOPLIST_FILE"
else
echo "Git Hash Key already exists"
$PLISTBUDDY -c “Set :GitHash string $GIT_HASH" "$INFOPLIST_FILE"
fi
