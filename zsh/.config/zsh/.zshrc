() {
    local f
    for f in $ZDOTDIR/conf.d/*.zsh(N); do
        source $f
    done
}
