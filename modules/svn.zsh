#!/usr/bin/env zsh

am_is_svn(){
  plib_is_svn
}

am_svn_rev(){
  VAL="$(plib_svn_rev)"
  [[ ! -z "${VAL}" ]] && echo -n "%B%F{$AM_REV_COLOR}${VAL}%f%b "
}
