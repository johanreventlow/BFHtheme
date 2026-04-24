# Make Global State Mutations Explicit and Reversible

**Status:** Proposed
**Created:** 2026-04-24
**Priority:** P1

## Why

The package mutates user session state on attach and via `set_bfh_defaults()` without saving previous state for restore. This violates the principle that loading a package should not alter global behavior, and makes "undo" impossible.

Verified mutations:

- **`.onLoad()` calls `knitr::opts_chunk$set(dev = "ragg_png", dpi = 300)`** at `R/BFHtheme-package.R:81`. Any user with their own knitr config is silently overridden when they `library(BFHtheme)`.
- **`set_bfh_defaults()` calls `theme_set()` and `update_geom_defaults()` for 10 geoms** without saving previous values.
- **`reset_bfh_defaults()` guesses ggplot2 defaults** (`"black"`, `"grey20"`, etc.) instead of restoring what the user actually had. Users who customized geoms before calling `set_bfh_defaults()` will not get their state back.

Additionally, `add_bfh_logo()` documentation describes `BFHtheme.logo_root` as a sandbox/security boundary; in practice it is a convenience restriction. The narrative oversells the guarantee.

## What Changes

1. **Remove `knitr::opts_chunk$set()` from `.onLoad()`.** Move to a new exported opt-in helper `use_bfh_knitr_defaults(dpi = 300)`.
2. **`set_bfh_defaults()` SHALL save previous state** (theme + each modified geom default) to the package-internal `.bfh_state` environment before mutation.
3. **`reset_bfh_defaults()` SHALL restore from `.bfh_state`** — fall back to `theme_gray()` and a message only if no saved state exists.
4. **Update `.onAttach()` startup message** to drop the "knitr: ragg_png" config info.
5. **Soften `BFHtheme.logo_root` documentation** — describe as convenience restriction, not sandbox.
6. **Add a vignette section** documenting opt-in knitr setup.

## Impact

- **Affected specs:** `global-state-management` (new capability)
- **Affected code:** `R/BFHtheme-package.R`, `R/defaults.R`, `R/branding.R` (doc strings)
- **Breaking:** YES for knitr behavior. Users relying on auto-set ragg_png must call `use_bfh_knitr_defaults()` explicitly. Pre-1.0 MINOR bump with prominent NEWS entry. Verify SPCify and BFHcharts are not affected before releasing.
- **Downstream:** `SPCify` may rely on auto-knitr; coordinate migration.

## Related

- Identified in code review (codex, 2026-04-24)
- Aligns with R package best practice: do not mutate user session on load
