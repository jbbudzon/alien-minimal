#!/usr/bin/env zsh

am_bgjobs_st(){
  if [[ "$(jobs | wc -l)" -gt 0 ]]; then
    echo -n "%F{$AM_VIINS_COLOR}%(1j._%j.)%f "
  else
    echo -ne ""
  fi
}
