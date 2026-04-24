# Fix add_bfh_logo() Contract and Performance

**Status:** Proposed
**Created:** 2026-04-24
**Priority:** P1

## Why

`add_bfh_logo()` documents and validates parameters it does not use, declares dependencies it does not call, and re-reads the logo file on every invocation. Specifically:

- **`alpha` unused:** The parameter is validated at `R/branding.R:130` but never passed to `cowplot::draw_image()` or any other rendering call. Documentation promises transparency control that does not happen.
- **`patchwork` declared but not called:** `requireNamespace("patchwork")` at line 167 returns plot-without-logo if missing, but `patchwork` is never actually used in the implementation.
- **`magick` declared explicitly but used transitively:** Only `cowplot::draw_image()` is called directly; `magick` is cowplot's dependency, not BFHtheme's.
- **Silent failure on missing dependency:** Returning the plot without logo is a brand-compliance violation. For a function whose entire purpose is branding, fail-hard is the correct contract.
- **No image caching:** `png::readPNG()` / `jpeg::readJPEG()` runs on every call. In a Quarto report rendering 50+ plots, this is measurable overhead.
- **No resource limits:** Arbitrarily large PNG/JPEG files are accepted, with no guard against decompression bombs.
- **Overstated security narrative:** Code comments label path normalization as "Security Layer 1/2/3/4". The actual guarantees are narrower than the prose suggests.

## What Changes

1. **Decide and act on `alpha`:** Either implement (pass through to `cowplot::draw_image(alpha = alpha)`) or remove the parameter from the signature.
2. **Remove `patchwork` requireNamespace check** — dead code.
3. **Promote dependency check to fail-hard:** `stop()` instead of warn-and-skip when `cowplot` (or `magick` if kept) is missing.
4. **Add internal logo image cache** (`.bfh_logo_cache`) keyed on `paste(normalized_path, file.info(path)$mtime)`.
5. **Add resource limits:**
   - `getOption("BFHtheme.logo_max_bytes", 5 * 1024^2)` cap on file size pre-read.
   - Reject decoded images exceeding 4096×4096 pixels.
6. **Soften "Security Layer" comments** — describe what the code actually guarantees (path normalization + size cap + MIME sniff), not what it doesn't.

## Impact

- **Affected specs:** `branding-api` (modify existing — capability defined in archived `simplify-logo-placement` change)
- **Affected code:** `R/branding.R`, `tests/testthat/test-branding.R`
- **Breaking:** Behavior change for missing-dependency case (warn → error). Document loudly in NEWS as P1 bump (pre-1.0 MINOR).
- **Downstream:** `BFHcharts`, `SPCify` — verify they don't rely on warning-and-skip behavior. Logo cache speeds up multi-plot reports.

## Related

- Builds on `simplify-logo-placement` (archived 2025-11-13)
- Performance gap also identified by gemini review (2026-04-24)
- Contract gaps identified by codex review (2026-04-24)
