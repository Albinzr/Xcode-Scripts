# XCODE WARNINGS GENERATOR
# sudo chmod 777 xcode_warnings.sh

# Instructions:
# 1. Add a new Run Script in Xcode Build Phases: "$SRCROOT/YOUR_SCRIPTS_FOLDER/xcode_warnings.sh" or "${SRCROOT}/Scripts/xcode_warnings.sh"

set -x

# List of tags to be reported as warnings
TAGS="TODO:|FIXME:|WARNING:"

echo "Searching ${SRCROOT} for ${TAGS}"
find "${SRCROOT}" \( -name "*.swift" -or -name "*.h" -or -name "*.m" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($TAGS).*\$" | perl -p -e "s/($TAGS)/ warning: \$1/"
