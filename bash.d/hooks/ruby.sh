# vim: set ft=sh:ts=4:sw=4:noet:nowrap # bash

# this script should only ever be sourced
[[ ${BASH_SOURCE[0]} != ${0} ]] || exit 1

# chruby (homebrew)
if [[ -s /usr/local/opt/chruby/share/chruby/chruby.sh ]]; then
  source /usr/local/opt/chruby/share/chruby/chruby.sh

  if [[ -d ${HOME}/local/rubies/ruby-2.2.3  ]]; then
    RUBIES+=( ${HOME}/local/rubies/ruby-2.2.3 )
    chruby 2.2.3
  fi

  # auto switch ruby
  # source /usr/local/opt/chruby/share/chruby/auto.sh 2> /dev/null
fi
