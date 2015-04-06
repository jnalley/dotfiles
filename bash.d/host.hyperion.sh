inpath boot2docker && $(boot2docker shellinit 2> /dev/null)

update_neovim() {
    brew update
    brew reinstall --HEAD neovim
}
