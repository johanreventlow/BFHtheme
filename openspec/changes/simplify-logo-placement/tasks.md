# Implementation Tasks

## Phase 1: API Simplification

- [x] **Update `add_bfh_logo()` signature**
  - Remove `position`, `size`, `padding` parameters
  - Keep `plot`, `logo_path`, `alpha` parameters
  - Set default `logo_path = NULL`
  - Update roxygen documentation

- [x] **Implement fixed positioning logic**
  - Calculate logo height as 1/15 of plot height
  - Calculate logo width from aspect ratio
  - Position logo at x=0 (left edge flush)
  - Position logo at y = 1/15 of plot height from bottom
  - Remove position switch logic
  - Remove padding calculations

- [x] **Implement default logo loading**
  - When `logo_path = NULL`, call `get_bfh_logo(size = "full", variant = "mark")`
  - Handle case where logo file not found
  - Preserve existing security validation

- [x] **Add parameter validation for removed parameters**
  - Detect if `position` is passed via `...`
  - Detect if `size` is passed via `...`
  - Detect if `padding` is passed via `...`
  - Throw informative error with migration guidance

## Phase 2: Testing

- [x] **Update existing tests**
  - Modify `test-branding.R` for new API
  - Update `add_bfh_logo()` test cases
  - Remove tests for removed parameters

- [x] **Add new test cases**
  - Test default logo loading (logo_path = NULL)
  - Test fixed positioning calculations
  - Test logo height = 1/15 of plot height
  - Test logo positioned 1/15 from bottom
  - Test logo flush with left edge
  - Test alpha parameter still works
  - Test error messages for deprecated parameters

- [x] **Visual regression tests**
  - Add vdiffr test for default logo placement
  - Verify logo appears at correct position
  - Verify logo has correct size

## Phase 3: Documentation

- [x] **Update function documentation**
  - Rewrite `add_bfh_logo()` roxygen docs
  - Update examples to show simplified API
  - Remove parameter documentation for removed params
  - Add note about breaking changes in v0.3.0

- [x] **Update vignettes**
  - Update `vignettes/getting-started.Rmd`
  - Update logo placement examples
  - Show default behavior (no logo_path)

- [x] **Update README.md**
  - Update logo placement example
  - Show simplified API

- [x] **Update NEWS.md**
  - Add v0.3.0 section
  - Document breaking changes
  - Provide migration guide
  - List removed parameters

- [x] **Update CONTRIBUTING.md**
  - Update any logo examples
  - Update API reference if present

## Phase 4: Example Files

- [x] **Update example scripts**
  - Update `inst/examples/logo_demo.R`
  - Update `inst/examples/basic_usage.R`
  - Use simplified API throughout

## Phase 5: Version Management

- [x] **Update DESCRIPTION**
  - Bump version to 0.3.0 (breaking change)
  - Update date

- [x] **Regenerate documentation**
  - Run `devtools::document()`
  - Verify NAMESPACE updated
  - Verify man files regenerated

- [x] **Run package checks**
  - Run `devtools::test()` - all tests pass
  - Run `devtools::check()` - no errors/warnings
  - Verify test coverage maintained

## Dependencies

- Phase 2 depends on Phase 1 (can't test until implementation done)
- Phase 3 depends on Phase 1 (documentation should match implementation)
- Phase 4 depends on Phase 1 (examples should use new API)
- Phase 5 depends on Phases 1-4 (final validation after all changes)

## Parallelizable Work

- Documentation updates (Phase 3) can be done in parallel with testing (Phase 2) once Phase 1 is complete
- Example updates (Phase 4) can be done in parallel with documentation (Phase 3)

## Validation Checklist

Before marking complete:
- [x] All tests pass (`devtools::test()`)
- [x] Package check passes (`devtools::check()`)
- [x] Visual regression tests pass (if using vdiffr)
- [x] Documentation builds without warnings
- [x] Examples run without errors
- [x] NEWS.md documents all breaking changes
- [x] Migration guide is clear and complete
