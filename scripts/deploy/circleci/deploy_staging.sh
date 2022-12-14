#!/usr/bin/env bash
# This script deploys the built site to a subfolder of the gh-pages branch.
git config --global user.email "$GH_EMAIL"
git config --global user.name "$GH_NAME"

# CircleCI will identify the SSH key with a "Host" of gh-stg. In order to tell
# Git to use this key, we need to hack the SSH key:
sed -i -e 's/Host gh-stg/Host gh-stg\n  HostName github.com/g' ~/.ssh/config
git clone git@gh-stg:$GH_ORG_STG/$CIRCLE_PROJECT_REPONAME.git out

cd out
git checkout gh-pages || git checkout --orphan gh-pages
# Clear the "staging" subfolder and copy the built site into it.
git rm -rfq staging
cp -a /tmp/build/_site staging

git add -A
git commit -m "Automated deployment to GitHub Pages: ${CIRCLE_SHA1}" --allow-empty

git push origin gh-pages