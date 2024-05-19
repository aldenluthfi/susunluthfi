start=$(pwd)

cd $(dirname $0)/../home
stow . --target=$HOME

cd $start