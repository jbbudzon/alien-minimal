#!/usr/bin/env zsh

# shellcheck disable=SC2154
# shellcheck disable=SC2034
# shellcheck disable=SC2116

__import_env() {
  if [[ -z "${1}" ]]; then
    return
  fi
  echo "${1}" | while IFS='\n' read -r line; do
    eval "export $(echo "${line}" | awk -F'=' '{print $1"=\""$2"\""}')" > /dev/null
  done
}

version_prompt(){
  if [[ -n ${1} ]]; then
    LOOP_INDEX=0
    #todo this can be optimized to avoid echo and subshell
    for _v in $(echo "${1}"); do
      if [[ ${_v} == "PYENV" ]]; then
        VAL="$(am_pyenv_version)"
        if [[ "${VAL}" != *"system"* ]]; then
          [[ ${LOOP_INDEX} != "0" ]] && echo -n "%F{$AM_FADE_COLOR}${AM_VERSION_PROMPT_SEP}%f"
          [[ ${LOOP_INDEX} == "0" ]] && LOOP_INDEX=$((LOOP_INDEX + 1)) && echo -n "%F{$AM_FADE_COLOR}[%f"
          echo -n "${VAL}"
        fi
      elif [[ ${_v} == "RBENV" ]]; then
        VAL="$(am_rbenv_version)"
        if [[ "${VAL}" != *"system"* ]]; then
          [[ ${LOOP_INDEX} != "0" ]] && echo -n "%F{$AM_FADE_COLOR}${AM_VERSION_PROMPT_SEP}%f"
          [[ ${LOOP_INDEX} == "0" ]] && LOOP_INDEX=$((LOOP_INDEX + 1)) && echo -n "%F{$AM_FADE_COLOR}[%f"
          echo -n "${VAL}"
        fi
      elif [[ ${_v} == "XCENV" ]]; then
        VAL="$(am_xcenv_version)"
        if [[ "${VAL}" != *"system"* ]]; then
          [[ ${LOOP_INDEX} != "0" ]] && echo -n "%F{$AM_FADE_COLOR}${AM_VERSION_PROMPT_SEP}%f"
          [[ ${LOOP_INDEX} == "0" ]] && LOOP_INDEX=$((LOOP_INDEX + 1)) && echo -n "%F{$AM_FADE_COLOR}[%f"
          echo -n "${VAL}"
        fi
      else
      [[ ${LOOP_INDEX} != "0" ]] && echo -n "%F{$AM_FADE_COLOR}${AM_VERSION_PROMPT_SEP}%f"
      [[ ${LOOP_INDEX} == "0" ]] && LOOP_INDEX=$((LOOP_INDEX + 1)) && echo -n "%F{$AM_FADE_COLOR}[%f"

      [[ ${_v} == "PYTHON" ]]    && am_python_version
      [[ ${_v} == "PYTHON_S" ]]  && am_python_short_version
      [[ ${_v} == "RUBY" ]]      && am_ruby_version
      [[ ${_v} == "RUBY_S" ]]    && am_ruby_short_version
      [[ ${_v} == "JAVA" ]]      && am_java_version
      [[ ${_v} == "JAVA_S" ]]    && am_java_short_version
      [[ ${_v} == "GO" ]]        && am_go_version
      [[ ${_v} == "GO_S" ]]      && am_go_short_version
      [[ ${_v} == "ELIXIR" ]]    && am_elixir_version
      [[ ${_v} == "ELIXIR_S" ]]  && am_elixir_short_version
      [[ ${_v} == "CRYSTAL" ]]   && am_crystal_version
      [[ ${_v} == "CRYSTAL_S" ]] && am_crystal_short_version
      [[ ${_v} == "NODE" ]]      && am_node_version
      [[ ${_v} == "NODE_S" ]]    && am_node_short_version
      [[ ${_v} == "PHP" ]]       && am_php_version
      [[ ${_v} == "PHP_S" ]]     && am_php_short_version
      fi
    done

    [[ "$LOOP_INDEX" != "0" ]] && echo -n "%F{$AM_FADE_COLOR}]%f "
  fi
}

am_vcs_prompt(){
  if [[ $(am_is_git) == 1 ]]; then
    am_git_rebasing
    echo -n "%F{$AM_VCS_COLOR}${AM_GIT_SYM}%f"
    am_git_branch
    am_git_commit_time
    am_git_rev
    am_git_stash
    am_git_left_right
    am_git_dirty
  elif [[ $(am_is_hg) == 1 ]]; then
    echo -n "%F{$AM_VCS_COLOR}${AM_HG_SYM}%f"
    am_hg_branch
    am_hg_rev
  elif [[ $(am_is_svn) == 1 ]]; then
    echo -n "%F{$AM_VCS_COLOR}${AM_SVN_SYM}%f"
    am_svn_rev
  fi
}

am_prompt_dir(){
  end_tag="%F{$AM_PROMPT_END_TAG_COLOR}${AM_PROMPT_END_TAG}%f"
  if [[ ${AM_ERROR_ON_START_TAG} == 1 && ${AM_PROMPT_START_TAG} != "" ]]; then
    start_tag="%(?.%F{$AM_PROMPT_START_TAG_COLOR}${AM_PROMPT_START_TAG}%f.%F{$AM_ERROR_COLOR}${AM_PROMPT_START_TAG}%f)"
    echo -ne "${start_tag}"
    echo -ne "%F{$AM_NORMAL_COLOR}%${AM_DIR_EXPANSION_LEVEL}~%f${end_tag}"
  else
    start_tag="%F{$AM_PROMPT_START_TAG_COLOR}${AM_PROMPT_START_TAG}%f"
    echo -ne "${start_tag}"
    echo -ne "%(?.%F{$AM_NORMAL_COLOR}%${AM_DIR_EXPANSION_LEVEL}~%f${end_tag}.%F{$AM_ERROR_COLOR}%B%${AM_DIR_EXPANSION_LEVEL}~%b%f${end_tag})"
  fi
  [[ ${AM_HIDE_EXIT_CODE} -ne 1 ]] && echo -ne "%(?.. %F{$AM_FADE_COLOR}%?%f)"
  echo -ne " "
}

am_r_prompt_render(){
  cd "${1}" || return
  __import_env "${2}"
  version_prompt "${3}"
  am_vcs_prompt
  if [[ ${AM_ENABLE_VI_PROMPT} == 1 ]]; then
    # shellcheck disable=SC2016
    if [[ ${AM_VI_PROMPT_POS} == 'right_start' ]]; then
      echo -n '${AM_VI_PROMPT_VAL}'"${r_prompt_val}"
    # shellcheck disable=SC2016
    elif [[ ${AM_VI_PROMPT_POS} == 'right_end' ]]; then
      echo -n "${r_prompt_val}"'${AM_VI_PROMPT_VAL}'
    fi
  fi
  unset AM_EMPTY_BUFFER
}

am_l_prompt_render(){
  cd "${1}" || return
  __import_env "${2}"
  echo -n " "
  am_tmux_st
  am_bgjobs_st
  am_ssh_st
  am_venv
  am_prompt_dir
  if [[ ${AM_ENABLE_VI_PROMPT} == 1 ]]; then
    # shellcheck disable=SC2016
    if [[ ${AM_VI_PROMPT_POS} == 'left_start' ]]; then
      echo -n '${AM_VI_PROMPT_VAL}'"${l_prompt_val}"
    # shellcheck disable=SC2016
    elif [[ ${AM_VI_PROMPT_POS} == 'left_end' ]]; then
      echo -n "${l_prompt_val}"'${AM_VI_PROMPT_VAL}'
    fi
  fi
  [[ "${AM_INITIAL_LINE_FEED}" == 1 ]] && echo -n $'\n'"${l_prompt_val}"
  unset AM_EMPTY_BUFFER
}
