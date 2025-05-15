echo "deb http://deb.debian.org/debian bookworm main" | sudo tee /etc/apt/sources.list.d/debian.list

echo -e "Package: *\nPin: release a=bookworm\nPin-Priority: 100" | sudo tee /etc/apt/preferences.d/debian

sudo apt update
sudo apt install -t bookworm clonezilla

sudo rm /etc/apt/sources.list.d/debian.list
sudo rm /etc/apt/preferences.d/debian
sudo apt update
