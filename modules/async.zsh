#!/usr/bin/env zsh

# shellcheck disable=SC2034

r_prompt_completed(){
#  exec &>/dev/tty
  RPROMPT=${3}
  zle && zle reset-prompt
}

am_async_r_prompt(){
  __AM_ENVS="$(env | grep --color=never "${AM_VERSIONS_REGEX}")"
  async_init
  async_stop_worker "right_prompt_$$"
  async_start_worker "right_prompt_$$" -n
  async_register_callback "right_prompt_$$" r_prompt_completed
  async_job "right_prompt_$$" am_r_prompt_render "${PWD}" "${__AM_ENVS}" "${AM_VERSIONS_PROMPT}"
}

l_prompt_completed(){
#  exec &>/dev/tty
  PROMPT=${3}
  zle && zle reset-prompt
}

am_async_l_prompt(){
  __AM_ENVS="$(env | grep --color=never "${AM_VERSIONS_REGEX}")"
  async_init
  async_stop_worker "left_prompt_$$"
  async_start_worker "left_prompt_$$" -n
  async_register_callback "left_prompt_$$" l_prompt_completed
  async_job "left_prompt_$$" am_l_prompt_render "${PWD}" "${__AM_ENVS}"
}
