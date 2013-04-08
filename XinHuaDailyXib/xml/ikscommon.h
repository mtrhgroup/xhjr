#ifdef HAVE_CONFIG_H
#include "iksconfig.h"
#endif

#include <sys/types.h>
#include <stdio.h>
#include <string.h>


#ifdef STDC_HEADERS
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#elif HAVE_STRINGS_H
#include <strings.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif
#ifndef errno
extern int errno;
#endif

#include "finetune.h"
#include "stdlib.h"
