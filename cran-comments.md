* This time, the DESCRIPTION contains a reference to the API from where the package retrives data (<https://censo2010.ibge.gov.br/nomes/>)

This submission replaces a previous version removed from CRAN. It fixes the error found in CRAN routine checks -- because of an @example that used external data from an API that is now under \dontrun. Moreover, this version improves by implementing:

- A few minor bug fixes that make the packages' functions more robust;
- Several new internal input tests;
- New unit tests.

All these improvements aim to make the package more stable. Moreover, I plan to work on new features and commit myself to continue releasing bug fixes and minor updates.

## Test environments
* Ubuntu 20.04 (personal computer), R 4.0.5
* Windows server 2012 R2 x64 (on Appveyor), 4.0.3 Patched
* GitHub Actions - (ubuntu-20.04): release, devel
* GitHub Actions - (windows-latest): release
* GitHub Actions - (macOS-latest): release

## R CMD check results

0 errors | 0 warnings | 0 note

* There was one NOTE on win-builder: X-CRAN-Comment: Archived on 2021-02-21 for policy violation.
This is a new resubmission that replaces the previous archived version.

## Reverse dependencies

There are no reverse dependencies.
