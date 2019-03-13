## Instructions to install MEGAN6 6.12.6 on Zeus

Note: the installation is interactive through GUI, 
so for the time being I reckon it is best to avoid MAALI and a system-wide installation.
Instead, I have proceeded with a group installation.

Here are the key steps, assuming we are installing for project *pawsey0281*

- Create the relevant directories

		mkdir -p /group/pawsey0281/software/sles12sp3/src
		mkdir -p /group/pawsey0281/software/sles12sp3/apps/binary/megan
		mkdir -p /group/pawsey0281/software/sles12sp3/modulefiles/megan

- Download and run the MEGAN installer

		cd /group/pawsey0281/software/sles12sp3/src
		wget http://ab.inf.uni-tuebingen.de/data/software/megan6/download/MEGAN_Community_unix_6_12_6.sh
		bash ./MEGAN_Community_unix_6_12_6.sh

- Move MEGAN to the binary directory

		mv megan /group/pawsey0281/software/sles12sp3/apps/binary/megan/6.12.6

- Update path in Megan.desktop (unnecessary)

		cd /group/pawsey0281/software/sles12sp3/apps/binary/megan/6.12.6
		sed -i 's/^Exec=.*/Exec=\/group\/pawsey0281\/software\/sles12sp3\/apps\/binary\/megan\/6.12.6\/MEGAN/g' Megan.desktop
		sed -i 's/^Icon=.*/Icon=\/group\/pawsey0281\/software\/sles12sp3\/apps\/binary\/megan\/6.12.6\/.install4j\/MEGAN.png/g' Megan.desktop

- Copy the module files from this repo to the modulefiles directory

		cd /group/pawsey0281/software/sles12sp3/modulefiles/megan
		cp -p <GIT-REPO-DIR>/6.12.6.lua ./
		cp -p <GIT-REPO-DIR>/version ./.version
