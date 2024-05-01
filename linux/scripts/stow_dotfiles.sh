start=$(pwd)

cd $(dirname $0)/../dotfiles
stow */ --target=$HOME

cd $start