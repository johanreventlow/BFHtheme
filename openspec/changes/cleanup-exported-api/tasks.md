# Implementation Tasks

## 1. Remove Exported Functions

- [ ] 1.1 Remove `add_logo()` function from `R/logo_helpers.R`
- [ ] 1.2 Remove `apply_bfh_theme()` function from `R/defaults.R`
- [ ] 1.3 Remove `add_bfh_color_bar()` function from `R/helpers.R`
- [ ] 1.4 Update tests in `tests/testthat/test-logo_helpers.R` (remove `add_logo()` tests)
- [ ] 1.5 Update tests in `tests/testthat/test-defaults.R` (remove `apply_bfh_theme()` tests)
- [ ] 1.6 Update tests in `tests/testthat/test-helpers.R` (remove `add_bfh_color_bar()` tests)

## 2. Unexport Internal Functions

- [ ] 2.1 Remove `@export` tag from `clear_bfh_font_cache()` in `R/fonts.R`
- [ ] 2.2 Remove `@export` tag from `check_bfh_fonts()` in `R/fonts.R`
- [ ] 2.3 Remove `@export` tag from `install_roboto_font()` in `R/fonts.R`
- [ ] 2.4 Remove `@export` tag from `setup_bfh_fonts()` in `R/fonts.R`
- [ ] 2.5 Remove `@export` tag from `set_bfh_fonts()` in `R/fonts.R`
- [ ] 2.6 Remove `@export` tag from `set_bfh_graphics()` in `R/fonts.R`
- [ ] 2.7 Remove `@export` tag from `use_bfh_showtext()` in `R/fonts.R`
- [ ] 2.8 Remove `@export` tag from `clear_bfh_pal_cache()` in `R/colors.R`
- [ ] 2.9 Remove `@export` tag from `get_bfh_dimensions()` in `R/helpers.R`
- [ ] 2.10 Update function documentation to note these are internal (add `@keywords internal`)

## 3. Update Tests for Internal Functions

- [ ] 3.1 Update font tests to use `:::` for internal function access in `tests/testthat/test-fonts.R`
- [ ] 3.2 Update color tests to use `:::` for `clear_bfh_pal_cache()` in `tests/testthat/test-colors.R`
- [ ] 3.3 Update helper tests to use `:::` for `get_bfh_dimensions()` in `tests/testthat/test-helpers.R`

## 4. Regenerate Documentation

- [ ] 4.1 Run `devtools::document()` to regenerate NAMESPACE and man pages
- [ ] 4.2 Verify NAMESPACE exports exactly 39 functions (down from 51)
- [ ] 4.3 Run `devtools::check()` to ensure no documentation errors

## 5. Update Vignettes and Examples

- [ ] 5.1 Search vignettes for references to removed functions: `rg "add_logo|apply_bfh_theme|add_bfh_color_bar" vignettes/`
- [ ] 5.2 Update any vignette examples to use new patterns
- [ ] 5.3 Verify all vignettes build successfully: `devtools::build_vignettes()`

## 6. Update README and Documentation

- [ ] 6.1 Check README.md for references to removed functions
- [ ] 6.2 Create NEWS.md entry documenting breaking changes
- [ ] 6.3 Add migration guide section to NEWS.md
- [ ] 6.4 Update DESCRIPTION version to 1.0.0 (major version bump)

## 7. Testing and Validation

- [ ] 7.1 Run full test suite: `devtools::test()` - all tests must pass
- [ ] 7.2 Run package check: `devtools::check()` - 0 errors, 0 warnings, 0 notes
- [ ] 7.3 Test coverage: `covr::package_coverage()` - maintain ≥90% coverage
- [ ] 7.4 Manual testing: Create example plots using only exported API

## 8. Final Review

- [ ] 8.1 Review all changed files for consistency
- [ ] 8.2 Verify no references to removed functions remain in exported code
- [ ] 8.3 Confirm breaking changes are clearly documented
- [ ] 8.4 Run `openspec validate cleanup-exported-api --strict`

Tracking: GitHub Issue #45
