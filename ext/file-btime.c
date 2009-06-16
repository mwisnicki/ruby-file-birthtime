/**********************************************************************

  file-birthtime.c -

  Copyright (C) 2009  Marcin Wisnicki

  Derived from file.c from ruby-1.8.7-p160.

  TODO:
  1. setting btime (maybe #utimes3(atime,mtime,btime,...) ?)
  2. port to WIN32
  3. port to MacOSX
  4. port to Solaris (zfs stores file creation times)
  
**********************************************************************/

#include "ruby.h"
#include "rubyio.h"
#include "util.h"
#include "dln.h"

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_SYS_PARAM_H
# include <sys/param.h>
#endif
#ifndef MAXPATHLEN
# define MAXPATHLEN 1024
#endif

#include <time.h>

#ifdef HAVE_UTIME_H
#include <utime.h>
#elif defined HAVE_SYS_UTIME_H
#include <sys/utime.h>
#endif

#ifdef HAVE_PWD_H
#include <pwd.h>
#endif

#include <sys/types.h>
#include <sys/stat.h>

static struct stat*
get_stat(self)
    VALUE self;
{
    struct stat* st;
    Data_Get_Struct(self, struct stat, st);
    if (!st) rb_raise(rb_eTypeError, "uninitialized File::Stat");
    return st;
}

static VALUE
get_birthtime(struct stat* st) {
    return (st->st_birthtime >= 0) ? rb_time_new(st->st_birthtime, 0) : Qnil;
}

static int
rb_stat(file, st)
    VALUE file;
    struct stat *st;
{
    VALUE tmp;

    tmp = rb_check_convert_type(file, T_FILE, "IO", "to_io");
    if (!NIL_P(tmp)) {
	rb_io_t *fptr;

	rb_secure(2);
	GetOpenFile(tmp, fptr);
	return fstat(fileno(fptr->f), st);
    }
    SafeStringValue(file);
    return stat(StringValueCStr(file), st);
}

static VALUE rb_stat_btime _((VALUE));

/*
 *  call-seq:
 *     stat.btime   => time
 *  
 *  Returns the file creation time for this file as an object of class
 *  <code>Time</code>.
 *     
 *     File.stat("testfile").atime   #=> Wed Dec 31 18:00:00 CST 1969
 *     
 */

static VALUE
rb_stat_btime(self)
    VALUE self;
{
    return get_birthtime(get_stat(self));
}

/*
 *  call-seq:
 *     File.btime(file_name)  =>  time
 *  
 *  Returns the birth (creation) time for the named file (as a <code>Time</code> object).
 *     
 *     File.btime("testfile")   #=> Wed Apr 09 08:51:48 CDT 2003
 *     
 */

static VALUE
rb_file_s_btime(klass, fname)
    VALUE klass, fname;
{
    struct stat st;

    if (rb_stat(fname, &st) < 0)
	rb_sys_fail(StringValueCStr(fname));
    return get_birthtime(&st);
}

/*
 *  call-seq:
 *     file.btime    => time
 *  
 *  Returns the birth (ccreation) time (a <code>Time</code> object)
 *   for <i>file</i>, or epoch if <i>birthtime</i> is not recorded.
 *     
 *     File.new("testfile").btime   #=> Wed Dec 31 18:00:00 CST 1969
 *     
 */

static VALUE
rb_file_btime(obj)
    VALUE obj;
{
    rb_io_t *fptr;
    struct stat st;

    GetOpenFile(obj, fptr);
    if (fstat(fileno(fptr->f), &st) == -1) {
	rb_sys_fail(fptr->path);
    }
    return get_birthtime(&st);
}

/*
 *  File creation times are platform specific.
 */

void
Init_file_btime()
{
    rb_define_singleton_method(rb_cFile, "btime", rb_file_s_btime, 1);
    rb_define_method(rb_cFile, "btime", rb_file_btime, 0);
    rb_define_method(rb_cStat, "btime", rb_stat_btime, 0);
}
