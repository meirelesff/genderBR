This is a new version (1.4.0) that introduces asymmetrical thresholds for
gender classification: users can now set a different threshold for each sex
in `get_gender()` and `get_gender_nn()` (e.g., `threshold = c(0.9, 0.8)`),
and threshold combinations that would make the female and male bands overlap
are now rejected with an informative error. The release also adds a
`nn_size` argument to split large inputs into batches, a `device` argument
to run neural network inference on a GPU (`cuda` or `mps`), fixes a
vocabulary mismatch in the neural network character encoder (`<UNK>` vs
`<PAD>`), and moves `torch` from `Imports` to `Suggests` -- the neural
network model is now built only when the NN backend is actually used, and a
clear message tells users to install `torch` when it is missing. See
NEWS.md for full details.

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
