start=$(pwd)

cd $(dirname $0)/../home_directory
sudo stow -D . --target=$HOME

cd $start