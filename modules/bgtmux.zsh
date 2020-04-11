#!/bin/bash

am_tmux_st(){
  if [[ -n "${TMUX}" || "$(ts | wc -l)" -eq 0 ]]; then
    echo -ne ""
  else
    echo -n " %F{$AM_TMUX_COLOR}"
    for (( iter = 0 ; iter < $(ts | wc -l) ; ++iter )); do
      echo -n "${AM_TMUX_SYM}"
    done
    echo -n "%f"
  fi
}
