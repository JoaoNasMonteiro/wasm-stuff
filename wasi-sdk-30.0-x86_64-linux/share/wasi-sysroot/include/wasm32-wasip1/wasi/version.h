#ifndef __WASI_VERSION_H
#define __WASI_VERSION_H

#ifndef __wasi__
#error <wasi/version.h> is only supported on WASI platforms.
#endif

// After llvm/llvm-project#165345 these can be conditionally defined by a clang
// version test here to use the upstream definitions.
#define __wasip1__
/* #undef __wasip2__ */
/* #undef __wasip3__ */

#define __wasi_sdk_major__ 30
#define __wasi_sdk_version__ "30.0"

#endif /* __WASI_VERSION_H */
