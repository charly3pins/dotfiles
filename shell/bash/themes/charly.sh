PROMPT_COMMAND='charly_theme'

ORANGE='38;5;216m'
YELLOW='38;5;229m'
GREEN='38;5;190m'
RED='38;5;196m'

git_dirty () {
  if [[ -n "$(git status -s 2> /dev/null)" ]]
  then echo -e "\x01\e[$RED✗\x02"
  else
    echo -e "\x01\e[$YELLOW✔\x02"
  fi
}

on () {
  echo -e "\x01\e[$YELLOW\x02 on \x01\e[$GREEN\x02"
}

git_branch () {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/$(on)\1 $(git_dirty)/"
}

charly_theme () {
  export PS1='\[\033[$ORANGE\]$(echo $(dirname $(echo \w | sed "s;$HOME;~;"))/ |sed -e "s;\(/\.\?.\)[^/]*;\1;g" -e "s;/h/c;~;" -e "s;\./;;")\W$(git_branch) \[\033[$YELLOW\] '
}

