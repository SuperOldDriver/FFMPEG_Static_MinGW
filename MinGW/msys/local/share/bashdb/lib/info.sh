# -*- shell-script -*-
# info.sh - Bourne Again Shell Debugger Help Routines

#   Copyright (C) 2002, 2003, 2004, 2005, 2006, 2008
#   Rocky Bernstein rocky@gnu.org
#
#   bashdb is free software; you can redistribute it and/or modify it under
#   the terms of the GNU General Public License as published by the Free
#   Software Foundation; either version 2, or (at your option) any later
#   version.
#
#   bashdb is distributed in the hope that it will be useful, but WITHOUT ANY
#   WARRANTY; without even the implied warranty of MERCHANTABILITY or
#   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#   for more details.
#   
#   You should have received a copy of the GNU General Public License along
#   with bashdb; see the file COPYING.  If not, write to the Free Software
#   Foundation, 59 Temple Place, Suite 330, Boston, MA 02111 USA.

typeset -r _Dbg_info_cmds='args breakpoints display files functions line program signals source stack terminal variables warranty'

_Dbg_info_help() {
  local -r info_cmd=$1
  local label=$2

  if [[ -z $info_cmd ]] ; then 
      local thing
		_Dbg_msg \
'List of info subcommands:
'
      for thing in $_Dbg_info_cmds ; do 
	_Dbg_info_help $thing 1
      done
      return
  fi

  case $info_cmd in 
    ar | arg | args )
      _Dbg_msg \
"info args -- Argument variables (e.g. \$1, \$2, ...) of the current stack frame."
      return 0
      ;;
    b | br | bre | brea | 'break' | breakp | breakpo | breakpoints | \
    w | wa | wat | watc | 'watch' | watchp | watchpo | watchpoints )
      _Dbg_msg \
'info breakpoints -- Status of user-settable breakpoints'
      return 0
      ;;
    disp | displ | displa | display ) 
      _Dbg_msg \
'info display -- Show all display expressions'
      return 0
      ;;
    fi | file| files | sources )
      _Dbg_msg \
'info files -- Source files in the program'
      return 0
      ;;
    fu | fun| func | funct | functi | functio | function | functions )
      _Dbg_msg \
'info functions -- All function names'
      return 0
      ;;
    l | li| lin | line )
      _Dbg_msg \
'info line -- list current line number and and file name'
      return 0
      ;;
    p | pr | pro | prog | progr | progra | program )
      _Dbg_msg \
'info program -- Execution status of the program.'
      return 0
      ;;
    h | ha | han | hand | handl | handle | \
    si | sig | sign | signa | signal | signals )
      _Dbg_msg \
'info signals -- What debugger does when program gets various signals'
      return 0
      ;;
    so | sou | sourc | source )
      _Dbg_msg \
'info source -- Information about the current source file'
      return 0
      ;;
    st | sta | stac | stack )
      _Dbg_msg \
'info stack -- Backtrace of the stack'
      return 0
      ;;
    te | ter | term | termi | termin | termina | terminal | tt | tty )
      _Dbg_msg \
'info terminal -- Print terminal device'
      return 0
      ;;
    tr|tra|trac|trace|tracep | tracepo | tracepoi | tracepoint | tracepoints )
      _Dbg_msg \
'info tracepoints -- Status of tracepoints'
      return 0
      ;;
    v | va | var | vari | varia | variab | variabl | variable | variables )
      _Dbg_msg \
'info variables -- All global and static variable names'
      return 0
      ;;
    w | wa | war | warr | warra | warran | warrant | warranty )
      _Dbg_msg \
'info warranty -- Various kinds of warranty you do not have'
      return 0
      ;;
    * )
      _Dbg_errmsg \
    "Undefined info command: \"$info_cmd\".  Try \"help info\"."
  esac
}

# List signal handlers in effect.
function _Dbg_info_signals {
  typeset -i i=0
  typeset signal_name
  typeset handler
  typeset stop_flag
  typeset print_flag

  _Dbg_msg "Signal       Stop   Print   Stack     Value"
  _Dbg_printf_nocr "%-12s %-6s %-7s %-9s " EXIT \
    ${_Dbg_sig_stop[0]:-nostop} ${_Dbg_sig_print[0]:-noprint} \
    ${_Dbg_sig_show_stack[0]:-nostack}

  # This is a horrible hack, but I can't figure out how to get
  # trap -p 0 into a variable; handler=`trap -p 0` doesn't work.
  if [[ -n $_Dbg_tty  ]] ; then
    builtin trap -p 0 >>$_Dbg_tty
  else
    builtin trap -p 0
  fi

  while [ 1 ] ; do
    signal_name=$(builtin kill -l $i 2>/dev/null) || break
    handler=$(builtin trap -p $i)
    if [[ -n $handler ]] ; then
      _Dbg_printf "%-12s %-6s %-7s %-9s %-6s" $signal_name \
	${_Dbg_sig_stop[$i]:-nostop} ${_Dbg_sig_print[$i]:-noprint} \
        ${_Dbg_sig_show_stack[$i]:-nostack} "$handler"
    fi
    ((i++))
  done
}

# This is put at the so we have something at the end to stop at 
# when we debug this. By stopping at the end all of the above functions
# and variables can be tested.
typeset -r _Dbg_info_ver=\
'$Id: info.sh,v 1.3 2008/09/09 02:51:45 rockyb Exp $'
