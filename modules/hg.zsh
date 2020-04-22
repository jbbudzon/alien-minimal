#!/usr/bin/env zsh

am_is_hg(){
  echo -ne "$(plib_is_hg)"
}

am_hg_branch(){
  VAL="$(plib_hg_branch)"
  [[ ! -z "${VAL}" ]] && echo -ne "%B%F{$AM_BRANCH_COLOR}${VAL}%f%b "
}

am_hg_rev(){
  VAL="$(plib_hg_rev)"
  [[ ! -z "${VAL}" ]] && echo -ne "%F{$AM_REV_COLOR}${VAL}%f "
}
