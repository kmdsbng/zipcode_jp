export BRANCH=update-data-`date -u "+%Y%m%d"`
git status -s 2> /dev/null | grep x-ken-all.csv
if [ "$?" -eq 0 ] ; then
  echo x-ken-all.csv changed
  #git config --global user.email user@eample.com
  #git config --global user.name 'your name'
  #git add .
  #git commit -m 'Bundle update'
  #git branch -M $BRANCH
  #git push origin $BRANCH
  #bundle exec ruby script/create_pull_request.rb
else
  echo x-ken-all.csv not changed
fi

