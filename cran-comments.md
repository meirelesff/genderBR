This is a new version (1.4.0) that introduces asymmetrical thresholds for
gender classification and other improvements and bug fixes.

Note on file downloads: `download_gender_model()` downloads pre-trained
model weights from Hugging Face to `tools::R_user_dir("genderBR", "cache")`.
This happens only on explicit user request, never at load or install time,
and the corresponding examples are wrapped in `\dontrun{}` so R CMD check
does not trigger it.

## Test environments

* macOS Tahoe 26.5.1 (personal computer), R 4.6.1
* Fedora 44 (personal computer), R 4.6.1
* GitHub Actions - (ubuntu): release, devel, oldrel-1
* GitHub Actions - (windows-latest): release
* GitHub Actions - (macOS-latest): release
* Winbuilder - (windows server 2022): release, devel

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

There are no reverse dependencies.
