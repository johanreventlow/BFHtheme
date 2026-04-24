# Harden Package Hygiene

**Status:** Proposed
**Created:** 2026-04-24
**Priority:** P2

## Why

Several quality-of-life and stability gaps that are individually minor but collectively reduce confidence in the package:

- **Tests write to `~`:** `tests/testthat/test-branding.R:72` creates `tempfile(... tmpdir = path.expand("~") ...)`. Pollutes user home and fails in restricted sandboxes (e.g. `R CMD check --as-cran` in some configurations).
- **`tests/testthat/Rplots.pdf`** is checked into the repository as a leftover from interactive test runs. It ends up in the source tarball.
- **Visual regression workflow undocumented:** `_snaps/visual-regression/` exists but procedure for accepting/managing snapshots is not documented anywhere.
- **Late-failure inputs:**
  - `theme_bfh(base_size = -1)` produces a malformed theme with negative element sizes.
  - `theme_bfh(base_size = NULL)` errors deep inside `grid::unit()`.
  - `bfh_save(width = -1)` fails late with a memory allocation error.
  - `add_bfh_footer(height = -1)` is not validated at all.

The validation utilities already exist (`R/utils_validation.R` provides `validate_numeric_range()`); they are not consistently applied to public entry points.

## What Changes

1. **Migrate test temp paths** to `withr::local_tempdir()` — no `path.expand("~")` writes.
2. **Delete `tests/testthat/Rplots.pdf`** from the repo, add to `.gitignore` and `.Rbuildignore`.
3. **Add input validation** to `theme_bfh()`, `bfh_save()`, `add_bfh_footer()` using existing `validate_numeric_range()`.
4. **Document visual regression workflow** in CONTRIBUTING.md (snapshot acceptance via `vdiffr::manage_cases()` or `testthat::snapshot_review()`).

## Impact

- **Affected specs:** `package-hygiene` (new capability)
- **Affected code:**
  - `tests/testthat/test-branding.R`
  - `R/themes.R`, `R/helpers.R`, `R/branding.R` (validation)
  - `.Rbuildignore`, `.gitignore`
  - `CONTRIBUTING.md`
- **Breaking:** Stricter input validation may surface latent misuse in downstream code that previously failed late or produced bad output. Document in NEWS.
- **Downstream:** `BFHcharts`, `SPCify` should grep for `theme_bfh(base_size = ...)` and `bfh_save(...)` calls to ensure compliance.

## Related

- Identified in code review (codex, 2026-04-24)
- Builds on existing `R/utils_validation.R` infrastructure
