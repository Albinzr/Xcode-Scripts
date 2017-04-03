# XCODE WARNINGS AND ERRORS GENERATOR
# sudo chmod 777 xcode_highlight.sh

# Instructions:
# 1. Add a new Run Script in Xcode Build Phases: "$SRCROOT/YOUR_SCRIPTS_FOLDER/xcode_highlight.sh" or "${SRCROOT}/Scripts/xcode_warnings.sh"

set -x

# List of tags to be reported as warnings
WARNING_TAGS="TODO:|FIXME:|WARNING:"
ERROR_TAGS="ERROR:"

echo "Searching ${SRCROOT} for ${WARNING_TAGS} and ${ERROR_TAGS}"
find "${SRCROOT}" \( -name "*.h" -or -name "*.m" -or -name "*.swift" \) -print0 | xargs -0 egrep --with-filename --line-number --only-matching "($WARNING_TAGS).*\$|($ERROR_TAGS).*\$" | perl -p -e "s/($WARNING_TAGS)/ warning: \$1/" | perl -p -e "s/($ERROR_TAGS)/ error: \$1/"
