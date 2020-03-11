#!/bin/bash

am_tmux_st(){
  if [[ -n "${TMUX}" || "$(tmux ls 2>/dev/null | wc -l)" -eq 0 ]]; then
    echo -ne ""
  else
    echo -n " %F{$AM_TMUX_COLOR}${AM_TMUX_SYM}%f"
  fi
}
