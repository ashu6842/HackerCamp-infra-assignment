#!/bin/bash
cd ~/Desktop

# line 6 replaces spaces with _ in file names for easier parsing 
# 2>/dev/null used to supress unnecessary errors
for file in *; do mv "$file" `echo $file | tr ' ' '_'` ; done	2>/dev/null

# file with extensions are put into an array a
ls > grep *.* >log.txt
cat log.txt
readarray a < ~/Desktop/log.txt

# unique extension names are put into array b
echo ${a[*]#*.} > ext.txt
cat ext.txt|tr " " "\n"|sort|uniq > extx.txt
readarray b < ~/Desktop/extx.txt

# deleting junk files previously created
rm log.txt ext.txt extx.txt

# folders with extension names created in Documents
cd ../Documents
for i in ${b[@]}
do
	if [ ! -d "$i" ]; then
		mkdir $i	2>/dev/null
	fi
done

# files are moved from Desktop to Documents/[extension_name]
c1=${#a[@]}
c2=${#b[@]}
for ((var1=0;var1<c1;var1++));
do
	for ((var2=0;var2<c2;var2++));
	do
		if [ "${a[var1]#*.}" == "${b[var2]}" ] ; then
			mv ~/Desktop/${a[var1]} ~/Documents/${b[var2]}	2>/dev/null
		fi;
	done;
done

# shortcut files (.desktop) are restored
mv ~/Documents/desktop/* ~/Desktop
rmdir ~/Documents/desktop

# lists the top 10 files in terms of size
du -h ~/* | sort -hr |head -n 10 > largest_files.txt;
