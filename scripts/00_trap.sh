#!/bin/bash
## Source: https://github.com/bash-utilities/trap-failure/blob/master/failure.sh
## Outputs Front-Mater formatted failures for functions not returning 0
function failure(){
    local -n _lineno="${1:-LINENO}"
    local -n _bash_lineno="${2:-BASH_LINENO}"
    local _last_command="${3:-${BASH_COMMAND}}"
    local _code="${4:-0}"

    ## Workaround for read EOF combo tripping traps
    ((_code)) || {
      return "${_code}"
    }

    local _last_command_height="$(wc -l <<<"${_last_command}")"

    local -a _output_array=()
    _output_array+=(
        '---'
        "lines_history: [${_lineno} ${_bash_lineno[*]}]"
        "function_trace: [${FUNCNAME[*]}]"
        "exit_code: ${_code}"
    )

    [[ "${#BASH_SOURCE[@]}" -gt '1' ]] && {
        _output_array+=('source_trace:')
        for _item in "${BASH_SOURCE[@]}"; do
            _output_array+=("  - ${_item}")
        done
    } || {
        _output_array+=("source_trace: [${BASH_SOURCE[*]}]")
    }

    [[ "${_last_command_height}" -gt '1' ]] && {
        _output_array+=(
            'last_command: ->'
            "${_last_command}"
        )
    } || {
        _output_array+=("last_command: ${_last_command}")
    }

    _output_array+=('---')
    printf '%s\n' "${_output_array[@]}" | tee -a /tmp/errMsg.log
    if [ -s /tmp/errMsg.log ]; then
      report_error.py "execution" "Failed"
    fi
    exit ${_code}
}

trap 'failure "LINENO" "BASH_LINENO" "${BASH_COMMAND}" "${?}"' EXIT