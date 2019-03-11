#!/bin/bash
#
# A tool to notify after a command finished.
# To use it, source this script and add '; knock' to your command.

_read_history() {
  local steps_back=${1:-1}  # Default to 1.
  # HISTTIMEFORMAT='' excludes the timestamp, then sed trims the PID and the
  # command itself.
  HISTTIMEFORMAT='' history "${steps_back}" | head -n1 | sed 's/ *[0-9]* *//' | sed 's/; *knock *$//'
}

_knock_bin() {
  (notify-send "$@" &)
}

# If invoked with arguments, sends a "knock" consisting of the given arguments
# Otherwise sends a "knock" with the previous command and its exit status
knock() {
  local return_code=$?
  if (( $# > 0 )); then
    _knock_bin "$@"
  else
    local last_command
    last_command=$(_read_history 1)
    if [[ "${last_command}" =~ ^knock\ ?$ ]]; then
      last_command=$(_read_history 2)
    fi
    if (( return_code == 0 )); then
      _knock_bin "Success: ${last_command}"
    else
      _knock_bin "Failed (${return_code}): ${last_command}"
    fi
  fi
}
