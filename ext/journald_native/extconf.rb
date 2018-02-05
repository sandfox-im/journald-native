##
# journald-native ruby gem - a simple systemd-journal wrapper
# Copyright (C) 2014 Anton Smirnov
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#

require 'mkmf'

LIBDIR      = RbConfig::CONFIG['libdir']
INCLUDEDIR  = RbConfig::CONFIG['includedir']

HEADER_DIRS = [INCLUDEDIR]
LIB_DIRS    = [LIBDIR]

dir_config('systemd', HEADER_DIRS, LIB_DIRS)

$CFLAGS = '-std=c11'

SD_JOURNAL_HEADER = 'systemd/sd-journal.h'

def have_funcs
  # check functions. redefine const list in sd_journal.h if changed
  %w(sd_journal_print sd_journal_sendv sd_journal_perror).inject(true) do |have_funcs, func|
    have_funcs && have_func(func, SD_JOURNAL_HEADER)
  end
end

# check headers
have_header(SD_JOURNAL_HEADER)

# first try to find funcs in systemd
have_library('systemd')

unless have_funcs
  have_library('systemd-journal') # try to fall back to systemd-journal if older systemd
  have_funcs
end

create_header
create_makefile('journald_native')
