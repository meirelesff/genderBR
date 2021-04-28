This submission replaces a previous version removed from CRAN. It fixes the error
found in routine checks -- because of an @example that used external data from an API
that is now under \dontrun. Moreover, this version improves by implementing:

- A few minor bug fixes that makes the packages' functions more robust;
- Several new internal input tests;
- New unit tests.

All these improvements aim to make the package more stable. In addition, in
the near future I plan to work on new features and commit myself to continue shipping new
bug fixes in case they happen to be needed.

## Test environments
* Ubuntu 20.04 (personal computer), R 4.0.5
* Windows server 2012 R2 x64 (on Appveyor), 4.0.3 Patched
* Win-builder (release and devel)
* GitHub Actions - (ubuntu-18.04): 3.3, 3.4, 3.5, oldrel, release, devel

## R CMD check results

0 errors | 0 warnings | 0 note

## Reverse dependencies

There are no reverse dependencies.
