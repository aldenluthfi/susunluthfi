start = $(pwd)

cd $(dirname $0)/../dotfiles
stow */ -D --target=$HOME

cd $start