start=$(pwd)

cd $(dirname $0)/../home_directory
stow -D . --target=$HOME

cd $start