#!/bin/bash

set -e

echo

write_license()
{
	if [ ! -z "$1" ] && [ "$1" == "by" ]; then
		cat <<EOT > LICENSE
This project is provided under the terms of
Creative Commons Attribution 4.0 license
https://creativecommons.org/licenses/by/4.0/

Excluded from the Creative Commons license is: all logos (including the Morevna Project logo, Adamant Art school logo, Reanimedia logo, Creative Commons logo, sponsor logos) and associated trademarks.
EOT
	else
		cat <<EOT > LICENSE
This project is provided under the terms of
Creative Commons Attribution-ShareAlike 4.0 license
https://creativecommons.org/licenses/by-sa/4.0/

Excluded from the Creative Commons license is: all logos (including the Morevna Project logo, Adamant Art school logo, Reanimedia logo, Creative Commons logo, sponsor logos) and associated trademarks.
EOT
	fi
}

if [ -z "$1" ]; then
    echo "ERROR: Please specify project directory."
    echo
    exit 1
fi

DIR="$1"
PROJECT=`basename "$DIR"`
STORAGE="/home/data/archive.morevna/animation-sources"
GITDIR="$STORAGE/$PROJECT"

cd "$DIR"
DIR=`pwd`

if [ "$DIR" == "$GITDIR" ]; then
	echo "ERROR: Can't use directory, which belongs to project storage."
	exit 1
fi


if [ ! -d "$GITDIR" ]; then
	cd "$STORAGE"
	git clone git@gitlab.com:OpenSourceAnimation/$PROJECT.git
	cd "$GITDIR"
	if ! ( git rev-parse HEAD >/dev/null 2>&1 ); then
		git checkout -b main
	else
		git branch --set-upstream-to=origin/main main
	fi
	git lfs install
else
	cd "$GITDIR"
	git lfs install
	git reset --hard
	# Check if remote branch exists
	BRANCH=`git symbolic-ref --short HEAD`
	RESULT=`git ls-remote --heads git@gitlab.com:OpenSourceAnimation/$PROJECT.git $BRANCH | wc -l`
	if [ $RESULT == 1 ]; then
		git pull origin $BRANCH
	fi
fi

git config user.name "Morevna Project"
git config user.email "contact@morevnaproject.org"

cd "$DIR"

# Проверить файл лицензии
if [ ! -f "$DIR/LICENSE" ] && [ ! -f "$GITDIR/LICENSE" ]; then
	echo
	echo "No license file found. Do you wish to add one? "
	select answer in "CC-BY-SA" "CC-BY" "Exit"; do
		case $answer in
			CC-BY-SA ) write_license; break;;
			CC-BY ) write_license by; break;;
			Exit ) exit;;
			* ) echo "Please choose answer.";;
		esac
	done
fi
# CREDITS.txt
if [ ! -f "$DIR/CREDITS.txt" ] && [ ! -f "$GITDIR/CREDITS.txt" ]; then
	touch "$DIR/CREDITS.txt"
fi
# CONTRIBUTING.md 
if [ ! -f "$DIR/CONTRIBUTING.md" ] && [ ! -f "$GITDIR/CONTRIBUTING.md" ]; then
	cat <<EOT > "$DIR/CONTRIBUTING.md"
Contributions to this repository are accepted via GitLab's PRs - https://gitlab.com/OpenSourceAnimation/$PROJECT/

If you wish your name to appear in the credits, please make sure to edit "CREDITS.txt" file as part of your PR (see "Community contributions" section at the end).

If you will not edit "CREDITS.txt" file as part of your PR, then we will assume that you providing your contribution under CC-0 license and your name will not be attributed in final credits.
EOT
fi
# Файл README
if [ ! -f "$DIR/README.md" ] && [ ! -f "$GITDIR/README.md" ]; then
	echo
	echo "ERROR: No README.md file found!"
	echo "You can use this one and adapt accordingly - https://gitlab.com/OpenSourceAnimation/pepper-and-carrot-ep13/-/blob/main/README.md"
	exit 1
fi

# Файл pack.lst
if [ ! -f "$DIR/pack.lst" ] && [ ! -f "$GITDIR/pack.lst" ]; then
	touch "$DIR/pack.lst"
fi
for F in CREDITS.txt CONTRIBUTING.md LICENSE README.md packages.txt; do
	if [ -f "$DIR/$F" ]; then
		if ! ( cat "$DIR/pack.lst" | grep $F >/dev/null 2>&1 ); then
			echo "$F" >> "$DIR/pack.lst"
		fi
	fi
done
# .gitignore
if [ ! -f "$DIR/.gitignore" ] && [ ! -f "$GITDIR/.gitignore" ]; then
cat <<EOT > "$DIR/.gitignore"
render
*.blend1
*.blend2
*.pyc
*.bak
*.png~
*.kra~
Thumbs.db
.directory
blender.crash.txt
.stfolder
EOT
fi
# .gitattributes
if [ ! -f "$DIR/.gitattributes" ] && [ ! -f "$GITDIR/.gitattributes" ]; then
cat <<EOT > "$DIR/.gitattributes"
*.kra filter=lfs diff=lfs merge=lfs -text
*.png filter=lfs diff=lfs merge=lfs -text
*.sifz filter=lfs diff=lfs merge=lfs -text
*.blend filter=lfs diff=lfs merge=lfs -text
*.wav filter=lfs diff=lfs merge=lfs -text
*.mp3 filter=lfs diff=lfs merge=lfs -text
*.ogg filter=lfs diff=lfs merge=lfs -text
*.mov filter=lfs diff=lfs merge=lfs -text
*.odt filter=lfs diff=lfs merge=lfs -text
*.pdf filter=lfs diff=lfs merge=lfs -text
*.aiff filter=lfs diff=lfs merge=lfs -text
*.flac filter=lfs diff=lfs merge=lfs -text
*.ora filter=lfs diff=lfs merge=lfs -text
*.bphys filter=lfs diff=lfs merge=lfs -text
*.bobj.gz filter=lfs diff=lfs merge=lfs -text
*.vdb filter=lfs diff=lfs merge=lfs -text
EOT
fi

cat <<EOT > $HOME/.unison/sync-${PROJECT}.git
# Unison preferences
label = archive.morevnaproject.org
root = $DIR
root = $GITDIR

perms=0

ignore = Name {.git}
ignore = Name {nosync}
ignore = Name {snapshots}
ignore = Name {packs}
ignore = Name {render}
ignore = Name {,.}*{.blend1}
ignore = Name {,.}*{.doc#}
ignore = Name {,.}*{.blend2}
ignore = Name {Makefile}
ignore = Name {,.}*{.pyc}
ignore = Name {.stversions}
ignore = Name {__pycache__}
ignore = Path {.seafile-data}
ignore = Name {,.}*{.directory}
ignore = Name {.directory}
ignore = Name {,.}*{~}
ignore = Name {.DS_Store}
ignore = Name {.syncthing}{,.}*{.tmp}
ignore = Name {._sync_}{,.}*{.db}{,.}*
EOT

unison-gtk sync-${PROJECT}.git


cd $GITDIR

for F in .gitignore .gitattributes CREDITS.txt CONTRIBUTING.md LICENSE README.md pack.lst; do
	if ( git status -s | grep " ${F}$" ); then
		git add ${F}
		git commit -m "Update ${F}"
	fi
done

exit 0
A=`git status -s -u | head -30`
while [ ! -z $A]
for LINE in `git status -s -u | head -30`; do
# Цикл - коммит 10 файлов - push
git add .
git commit -m "Update files"
BRANCH=`git symbolic-ref --short HEAD`
#git push origin $BRANCH
echo BRANCH=$BRANCH

exit 0

#===============================================================
# Добавить remote
if ! ( cat .git/config | grep "remote \"origin\"" >/dev/null 2>&1 ); then
	git remote add origin git@gitlab.com:OpenSourceAnimation/$PROJECT.git
fi

# fetch & check new commits
COMMIT=""
if ( git rev-parse HEAD >/dev/null 2>&1 ); then
	COMMIT=`git rev-parse HEAD`
fi
git fetch
if [ ! -z $COMMIT ]; then
	COMMIT_NEW=`git rev-parse HEAD`
	if [ $COMMIT_NEW != $COMMIT ]; then
		echo "ATTENTION! There are new commits in remote repo!"
		echo "Please examine the situation manually and make sure to sync your local files with remote tree."
		echo
		exit 1
	fi
fi
