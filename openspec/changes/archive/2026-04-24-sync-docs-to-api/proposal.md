# Sync Documentation to Current API

**Status:** Proposed
**Created:** 2026-04-24
**Priority:** P0 (release-blocker)

## Why

README, vignettes, and `inst/examples/` reference functions and color names that do not exist in the current package NAMESPACE. Users following any documentation hit immediate errors. R CMD check fails on vignette evaluation.

Verified gaps:

| Reference | Used in | Status |
|-----------|---------|--------|
| `add_logo()` | README.md, logo-and-branding.Rmd, troubleshooting.Rmd, inst/examples/logo_demo.R, inst/examples/basic_usage.R | NOT in NAMESPACE |
| `add_watermark()` | README.md | NOT in NAMESPACE |
| `add_bfh_color_bar()` | inst/examples/logo_demo.R | NOT in NAMESPACE |
| `theme_bfh_print()` | inst/examples/logo_demo.R, basic_usage.R | NOT in NAMESPACE (only `theme_bfh()`) |
| `theme_bfh_minimal()` | inst/examples/logo_demo.R, basic_usage.R | NOT in NAMESPACE |
| `add_bfh_logo(..., position=, size=, alpha=)` | logo-and-branding.Rmd, troubleshooting.Rmd | Removed in v0.3.0 (only `alpha` remains in signature, but unimplemented) |
| `bfh_cols("hospital_grey")` | inst/examples/color_demo.R, vignettes | Color does not exist (only `regionh_grey`, `dark_grey`) |

The v0.3.0 simplification of `add_bfh_logo()` (per `simplify-logo-placement` change) was completed in code but not propagated to documentation.

## What Changes

- Audit and rewrite all docs to use only NAMESPACE-exported functions.
- Rewrite `vignettes/logo-and-branding.Rmd` for the simplified `add_bfh_logo(plot, logo_path = NULL)` API.
- Rewrite `vignettes/troubleshooting.Rmd` to remove legacy function references.
- Fix `vignettes/theming.Rmd` and `vignettes/customization.Rmd` `hospital_grey` references to `regionh_grey` (or other appropriate existing color).
- Rewrite or delete `inst/examples/logo_demo.R`, `inst/examples/color_demo.R`, `inst/examples/basic_usage.R`.
- Update `README.md` branding section to use current API.
- Add CI smoke test that parses (does not eval) every example file to catch future drift.

## Impact

- **Affected specs:** `documentation-sync` (new capability)
- **Affected files:** `README.md`, `vignettes/*.Rmd`, `inst/examples/*.R`
- **Breaking:** None (documentation-only; no code changes)
- **Downstream:** External users get working examples; CI vignette build succeeds.

## Related

- Builds on `simplify-logo-placement` (archived 2025-11-13) which removed `position`/`size`/`padding` parameters but did not update docs.
- Identified in code review (codex, 2026-04-24)
