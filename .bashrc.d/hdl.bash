#! /usr/bin/env bash

### ***Erase duplicate lines and certain commands from history***

# Create variables and secure temporary files
declare bash_history_buffer=$(mktemp);
declare bash_history_tmpfile=$(mktemp);
declare hist_file=~/.bash_history;

# Create backup copy of ~/.bash_history
cp --preserve=all $hist_file $hist_file-BACKUP

### Workaround due to issues of the "cat" command ###
# Read $HISTFILE lines and write to the buffer file
while read -r line; do echo "$line"; done < $hist_file > $bash_history_buffer;

# The first occurrence of a line is kept and future duplicate lines are scrapped from the output
# Also redirect output to a temporary file
awk '!seen[$0]++' $bash_history_buffer > $bash_history_tmpfile;

# Delete certain commands
#echo -e "\n";
#cat $bash_history_tmpfile;
#echo -e "\n sed RegEx \n";
#sed --in-place=-BACKUP --silent --regexp-extended '/^lst*/d' $bash_history_tmpfile;
#sed --in-place --regexp-extended --file=./rm-commands.sed $bash_history_tmpfile;

#declare -a rm_commands=("lst" "history");
#declare rm_commands_file=~/.bashrc.d/config.d/rm_commands;
readarray -t rm_commands < ~/.bashrc.d/config.d/rm_commands;
#echo -e " \n \${rm_commands[*]}: ${rm_commands[*]} \n";

function read_commands() {
  for cmd in ${rm_commands[@]}; do
    echo "/^$cmd*.*/d";
  done
}
declare rm_cmd="$(read_commands)";
#echo -e "\n ${C_RED1}\$rm_cmd: ${NO_FORMAT} \n$rm_cmd\n";

function sudo_cmd() {
  for cmd in ${rm_commands[@]}; do
    echo "/^sudo\ $cmd*.*/d";
  done
}
declare rm_sudo_cmd="$(sudo_cmd)";
#echo -e "\n ${C_RED1}\$rm_sudo_cmd: ${NO_FORMAT} \n$rm_sudo_cmd\n";

sed --in-place --regexp-extended --expression="$rm_cmd" \
                                 --expression="$rm_sudo_cmd" \
                                 $bash_history_tmpfile;

#echo -e "\n \$bash_history_tmpfile AFTER sed: \n";
#cat $bash_history_tmpfile;
#echo -e "\n";


# Copy temporary file back to history
cp --force $bash_history_tmpfile $hist_file;

#touch bash_history_testfile.txt;
#cp -f $bash_history_tmpfile bash_history_testfile.txt

# Remove temporary files
rm --force $(echo $bash_history_buffer)
rm --force $(echo $bash_history_tmpfile)
# Unset(remove) variables
unset -v bash_history_buffer
unset -v bash_history_tmpfile

### ***END Erase duplicate lines and certain commands from history***
