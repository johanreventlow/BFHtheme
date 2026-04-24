# Global State Management Specification

**Capability:** global-state-management

## ADDED Requirements

### Requirement: Package Load Does Not Mutate User Session

Loading or attaching the package SHALL NOT modify any global session state outside the package's own internal environment (`.bfh_state`, `.bfh_font_cache`, `.bfh_logo_cache`).

#### Scenario: knitr options unchanged on load

- **GIVEN** the user has set `knitr::opts_chunk$set(dev = "png")`
- **WHEN** the user runs `library(BFHtheme)`
- **THEN** `knitr::opts_chunk$get("dev")` SHALL still return `"png"`
- **AND** no chunk options SHALL have been silently overridden

#### Scenario: ggplot2 theme unchanged on load

- **GIVEN** the user has called `ggplot2::theme_set(theme_classic())`
- **WHEN** the user runs `library(BFHtheme)`
- **THEN** `ggplot2::theme_get()` SHALL still return `theme_classic()`

#### Scenario: Opt-in knitr configuration is explicit

- **GIVEN** the user wants ragg-based rendering for knitr chunks
- **WHEN** the user calls `use_bfh_knitr_defaults()`
- **THEN** `knitr::opts_chunk$get("dev")` SHALL return `"ragg_png"`
- **AND** the user has explicitly chosen this behavior

### Requirement: Reversible Global Defaults

`set_bfh_defaults()` SHALL save previous global state before mutation, and `reset_bfh_defaults()` SHALL restore exactly that state.

#### Scenario: Round-trip restores theme

- **GIVEN** the user has set a custom theme via `ggplot2::theme_set(theme_classic())`
- **WHEN** the user calls `set_bfh_defaults()` then `reset_bfh_defaults()`
- **THEN** the active theme SHALL equal `theme_classic()` after reset
- **AND** the active theme SHALL NOT equal `theme_gray()`

#### Scenario: Round-trip restores geom defaults

- **GIVEN** the user has set `update_geom_defaults("point", list(colour = "red"))`
- **WHEN** the user calls `set_bfh_defaults()` then `reset_bfh_defaults()`
- **THEN** the default colour for `geom_point()` SHALL be "red"

#### Scenario: Reset without prior set falls back gracefully

- **GIVEN** the user has not called `set_bfh_defaults()` in the current session
- **WHEN** the user calls `reset_bfh_defaults()`
- **THEN** the function SHALL fall back to `theme_gray()` and ggplot2's hardcoded geom defaults
- **AND** the function SHALL emit a `message()` indicating no saved state was found

### Requirement: Documentation Reflects Actual Guarantees

Documentation for security- and isolation-related options SHALL describe the actual mechanism, not aspirational language.

#### Scenario: BFHtheme.logo_root described accurately

- **GIVEN** the user reads `?add_bfh_logo`
- **WHEN** they read about `BFHtheme.logo_root`
- **THEN** the text SHALL describe it as a "convenience restriction" or "directory whitelist"
- **AND** the text SHALL NOT describe it as a "sandbox" or imply isolation guarantees beyond path prefix matching
