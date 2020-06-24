VERSION=$(cat package.json \
| grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

echo "evaluated version to be: $VERSION"

if [ $(git tag -l "$VERSION") ]; then
      echo "No new version -> NOT publishing and tagging"
else
      echo "NEW version -> publishing and tagging"
      npm publish &&
      git config --global user.name "${SERVICE_USER_NAME}" &&
      git config --global user.email "${SERVICE_USER_EMAIL}" &&
      git remote add demo-tag-origin https://oauth2:${SERVICE_USER_GIT_TOKEN}@gitlab.com/${CI_PROJECT_PATH} &&
      git tag -a "$VERSION" -m "v$VERSION" &&
      git push demo-tag-origin HEAD:master --tags &&
      echo "Done"
fi
