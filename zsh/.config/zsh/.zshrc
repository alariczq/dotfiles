local m
for m in core plugins completion tools aliases; do
  source $ZDOTDIR/conf.d/$m.zsh
done

# Machine-local overrides (not tracked in dotfiles)
[[ -f ~/.zshrc ]] && source ~/.zshrc
