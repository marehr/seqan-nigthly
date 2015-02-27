## 

function git_last_change_date {
	pushd $1 > /dev/null
  # DATE=$(date -j -f "%Y-%m-%d %H:%M:%S" "`git log -1 --format="%cd" --date=iso`" "+%Y%m%d%H%M" 2> /dev/null)
  DATE=$(git log -1 --format="%cd" --date=iso | sed -n 's/\([0-9]*\)-\([0-9]*\)-\([0-9]*\)\s\([0-9]*\):\([0-9]*\):.*$/\1\2\3\4\5/p')
	echo $DATE
	popd > /dev/null
}


function git_update {
	pushd $1 > /dev/null

  git fetch
  git merge --ff-only origin/$2
  git submodule update --init --recursive

	popd > /dev/null
}

function replace_qualifier {
  find $1 -name MANIFEST.MF -exec sed -i -e "s/qualifier/$2/g" {} \;
}
