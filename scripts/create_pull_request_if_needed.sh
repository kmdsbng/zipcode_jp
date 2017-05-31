export BRANCH=update-data-`date -u "+%Y%m%d"`
git status -s 2> /dev/null | grep x-ken-all.csv
if [ "$?" -eq 0 ] ; then
  echo x-ken-all.csv changed
  git config --global user.email kameda.sbng@gmail.com
  git config --global user.name 'CircleCI'
  git add docs
  git commit -m 'Update data'
  git branch -M $BRANCH
  git push origin $BRANCH
  bundle exec ruby scripts/create_pull_request.rb
else
  echo x-ken-all.csv not changed
fi

