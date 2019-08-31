#!/usr/bin/env zsh

# shellcheck disable=SC2034

THEME_ROOT=${0:A:h}

source "${THEME_ROOT}/modules/init.zsh"

source "${THEME_ROOT}/libs/promptlib/activate"
source "${THEME_ROOT}/libs/zsh-async/async.zsh"
source "${THEME_ROOT}/libs/zsh-256color/zsh-256color.plugin.zsh"

source "${THEME_ROOT}/modules/theme.zsh"
source "${THEME_ROOT}/modules/prompt.zsh"

source "${THEME_ROOT}/modules/git.zsh"
source "${THEME_ROOT}/modules/hg.zsh"
source "${THEME_ROOT}/modules/svn.zsh"
source "${THEME_ROOT}/modules/ssh.zsh"
source "${THEME_ROOT}/modules/async.zsh"
source "${THEME_ROOT}/modules/versions.zsh"

[[ ${AM_ENABLE_VI_PROMPT} == 1 ]] && source "${THEME_ROOT}/modules/viprompt.zsh"

function precmd(){
  autoload -U add-zsh-hook
  setopt prompt_subst
  am_load_theme

  __AM_ENVS="$(env | grep --color=never "ENV_VERSION=\|^VIRTUAL_ENV=\|^AM_")"
  PROMPT="$(am_l_prompt_render "${PWD}" "${__AM_ENVS}")"
  PROMPT="$(echo "${PROMPT}" | tr -s ' ')"

  [[ ${AM_KEEP_PROMPT} != 1 ]] && RPROMPT=""

  am_async_r_prompt
}
