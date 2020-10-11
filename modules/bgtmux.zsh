#!/bin/bash

am_tmux_st(){
  # warning ts names cannot contain whitespace
  VAL=${#$(ts)[@]}
  if [[ -n "${TMUX}" || "${VAL}" -eq 0 ]]; then
    echo -ne ""
  else
    echo -n "%F{$AM_TMUX_COLOR}"
    for (( iter = 0 ; iter < ${VAL} ; ++iter )); do
      echo -n "${AM_TMUX_SYM}"
    done
    echo -n "%f "
  fi
}
