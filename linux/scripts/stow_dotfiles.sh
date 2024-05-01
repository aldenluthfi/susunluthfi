start=$(pwd)

cd $(dirname $0)/../home_directory
stow . --target=$HOME

cd $start