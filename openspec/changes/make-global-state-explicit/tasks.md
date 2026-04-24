# Tasks

## 1. Remove implicit knitr mutation

- [x] 1.1 Remove `knitr::opts_chunk$set(dev = "ragg_png", dpi = 300)` block from `.onLoad()` in `R/BFHtheme-package.R`
- [x] 1.2 Add new exported `use_bfh_knitr_defaults(dpi = 300)` helper in `R/knitr_setup.R`
- [x] 1.3 Remove `.bfh_state$ragg_configured` tracking flag
- [x] 1.4 Remove "knitr: ragg_png" line from `.onAttach()` startup message
- [x] 1.5 Add `@export` and roxygen for `use_bfh_knitr_defaults()`
- [x] 1.6 Run `devtools::document()` to update NAMESPACE

## 2. Reversible defaults

- [x] 2.1 Define `.bfh_state$previous_theme` field
- [x] 2.2 Define `.bfh_state$previous_geoms` field (named list of `geom_name -> aesthetic list`)
- [x] 2.3 In `set_bfh_defaults()`: capture `theme_get()` result before `theme_set()`
- [x] 2.4 In `set_bfh_defaults()`: capture each geom's current default via `Geom$default_aes` before each `update_geom_defaults()` — using exported ggproto objects (ggplot2 >= 3.4.0 compatible)
- [x] 2.5 Rewrite `reset_bfh_defaults()` to restore from `.bfh_state` if present
- [x] 2.6 Fall back to `theme_gray()` only when `.bfh_state$previous_theme` is NULL, with a message

## 3. Documentation honesty

- [x] 3.1 Update `add_bfh_logo()` roxygen — replace "sandbox for high-security applications" with "convenience restriction" / "path-prefix check"
- [x] 3.2 Soften "Security Layer 1/2/3/4" comments in `R/branding.R` — done as part of fix-add-bfh-logo-contract
- [x] 3.3 Add vignette section "Opt-in knitr setup" in `vignettes/logo-and-branding.Rmd`

## 4. Tests

- [x] 4.1 Test that `library(BFHtheme)` does not modify `knitr::opts_chunk$get("dev")`
- [x] 4.2 Test set→reset cycle restores user's previous theme (theme_classic as before-state)
- [x] 4.3 Test set→reset cycle restores user's previous geom defaults (custom point colour as before-state)
- [x] 4.4 Test `reset_bfh_defaults()` without prior `set_bfh_defaults()` falls back gracefully and emits message
- [x] 4.5 Use `on.exit()` to isolate global state mutations across tests (withr not in Suggests)

## 5. Migration

- [x] 5.1 NEWS.md entry under "Breaking changes" with migration snippet
- [x] 5.2 Notify SPCify and BFHcharts maintainers (coordinate downstream bumps per VERSIONING_POLICY.md §E) — GitHub issues: BFHcharts#180, biSPCharts#310
- [x] 5.3 `openspec validate make-global-state-explicit --strict` — run to confirm
