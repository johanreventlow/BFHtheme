# Tasks

## 1. Audit

- [x] 1.1 Run `grep -rn "add_logo\|add_watermark\|add_bfh_color_bar\|theme_bfh_print\|theme_bfh_minimal" README.md vignettes/ inst/examples/`
- [x] 1.2 Run `grep -rn "hospital_grey" .`
- [x] 1.3 Run `grep -rn "add_bfh_logo.*position\|add_bfh_logo.*size\|add_bfh_logo.*padding" .`
- [x] 1.4 Produce a punch list of every line that needs updating

## 2. Rewrites

- [x] 2.1 Update README.md branding section (lines around 167) with current `add_bfh_logo()` API
- [x] 2.2 Rewrite `vignettes/logo-and-branding.Rmd` end-to-end
- [x] 2.3 Rewrite `vignettes/troubleshooting.Rmd` (remove `add_logo`, `theme_bfh_print` references)
- [x] 2.4 Replace `hospital_grey` with `regionh_grey` in `vignettes/theming.Rmd` (not present — no change needed)
- [x] 2.5 Replace `hospital_grey` in `vignettes/customization.Rmd` (not present — no change needed)
- [x] 2.6 Rewrite or delete `inst/examples/logo_demo.R`
- [x] 2.7 Rewrite or delete `inst/examples/color_demo.R`
- [x] 2.8 Rewrite or delete `inst/examples/basic_usage.R`
- [x] 2.9 Decide whether `alpha` parameter is documented (yes — alpha is still in `add_bfh_logo()` signature)

## 3. Verification

- [x] 3.1 `devtools::build_vignettes()` succeeds without errors
- [x] 3.2 `R CMD check` passes without doc-related WARNINGs
- [x] 3.3 Add a testthat test that `parse()`s every `.R` file in `inst/examples/` (catches syntax drift but not semantic drift)
- [x] 3.4 Update `NEWS.md` under "Documentation" section
- [x] 3.5 `openspec validate sync-docs-to-api --strict` passes
