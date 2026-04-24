# Documentation Sync Specification

**Capability:** documentation-sync

## ADDED Requirements

### Requirement: Documentation References Match Exported API

All user-facing documentation (README, vignettes, `inst/examples/`) SHALL only reference functions present in the package NAMESPACE.

#### Scenario: README example uses exported function

- **GIVEN** a user reads `README.md`
- **WHEN** the user copies a code example
- **THEN** every function name in the example SHALL exist in the package NAMESPACE
- **AND** every parameter name SHALL match the current function signature

#### Scenario: Vignette compiles in CI

- **GIVEN** the package is built via `R CMD build`
- **WHEN** vignettes are evaluated
- **THEN** all chunks marked `eval = TRUE` SHALL run without error
- **AND** chunks SHALL only call exported functions

#### Scenario: Removed v0.3.0 functions are not referenced

- **GIVEN** the v0.3.0 release removed `add_logo()`, `add_watermark()`, `add_bfh_color_bar()`, `theme_bfh_print()`, `theme_bfh_minimal()`
- **WHEN** documentation is audited
- **THEN** none of these function names SHALL appear in any documentation file
- **AND** removed parameters (`position`, `size`, `padding`) SHALL NOT appear in `add_bfh_logo()` examples

### Requirement: Color References Use Existing Palette Names

All documentation SHALL only reference color names defined in the `bfh_colors` list.

#### Scenario: Color name in example exists

- **GIVEN** a documentation example calls `bfh_cols("name")`
- **WHEN** the example is evaluated
- **THEN** "name" SHALL be a valid key in `bfh_colors`

#### Scenario: hospital_grey is not referenced

- **GIVEN** the codebase defines `regionh_grey` and `dark_grey` (no `hospital_grey`)
- **WHEN** any documentation file is read
- **THEN** the string "hospital_grey" SHALL NOT appear in any code chunk

### Requirement: Example Files are Syntactically Valid

All `.R` files in `inst/examples/` SHALL parse without errors.

#### Scenario: Examples parse cleanly

- **GIVEN** a CI smoke test enumerates `inst/examples/*.R`
- **WHEN** each file is passed to `parse(file = ...)`
- **THEN** parsing SHALL succeed for every file
- **AND** any file that does not parse SHALL fail the test
