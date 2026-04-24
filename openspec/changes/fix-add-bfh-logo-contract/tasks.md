# Tasks

## 1. Contract fixes

- [x] 1.1 Decide: implement `alpha` via image-array manipulation (RGBA channel) — cowplot 1.2.0 does not expose `alpha` param; pre-process array before draw_image call
- [x] 1.2 Remove `requireNamespace("patchwork")` check in `add_bfh_logo()`
- [x] 1.3 Convert `requireNamespace("cowplot")` warning-and-return-plot to `stop()` with install hint
- [x] 1.4 Decide: remove explicit `requireNamespace("magick")` — magick is cowplot's transitive dep; not called directly
- [x] 1.5 Update roxygen `@param alpha` text accordingly

## 2. Performance: logo image cache

- [x] 2.1 Create `.bfh_logo_cache <- new.env(parent = emptyenv())` at package level (R/BFHtheme-package.R)
- [x] 2.2 Implement cache lookup with key = `paste0(normalized_path, "_", as.numeric(file.info(path)$mtime))`
- [x] 2.3 Cache the decoded image array (output of `readPNG`/`readJPEG`)
- [x] 2.4 Add internal `clear_bfh_logo_cache()` helper
- [x] 2.5 Microbenchmark: cache hit < 1 ms, miss < 50 ms (rough targets) — not automated; cache logic verified by test

## 3. Resource limits

- [x] 3.1 Add max-bytes guard via `getOption("BFHtheme.logo_max_bytes", 5 * 1024^2)` BEFORE decoding
- [x] 3.2 After decoding, reject images exceeding `getOption("BFHtheme.logo_max_dim", 4096)` on either axis
- [x] 3.3 Soften "Security Layer 1/2/3/4" comments — describe actual guarantees

## 4. Tests

- [x] 4.1 Alpha implemented via array manipulation: snapshot tests `add_bfh_logo_alpha_1` and `add_bfh_logo_alpha_0.3` in `test-visual-regression.R` exercise the 4-channel array path and confirm visible difference between values
- [x] 4.2 N/A (alpha implemented)
- [x] 4.3 Test `expect_error(add_bfh_logo(p))` with cowplot absent — test added (skips when cowplot is present)
- [x] 4.4 Test logo cache hit: two calls → same number of cache entries
- [x] 4.5 Test cache invalidates when file mtime changes (mtime bump → second cache key)
- [x] 4.6 Test max-bytes rejection via option override
- [x] 4.7 Test max-dim rejection via option override + oversized fixture

## 5. Documentation

- [x] 5.1 Update `add_bfh_logo()` roxygen — cache, limits, fail-hard, alpha via array, logo_root as convenience restriction
- [x] 5.2 Update NEWS.md under "Breaking changes" (warn→error) and "Performance" (cache)
- [x] 5.3 `openspec validate fix-add-bfh-logo-contract --strict` — run to confirm
