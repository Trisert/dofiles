# fkill - kill process
fkill() {
     local pid
     pid=$(ps -ef | sed 1d | sk --reverse | awk '{print $2}')

     if [ "x$pid" != "x" ]
     then
         echo $pid | xargs kill -${1:-9}
     fi
}

# Open file
fo() (
 IFS=$'\n'  out=("$(sk --regex --reverse -c 'fd -HI -j8 . '/'' --color=hl:69)") #out=("$(fzf --query="$1"
 key=$(head -1 <<< "$out")
 file=$(head -2 <<< "$out" | tail -1)
 if [ -n "$file" ]; then
     [ "$key" = ctrl-o ] && open "$file" || nvim "$file"
 fi
)

timezsh() {
    shell=${1-$SHELL}
    for i in $(seq 1 10); do time $shell -i -c exit; done
}

take() {
    mkdir "$1" && cd "$1"
}
