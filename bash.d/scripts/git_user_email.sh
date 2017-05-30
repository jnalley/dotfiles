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
#-----------------------------------------------------------#

email="$(git config user.email)"

# do nothing if email is set
[[ -n ${email} && ${email} != '(none)' ]] && exit 0

# get remote url
url="$(git config --get remote.origin.url)"

# bail if no url is set
[[ -n ${url} ]] || exit 1

# configured domains/emails
IFS=':' read -ra config <<< "$(
  git config --get-regexp 'user.email-.*' | tr '\n' ':'
)"

# iterate entries matching on domain
for ((i = 0; i < ${#config[@]}; i++)); do
  set -- ${config[${i}],,}
  domain=${1#*-}        # everything after the first dash
  domain=${domain//-/.} # dashes to dots
  address=${2}
  # case insensitive
  [[ ${url,,} =~ .*${domain}.* ]] && \
    match=${address} && break
done

# set email if a match was found
if [[ -n ${match} ]]; then
  git config user.email ${match}
  echo "Setting git email to: $(git config user.email)"
else
  echo "Unable to match git email for: ${url,,} =~ ${domain}"
fi
