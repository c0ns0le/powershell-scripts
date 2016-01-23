"line #1"
throw "ThisIsAError"
"line #3"
notacommand
"line #5"

########## trap #################
trap{
"unkown error: $_"
continue
#break
}

trap [System.Management.Automation.CommandNotFoundException]{
"Cannot find command: $_"
break
}