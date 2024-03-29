# -*- shell-script -*-
# edit.sh - Bourne Again Shell Debugger Edit routines

#   Copyright (C) 2008 Rocky Bernstein rocky@gnu.org
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
#   with Bash; see the file COPYING.  If not, write to the Free Software
#   Foundation, 59 Temple Place, Suite 330, Boston, MA 02111 USA.

#================ VARIABLE INITIALIZATIONS ====================#

_Dbg_help_add edit \
"edit [LOCATION] -- Edit specified file at LOCATION.

If LOCATION is not given, use the current location. 
Uses EDITOR environment variable contents as editor (or ex as default).
Assumes the editor positions at a file using options +linenumber filename."

_Dbg_do_edit() {
  if (($# > 2)) ; then 
      _Dbg_errmsg "got $# parameters, but need 0 or 1."
      return 2
  fi
  typeset editor=${EDITOR:-ex}
  typeset -i line_number
  if (( $# == 0 )) ; then
    line_number=$_curline
    full_filename="$_Dbg_frame_last_filename"
  else
    _Dbg_linespec_setup "$1"
  fi
  if [[ ! -r $full_filename ]]  ; then 
      _Dbg_errmsg "File $full_filename is not readable"
  fi
  $editor +$line_number $full_filename
}

_Dbg_alias_add 'ed' 'edit'
