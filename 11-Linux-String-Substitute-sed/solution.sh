#!/usr/bin/env bash
# There is some data on Nautilus App Server 2 in Stratos DC. Data needs to be altered in several of the files.
# On Nautilus App Server 2, alter the /home/BSD.txt file as per details given below:
# a. Delete all lines containing word following and save results in /home/BSD_DELETE.txt file. (Please be aware of case sensitivity)
# b. Replace all occurrence of word the to for and save results in /home/BSD_REPLACE.txt file.
# Note: Let's say you are asked to replace word to with from. In that case, make sure not to alter any words containing this string;
# for example upto, contributor etc.
# References:
# [1] https://www.tecmint.com/linux-sed-command-tips-tricks/
# [2] https://linuxhint.com/sed-command-to-delete-a-line/
# [3] https://askubuntu.com/questions/76808/how-do-i-use-variables-in-a-sed-command

# Login as root
sudo su -

# Declare variables
FILE_PATH=/home/BSD.txt
DELETED_FILE_PATH=/home/BSD_DELETE.txt
REPLACED_FILE_PATH=/home/BSD_REPLACE.txt
DELETED_WORD=following
REPLACED_WORD=the
REPLACEMENT_WORD=for

# Perform delete operation
sed "/$DELETED_WORD/d" "$FILE_PATH" >> $DELETED_FILE_PATH

# Perform replacement operation
sed "s/ $REPLACED_WORD/ $REPLACEMENT_WORD/g" "$FILE_PATH" >> $REPLACED_FILE_PATH

# Check result
cat $DELETED_FILE_PATH | grep $DELETED_WORD
cat $REPLACED_FILE_PATH | grep $REPLACED_WORD
