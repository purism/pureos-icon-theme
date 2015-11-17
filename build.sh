#!/bin/sh
set -e
clear
basedir=$(echo $PWD)

# get source and cd into it.
rm -rf pureos-icon-theme*
apt-src install tango-icon-theme

rename s/tango/pureos/ -i tango*
cd pureos-icon-theme*

# rebranding
rm -f debian/watch
echo "9" > debian/compat
mv debian/Ubuntu debian/PureOS
mv debian/rules.Ubuntu debian/rules.PureOS
cp "$basedir"/data/start-here.svg debian/PureOS/scalable/places/start-here.svg
cp "$basedir"/data/start-here.svg scalable/places/start-here.svg
cp "$basedir"/data/update-manager.svg scalable/apps/system-software-update.svg

sed -e "s_^Maintainer.*_Maintainer: PureOS GNU/Linux developers <dev@puri.sm>_g" -i debian/control

sed -e "s/^Standards.*/Standards-Version: 3.9.6/" \
    -e 's/debhelper (>= 5)/debhelper (>>9)/' \
    -i debian/control

for file in $(grep "Tango" . -rl)
do
	sed -e "s/Tango/PureOS/g" -i "$file"
done
for file in $(grep "tango" . -rl)
do
	sed -e "s/tango/pureos/g" -i "$file"
done

# go back to the base directory and build.
dch -r stable "Branded for PureOS."
apt-src import pureos-icon-theme --here
echo "Building pureos-icon-theme..."
cd $basedir
apt-src build pureos-icon-theme
