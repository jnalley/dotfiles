#!/usr/bin/env bash

#-----------------------------------------------------------#
# Try to set user.email by matching git url                 #
#-----------------------------------------------------------#
# first - set user.email to '(none)' in the global config.  #
# this causes git to abort on commits if email is not set:  #
# git config --global user.email '(none)'                   #
#                                                           #
# set emails using the following format:                    #
# git config --global user.email-mywork me@mywork.com       #
# git config --global user.email-github-com me@mydomain.com #
#                                                           #
# optionally set a default address:                         #
# git config --global user.default-email my@default.com     #
#-----------------------------------------------------------#

email="$(git config user.email)"
default="$(git config user.default-email)"

# do nothing if email is set
[[ -n ${email} && ${email} != '(none)' ]] && exit 0

# get remote url
url="$(git config --get remote.origin.url)"

if [[ -n ${url} ]]; then
  # configured domains/emails
  IFS=':' read -ra config <<< "$(
    git config --get-regexp 'user.email-.*' | tr '\n' ':'
  )"

  # iterate entries matching on domain
  for ((i = 0; i < ${#config[@]}; i++)); do
    set -- ${config[${i}],,}
    domain=${1#*-}       # everything after the first dash
    domain=${domain/-/.} # change dash to dot
    domain=${domain}
    address=${2}
    # case insensitive
    [[ ${url,,} =~ .*${domain}.* ]] && \
      match=${address} && break
  done
fi

# prompt if no match was found
[[ -z ${match} ]] && \
  read -e -i "${default}" -p 'GIT email: ' match

# set it
git config user.email ${match}
echo "Using email: $(git config user.email)"
