sudo rm -rf /var/lib/apt/lists/

sudo apt clean; sudo apt autoclean

# get fresh configuration files, resolve package conflicts

sudo apt update

sudo dpkg --configure -a

sudo apt --fix-broken install

sudo apt upgrade -y
