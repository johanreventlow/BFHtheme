## MODIFIED Requirements

### Requirement: Default Logo Asset

The function SHALL automatically load the mark logo of the active brand (see `get_bfh_brand()`) when no custom path is provided.

#### Scenario: Using default logo

**Given** a plot object
**And** the active brand is `"regionh"`
**When** `add_bfh_logo(plot)` is called without specifying `logo_path`
**Then** the function SHALL load `inst/logo/bfh_mark.png` via `get_bfh_logo(size = "full", variant = "mark")`
**And** SHALL render this logo at the fixed position
**And** SHALL fail gracefully if the logo file is not found

#### Scenario: Using default logo under Region Østdanmark

**Given** a plot object
**And** the active brand is `"regionoest"`
**When** `add_bfh_logo(plot)` is called without specifying `logo_path`
**Then** the function SHALL load `inst/logo/roe_mark.png` via `get_bfh_logo(size = "full", variant = "mark")`
**And** SHALL render this logo at the fixed position
**And** SHALL fail gracefully if the logo file is not found

#### Scenario: Explicit brand in get_bfh_logo

**Given** the active brand is `"regionh"`
**When** `get_bfh_logo(variant = "mark", brand = "regionoest")` is called
**Then** the function SHALL return the path to the Region Østdanmark mark logo

#### Scenario: Custom logo path

**Given** a user has a custom logo file at `/path/to/custom_logo.png`
**When** `add_bfh_logo(plot, logo_path = "/path/to/custom_logo.png")` is called
**Then** the function SHALL use the custom logo instead of the default
**And** SHALL apply the same fixed positioning rules
**And** SHALL validate the file path according to security requirements
