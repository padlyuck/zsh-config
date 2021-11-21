_yii2_get_command_list () {
  php ./yii help --color=0 |\
  sed '/^$/d' |\
  sed '/^- /d'|\
  sed -n '/The following commands are available:/,/To see the help of each command/p'|\
  grep -v "The following commands are available:" |\
  grep -v "To see the help of each command" |\
  sed 's/^    //' |\
  sed -e 's/ .*$//'
}

_yii2_custom () {
  if [ -f yii ]; then
    compadd `_yii2_get_command_list`
  fi
}

compdef _yii2_custom yii
