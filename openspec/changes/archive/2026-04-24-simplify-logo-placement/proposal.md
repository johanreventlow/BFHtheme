# Simplify Logo Placement API

**Status:** Proposed
**Created:** 2025-11-13
**Author:** System (based on user requirements)

## Problem Statement

The current `add_bfh_logo()` function has a complex API with multiple positioning options, size parameters, and padding controls. Users need a simpler, more consistent way to add the BFH mark logo to plots with standardized placement matching official branding guidelines.

**Current issues:**
- Too many configuration options lead to inconsistent logo placement across visualizations
- Position parameter allows placement in any corner, creating visual inconsistency
- Size and padding parameters enable non-standard logo sizing
- Logo not automatically positioned at exact plot edge as per branding requirements

## Proposed Solution

Simplify `add_bfh_logo()` to enforce consistent BFH branding:

### Simplified API

```r
add_bfh_logo(plot, logo_path = NULL, alpha = 1)
```

### Fixed Positioning

- **Location:** Always bottom-left corner, flush with plot edge
- **Logo height:** Exactly 1/15 of total plot height
- **Vertical offset:** 1/15 of plot height from bottom edge
- **Horizontal position:** Flush against left edge (0 padding)
- **Default logo:** `bfh_mark.png` (full resolution symbol mark)

### Rationale

1. **Consistency:** All plots use identical logo placement matching brand guidelines
2. **Simplicity:** Fewer parameters = easier to use, harder to misuse
3. **Compliance:** Fixed sizing ensures logo prominence requirements are met
4. **Quality:** Default to high-resolution mark for print-quality output

## Breaking Changes

**Removed parameters:**
- `position` - Logo always placed bottom-left
- `size` - Logo height always 1/15 of plot height
- `padding` - Logo always flush with edge (0 padding)

**Migration:**
```r
# OLD (v0.2.0)
add_bfh_logo(p, logo_path, position = "bottomleft", size = 0.1, padding = 0.02)

# NEW (v0.3.0)
add_bfh_logo(p)  # Uses default bfh_mark.png, fixed positioning
# OR
add_bfh_logo(p, logo_path = get_bfh_logo(variant = "mark"))
```

## Requirements

### REQ-1: Fixed Logo Positioning

The function SHALL place the logo at a fixed position:
- Left edge: 0 offset (flush with plot boundary)
- Bottom edge: 1/15 of plot height from bottom
- Logo height: 1/15 of plot height
- Aspect ratio: Preserved from source image

#### Scenario: Standard plot with logo

**Given** a ggplot2 plot object
**When** `add_bfh_logo(plot)` is called
**Then** the logo MUST appear at the bottom-left corner
**And** the logo height MUST be 1/15 of the total plot height
**And** the logo MUST be positioned 1/15 of plot height from the bottom edge
**And** the logo MUST be flush against the left edge with no padding

### REQ-2: Default Logo Asset

The function SHALL use `bfh_mark.png` (full resolution) by default when `logo_path = NULL`.

#### Scenario: Logo path not specified

**Given** a plot object
**When** `add_bfh_logo(plot)` is called without `logo_path`
**Then** the function MUST load `inst/logo/bfh_mark.png` via `get_bfh_logo(variant = "mark")`
**And** MUST render this logo at the fixed position

### REQ-3: Preserved Alpha Control

The function SHALL retain the `alpha` parameter for transparency control.

#### Scenario: Custom transparency

**Given** a plot with a busy background
**When** `add_bfh_logo(plot, alpha = 0.7)` is called
**Then** the logo MUST be rendered with 70% opacity
**And** all other positioning rules MUST still apply

### REQ-4: Backward Compatibility Warning

The function SHALL detect removed parameters and provide informative error messages.

#### Scenario: Deprecated parameter used

**Given** legacy code using removed parameters
**When** `add_bfh_logo(plot, position = "topright")` is called
**Then** the function MUST stop with an error
**And** the error message MUST explain the parameter was removed in v0.3.0
**And** MUST suggest the simplified API

## Implementation Notes

- Use `grid::rasterGrob()` for logo rendering (existing approach)
- Calculate logo dimensions based on image aspect ratio
- Position using absolute `grid::unit()` coordinates
- Maintain security validation from current implementation
- Default logo resolution via `get_bfh_logo(size = "full", variant = "mark")`

## Testing Requirements

- Unit tests for fixed positioning calculations
- Visual regression tests comparing logo placement
- Tests for alpha transparency
- Tests for error messages on deprecated parameters
- Tests for default logo loading when path is NULL

## Documentation Updates

- Update `add_bfh_logo()` roxygen documentation
- Update package vignettes showing simplified API
- Add migration guide in NEWS.md
- Update example code in README.md and CONTRIBUTING.md

## Related Specs

- `branding-api` - Logo placement requirements
- `visual-identity` - BFH brand guidelines compliance
