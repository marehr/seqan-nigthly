## 

function git_last_change_date {
	pushd $1
  DATE=$(date -j -f "%Y-%m-%d %H:%M:%S" "`git log -1 --format="%cd" --date=iso`" "+%Y%m%d%H%M" 2> /dev/null)
  cd $olddir
  echo $DATE
	popd
}


function git_update {
	pushd $1

  git fetch
  git merge --ff-only origin/$2

	popd
}

function replace_qualifier {
  find $1 -name MANIFEST.MF -exec sed -i -e "s/qualifier/$2/g" {} \;
}
