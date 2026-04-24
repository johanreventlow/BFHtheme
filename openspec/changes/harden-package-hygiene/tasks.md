# Tasks

## 1. Test isolation

- [x] 1.1 Replace `tempfile(tmpdir = path.expand("~"), ...)` in `tests/testthat/test-branding.R:72` with logic that exercises the security check WITHOUT actually writing to `~` (e.g. just pass a `~`-prefixed path as input)
- [x] 1.2 Audit all test files for `~`, `path.expand("~")`, hard-coded absolute paths
- [x] 1.3 Wrap state-mutating tests with `withr::local_options()`, `withr::local_envvar()`, `withr::defer()`
- [x] 1.4 Verify tests pass in a sandboxed environment (e.g. `R CMD check --as-cran`)

## 2. Build hygiene

- [x] 2.1 Delete `tests/testthat/Rplots.pdf` from the repository
- [x] 2.2 Add `Rplots.pdf` and `tests/testthat/Rplots.pdf` to `.gitignore`
- [x] 2.3 Verify `^tests/testthat/Rplots\\.pdf$` is in `.Rbuildignore` (already present at root level — confirm or extend)
- [x] 2.4 Build source tarball and inspect: `R CMD build . && tar -tzf BFHtheme_*.tar.gz | grep -E "Rplots|_snaps"` — verify expected exclusions

## 3. Input validation

- [x] 3.1 In `theme_bfh()`: validate `base_size` is positive numeric scalar (not NULL, not negative, not zero)
- [x] 3.2 In `theme_bfh()`: validate `base_family` is character scalar or NULL
- [x] 3.3 In `bfh_save()`: validate `width`, `height`, `dpi` are positive numeric
- [x] 3.4 In `add_bfh_footer()`: validate `height` is in `(0, 1]`
- [x] 3.5 In `add_bfh_footer()`: validate `text` is character scalar or NULL
- [x] 3.6 Reuse `validate_numeric_range()` from `R/utils_validation.R` everywhere

## 4. Visual regression workflow

- [x] 4.1 Add a "Visual regression tests" section to `CONTRIBUTING.md` (or create the file if absent)
- [x] 4.2 Document snapshot acceptance procedure (`vdiffr::manage_cases()` or `testthat::snapshot_review()`)
- [x] 4.3 Document when to accept vs investigate snapshot diffs

## 5. Validation

- [x] 5.1 Run `devtools::check()` in a clean session — must be ERROR-free
- [x] 5.2 Run `devtools::test()` — all tests pass
- [x] 5.3 Update NEWS.md under "Internal changes" and "Bug fixes"
- [x] 5.4 `openspec validate harden-package-hygiene --strict` passes
