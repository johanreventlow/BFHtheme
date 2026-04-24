# Tasks

## 1. Implementation

- [x] 1.1 Add internal helper `font_available(family)` using `systemfonts::system_fonts()$family`
- [x] 1.2 Replace `match_fonts()` availability checks in `get_bfh_font()`
- [x] 1.3 Replace `match_fonts()` availability checks in `.onLoad()` (Windows block)
- [x] 1.4 Replace `match_fonts()` availability checks in `.onAttach()` (Mari probe)
- [x] 1.5 Replace `match_fonts()` availability checks in `check_bfh_fonts()`
- [x] 1.6 Move `systemfonts` from Suggests to Imports in DESCRIPTION
- [x] 1.7 Add `@importFrom systemfonts system_fonts` where appropriate

## 2. Tests

- [x] 2.1 Test `font_available("NonExistentFont12345")` returns `FALSE`
- [x] 2.2 Test `get_bfh_font()` returns `"sans"` when no priority font installed (mock `system_fonts()`)
- [x] 2.3 Test fallback chain order via mocked `system_fonts()`
- [x] 2.4 Regression test: assert that a font name returning a Helvetica fallback path via `match_fonts()` does NOT trigger a true positive

## 3. Validation

- [x] 3.1 `R CMD check` passes without `invalid font type` warnings on a clean macOS/Linux box without Mari
- [x] 3.2 Clear and re-test font cache via `clear_bfh_font_cache()`
- [x] 3.3 Update `NEWS.md` with bug fix entry under Bug fixes section
- [x] 3.4 `openspec validate fix-font-detection --strict` passes
