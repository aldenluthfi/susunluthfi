start=$(pwd)

cd $(dirname $0)/../home
stow -D . --target=$HOME

cd $start