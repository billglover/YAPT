#Update build number with number of git commits if in release mode
if [ ${CONFIGURATION} == "Release" ]; then
GIT_RELEASE_VERSION=$(git describe --tags --always --dirty)
COMMITS=$(git rev-list HEAD | wc -l)
COMMITS=$(($COMMITS))
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${GIT_RELEASE_VERSION#*v}" "${PROJECT_DIR}/${INFOPLIST_FILE}"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${COMMITS}" "${PROJECT_DIR}/${INFOPLIST_FILE}"
fi;