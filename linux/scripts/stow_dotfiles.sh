start=$(pwd)

cd $(dirname $0)/../home_directory
sudo stow . --target=$HOME

cd $start