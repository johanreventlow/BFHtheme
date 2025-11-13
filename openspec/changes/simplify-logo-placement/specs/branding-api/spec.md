# Branding API Specification

**Capability:** branding-api
**Status:** Proposed
**Version:** 0.3.0

## Overview

Defines the public API for adding BFH branding elements (logos, footers, marks) to ggplot2 visualizations. This specification ensures consistent branding across all package outputs.

## ADDED Requirements

### Requirement: Fixed Logo Placement

The `add_bfh_logo()` function SHALL place the BFH mark logo at a standardized position on all plots.

**Positioning rules:**
- Horizontal: Left edge, 0 offset (flush with plot boundary)
- Vertical: 1/15 of plot height from bottom edge
- Logo height: Exactly 1/15 of total plot height
- Logo width: Calculated from source image aspect ratio to preserve proportions

#### Scenario: Adding logo to basic plot

**Given** a user has a ggplot2 plot object `p`
**When** the user calls `add_bfh_logo(p)`
**Then** the function SHALL return a modified plot with logo overlay
**And** the logo SHALL appear at the bottom-left corner
**And** the logo height SHALL equal 1/15 of the plot height
**And** the logo vertical position SHALL be 1/15 of plot height from the bottom
**And** the logo SHALL be flush against the left edge with 0 horizontal padding
**And** the logo aspect ratio SHALL match the source image (no distortion)

#### Scenario: Logo placement is independent of plot content

**Given** plots with different data ranges and axis scales
**When** `add_bfh_logo()` is called on each plot
**Then** the logo position and size SHALL be identical across all plots
**And** the logo SHALL use NPC (normalized parent coordinates) for consistency

### Requirement: Default Logo Asset

The function SHALL automatically load the BFH mark logo when no custom path is provided.

#### Scenario: Using default logo

**Given** a plot object
**When** `add_bfh_logo(plot)` is called without specifying `logo_path`
**Then** the function SHALL load `inst/logo/bfh_mark.png` via `get_bfh_logo(size = "full", variant = "mark")`
**And** SHALL render this logo at the fixed position
**And** SHALL fail gracefully if the logo file is not found

#### Scenario: Custom logo path

**Given** a user has a custom logo file at `/path/to/custom_logo.png`
**When** `add_bfh_logo(plot, logo_path = "/path/to/custom_logo.png")` is called
**Then** the function SHALL use the custom logo instead of the default
**And** SHALL apply the same fixed positioning rules
**And** SHALL validate the file path according to security requirements

### Requirement: Transparency Control

The function SHALL support alpha transparency adjustment via the `alpha` parameter.

#### Scenario: Fully opaque logo (default)

**Given** a plot
**When** `add_bfh_logo(plot)` is called without specifying `alpha`
**Then** the logo SHALL render at 100% opacity (alpha = 1)

#### Scenario: Semi-transparent logo

**Given** a plot with a busy or colored background
**When** `add_bfh_logo(plot, alpha = 0.7)` is called
**Then** the logo SHALL render at 70% opacity
**And** the background SHALL show through the logo at 30% visibility

#### Scenario: Invalid alpha values

**Given** a plot
**When** `add_bfh_logo(plot, alpha = 1.5)` is called (out of range)
**Then** the function SHALL stop with an error
**And** the error message SHALL indicate valid range is 0-1

### Requirement: Function Signature

The `add_bfh_logo()` function SHALL have the following signature:

```r
add_bfh_logo(plot, logo_path = NULL, alpha = 1)
```

**Parameters:**
- `plot`: ggplot2 object (required)
- `logo_path`: Character string path to PNG/JPEG file, or NULL for default (optional)
- `alpha`: Numeric transparency value 0-1 (optional, default 1)

**Returns:** Modified ggplot2 object with logo applied

#### Scenario: Minimal usage

**Given** a ggplot2 object `p`
**When** `add_bfh_logo(p)` is called
**Then** the function SHALL succeed with all defaults

#### Scenario: Invalid plot object

**Given** an object that is not a ggplot2 plot
**When** `add_bfh_logo(not_a_plot)` is called
**Then** the function SHALL fail with a clear error message

### Requirement: Security Validation

The function SHALL validate logo file paths to prevent security issues.

#### Scenario: Path traversal prevention

**Given** a malicious path like `"../../etc/passwd"`
**When** `add_bfh_logo(plot, logo_path = "../../etc/passwd")` is called
**Then** the function SHALL stop with an error
**And** SHALL NOT access files outside allowed directories

#### Scenario: File type validation

**Given** a file that is not a valid PNG or JPEG
**When** `add_bfh_logo(plot, logo_path = "/path/to/malicious.exe")` is called
**Then** the function SHALL detect the invalid file type via magic bytes
**And** SHALL stop with an error before reading the full file

#### Scenario: Symlink verification

**Given** a path that resolves via symbolic links
**When** `add_bfh_logo(plot, logo_path)` is called
**Then** the function SHALL normalize the path twice
**And** SHALL verify both normalizations match
**And** SHALL reject paths that don't maintain stability

### Requirement: Image Format Support

The function SHALL support PNG and JPEG image formats for logos.

#### Scenario: PNG logo

**Given** a PNG logo file
**When** `add_bfh_logo(plot, logo_path = "logo.png")` is called
**Then** the function SHALL use `png::readPNG()` to load the image
**And** SHALL render correctly

#### Scenario: JPEG logo

**Given** a JPEG logo file
**When** `add_bfh_logo(plot, logo_path = "logo.jpg")` is called
**Then** the function SHALL use `jpeg::readJPEG()` to load the image
**And** SHALL render correctly

#### Scenario: Missing image package

**Given** the `png` package is not installed
**When** `add_bfh_logo(plot, logo_path = "logo.png")` is called
**Then** the function SHALL provide a clear error message
**And** SHALL suggest installing the required package

## MODIFIED Requirements

None - this is a new specification.

## REMOVED Requirements

None - this is a new specification.

## Dependencies

- R package: ggplot2 (for plot objects and annotation_custom)
- R package: grid (for rasterGrob and unit positioning)
- R package: png (for PNG file reading)
- R package: jpeg (for JPEG file reading, optional)
- Internal: `get_bfh_logo()` for default logo resolution
- Internal: `validate_numeric_range()` for parameter validation
- Internal: `validate_choice()` for parameter validation

## Related Specifications

- `visual-identity`: BFH brand guidelines and logo usage rules
- `security`: Package-wide security requirements for file handling
