# Technical Design: Simplified Logo Placement

## Overview

This change simplifies the `add_bfh_logo()` API from a flexible positioning system to a fixed-placement, brand-compliant approach. The implementation focuses on maintaining existing security and quality features while reducing configuration complexity.

## Architecture Decisions

### 1. Positioning Approach

**Decision:** Use fixed `grid::unit()` coordinates with NPC (Normalized Parent Coordinates)

**Rationale:**
- Current implementation uses `grid::rasterGrob()` with NPC units - proven approach
- NPC units (0-1 scale) are resolution-independent
- No need for cowplot or magick - grid package sufficient for fixed placement
- Maintains compatibility with existing `annotation_custom()` approach

**Implementation:**
```r
# Logo dimensions (1/15 of plot height)
logo_height_npc <- 1/15
logo_width_npc <- logo_height_npc / aspect_ratio  # Preserve aspect ratio

# Fixed position: bottom-left, flush with edge
x <- grid::unit(logo_width_npc / 2, "npc")  # Center logo horizontally at its width
y <- grid::unit(1/15 + logo_height_npc / 2, "npc")  # 1/15 from bottom + half height

logo_raster <- grid::rasterGrob(
  logo,
  x = x,
  y = y,
  width = grid::unit(logo_width_npc, "npc"),
  height = grid::unit(logo_height_npc, "npc"),
  gp = grid::gpar(alpha = alpha)
)
```

### 2. Why Not cowplot or magick?

**Considered:** Using `cowplot::draw_image()` or `magick` for compositing

**Rejected because:**
- **cowplot:** Adds dependency for functionality already achievable with grid
- **magick:** Heavy dependency (requires ImageMagick system library)
- **Current approach:** `grid::rasterGrob()` + `annotation_custom()` is lightweight and works
- **Performance:** No need for external tools when grid can handle fixed placement
- **Compatibility:** Fewer dependencies = fewer installation issues

**When to use cowplot/magick:**
- Cowplot: If we needed complex multi-plot layouts with logos (not required here)
- Magick: If we needed image manipulation (resize, effects, etc.) - not needed for fixed placement

### 3. Default Logo Selection

**Decision:** Use `bfh_mark.png` (full resolution) as default

**Rationale:**
- User confirmed preference for full resolution
- Mark variant (symbol only) is more compact than full logo
- High resolution ensures quality in all output scenarios
- `get_bfh_logo(size = "full", variant = "mark")` resolves to `inst/logo/bfh_mark.png`

**Fallback behavior:**
```r
if (is.null(logo_path)) {
  logo_path <- get_bfh_logo(size = "full", variant = "mark")
  if (is.null(logo_path)) {
    stop("BFH mark logo not found. Package may not be installed correctly.", call. = FALSE)
  }
}
```

### 4. Parameter Deprecation Strategy

**Decision:** Remove parameters entirely (not deprecate with warnings)

**Rationale:**
- This is v0.3.0 (minor version bump allows breaking changes per semver)
- Clean break is clearer than lingering deprecated parameters
- Simpler function signature is more maintainable
- Following same pattern as v0.2.0 (removed wrapper functions)

**Implementation:**
```r
add_bfh_logo <- function(plot, logo_path = NULL, alpha = 1) {
  # Function body
}
```

**Error handling for legacy code:**
Users might call with removed parameters via `...`, but since we don't accept `...`, R will give clear error:
```
Error in add_bfh_logo(plot, position = "topright") :
  unused argument (position = "topright")
```

**Enhanced error:** We could add explicit parameter checking via `missing()` or check `names(match.call())`, but standard R error is sufficient and idiomatic.

### 5. Coordinate System

**Current approach (keep):**
```r
plot +
  ggplot2::annotation_custom(
    logo_raster,
    xmin = -Inf, xmax = Inf,
    ymin = -Inf, ymax = Inf
  ) +
  ggplot2::coord_cartesian(clip = "off")
```

**Why this works:**
- `annotation_custom()` with Inf bounds means "cover entire plot area"
- Logo grob positions itself within this area using its own units
- `clip = "off"` allows logo to extend beyond plot panel if needed
- NPC units in rasterGrob are relative to the annotation area (= plot area)

### 6. Aspect Ratio Preservation

**Current logic (keep):**
```r
logo_dims <- dim(logo)
logo_height <- logo_dims[1]  # pixels
logo_width <- logo_dims[2]   # pixels
aspect_ratio <- logo_height / logo_width

# Given fixed height in NPC units
logo_height_npc <- 1/15
# Calculate width to preserve aspect ratio
logo_width_npc <- logo_height_npc / aspect_ratio
```

This ensures logo never distorts, regardless of plot dimensions.

### 7. Security Considerations

**Keep existing security features:**
- Path normalization and validation
- File type detection via magic bytes
- Optional root directory sandboxing
- File size and readability checks

**No changes needed** - these are orthogonal to positioning logic.

## Implementation Plan

### Phase 1: Core Changes
1. Update function signature (remove 3 parameters, add default logo_path = NULL)
2. Implement fixed positioning calculations
3. Implement default logo loading
4. Remove position switch statement
5. Remove padding calculations

### Phase 2: Testing
1. Update existing test-branding.R tests
2. Add tests for default logo loading
3. Add tests for fixed positioning calculations
4. Add visual regression test (optional, if vdiffr available)

### Phase 3: Documentation
1. Update roxygen docs for add_bfh_logo()
2. Update NEWS.md with v0.3.0 breaking changes
3. Update README.md examples
4. Update vignettes

### Phase 4: Validation
1. Run devtools::document()
2. Run devtools::test()
3. Run devtools::check()
4. Manual visual verification with example plots

## Risk Assessment

**Low risk:**
- Implementation is straightforward simplification
- No new dependencies required
- Core rendering logic unchanged
- Breaking changes clearly documented

**Mitigation:**
- Comprehensive tests ensure positioning is correct
- NEWS.md provides migration guide
- Error messages help users fix legacy code

## Performance Impact

**Expected:** Neutral to slight improvement
- Removed branching logic (no position switch)
- Removed redundant calculations (no padding math)
- Default logo loading cached by get_bfh_logo()

## Alternatives Considered

### Alternative 1: Keep position parameter with "left" default
**Rejected:** Still allows inconsistency, doesn't simplify enough

### Alternative 2: Use cowplot for composition
**Rejected:** Unnecessary dependency, grid is sufficient

### Alternative 3: Deprecate parameters instead of remove
**Rejected:** Creates technical debt, unclear migration path

### Alternative 4: Make logo height configurable
**Rejected:** Defeats purpose of standardization

## Related Work

- v0.2.0 API cleanup removed wrapper functions (similar simplification approach)
- BFH brand guidelines likely specify logo placement rules (confirm with user)
- Other branding functions (add_bfh_footer, bfh_title_block) use similar fixed positioning

## Open Questions

None - all requirements clarified with user via questions.
