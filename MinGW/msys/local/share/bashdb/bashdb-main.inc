# -*- shell-script -*-
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
#   with bashdb; see the file COPYING.  If not, write to the Free Software
#   Foundation, 59 Temple Place, Suite 330, Boston, MA 02111 USA.

# Wrapper for debugger called from within bash via bash --debugger
typeset _Dbg_bashdb_main=/usr/local/lib/bashdb/bashdb-main.inc
typeset -x _Dbg_libdir=${_Dbg_bashdb_main%/*}  # dirname(_Dbg_bashdb_main)
. ${_Dbg_libdir}/dbg-pre.sh
if (( ! _Dbg_o_quiet )) ; then 
  echo "Bourne-Again Shell Debugger, release 4.0-0.4"
  printf '
Copyright 2002, 2003, 2004, 2006, 2007, 2008, 2009 Rocky Bernstein
This is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain conditions.

'
fi

# Pull in the rest of the debugger code.
typeset _Dbg_main="$_Dbg_libdir/dbg-main.sh"
if [[ ! -r $_Dbg_main ]] ; then 
  print "${_Dbg_pname}: Can't read debugger library file '${_Dbg_main}'."
  print "${_Dbg_pname}: Perhaps bashdb is installed wrong (if its installed)." >&2
  print "${_Dbg_pname}: Try running bashdb using -L (with a different directory)." >&2
  print "${_Dbg_pname}: Run bashdb --help for a list and explanation of options." >&2
  exit 1
    
fi
. $_Dbg_libdir/dbg-main.sh ;

trap '_Dbg_debug_trap_handler 0 "$BASH_COMMAND" "$@"' DEBUG
