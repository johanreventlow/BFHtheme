# Fix Font Detection

**Status:** Proposed
**Created:** 2026-04-24
**Priority:** P0 (release-blocker)

## Why

`systemfonts::match_fonts("Mari")` returns a fallback path (e.g. `/System/Library/Fonts/Helvetica.ttc`) on systems where Mari is not installed. The current `get_bfh_font()` treats "has path" as "font exists", so on machines without Mari it still returns `"Mari"`. `theme_bfh()` then sets `base_family = "Mari"`, causing R CMD check warnings (`invalid font type`), missing-glyph rendering on CI, and failed plots for external users.

Empirical verification: `systemfonts::match_fonts("Mari_NoSuchFont12345")$path` returns `/System/Library/Fonts/Helvetica.ttc`. The bug is reproducible.

The same flawed probe is used in three places: `get_bfh_font()`, `.onLoad()` (Windows font registration), and `.onAttach()` (Mari probe for startup message). All three exhibit the bug.

## What Changes

- Add internal helper `font_available(family)` using exact match against `systemfonts::system_fonts()$family`.
- Replace `match_fonts()` availability checks in `get_bfh_font()`, `.onLoad()`, `.onAttach()`, and `check_bfh_fonts()`.
- Move `systemfonts` from `Suggests` to `Imports` in DESCRIPTION (now required for correctness, not optimization).
- Add unit tests asserting unknown font names are rejected even when `match_fonts()` returns a fallback path.

## Impact

- **Affected specs:** `font-detection` (new capability)
- **Affected code:** `R/fonts.R`, `R/BFHtheme-package.R`, `DESCRIPTION`
- **Breaking:** None for end users. Return values unchanged when target font is genuinely installed; bug fix only.
- **Downstream:** `BFHcharts`, `SPCify` benefit from correct font selection on production servers.

## Related

- Identified in code review (codex, 2026-04-24)
- Independent verification confirmed: `systemfonts::match_fonts()` falls back to system default
