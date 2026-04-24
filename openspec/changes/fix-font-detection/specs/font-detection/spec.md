# Font Detection Specification

**Capability:** font-detection

## ADDED Requirements

### Requirement: Accurate Font Availability Detection

The package SHALL determine whether a font is installed by exact match against the system font family list, NOT by interpreting `systemfonts::match_fonts()` return values whose `path` field includes fallback substitutions.

#### Scenario: Detecting a non-installed font

- **GIVEN** the user does not have "Mari" installed on the system
- **WHEN** `get_bfh_font()` is called with default arguments
- **THEN** the function SHALL NOT return "Mari"
- **AND** the function SHALL fall through to the next available font in the priority list
- **AND** the function SHALL return "sans" if no priority font is installed

#### Scenario: Detecting an installed font

- **GIVEN** the user has "Roboto" installed and not "Mari"
- **WHEN** `get_bfh_font()` is called with default arguments
- **THEN** the function SHALL return "Roboto"

#### Scenario: match_fonts fallback does not produce false positive

- **GIVEN** `systemfonts::match_fonts("Mari")` returns a path to `Helvetica.ttc` because Mari is not installed
- **WHEN** the package probes for Mari availability
- **THEN** the probe SHALL return FALSE
- **AND** Mari SHALL NOT be selected as the active font

### Requirement: systemfonts as a Hard Dependency

The package SHALL declare `systemfonts` as an Imports-level dependency because correct behavior depends on it.

#### Scenario: systemfonts in Imports

- **GIVEN** the package is built and installed
- **WHEN** the user inspects DESCRIPTION
- **THEN** `systemfonts` SHALL appear in the Imports field
- **AND** `systemfonts` SHALL NOT appear in the Suggests field

### Requirement: Consistent Font Probe Across Code Paths

All package code paths that probe font availability SHALL use the same detection mechanism.

#### Scenario: Windows font registration uses correct probe

- **GIVEN** the package is loaded on Windows
- **WHEN** `.onLoad()` registers fonts via `windowsFonts()`
- **THEN** registration SHALL only occur for fonts that pass the exact-match availability check

#### Scenario: Startup Mari probe uses correct probe

- **GIVEN** the package is attached on a system without Mari installed
- **WHEN** `.onAttach()` evaluates the Mari availability message
- **THEN** the "Mari font not detected" message SHALL be emitted
- **AND** the message SHALL NOT be suppressed by a fallback Helvetica path

#### Scenario: check_bfh_fonts diagnostic accuracy

- **GIVEN** the user runs `BFHtheme:::check_bfh_fonts()`
- **WHEN** Mari is not installed but `match_fonts("Mari")` returns a fallback path
- **THEN** the diagnostic SHALL report Mari as "Not found"
- **AND** the diagnostic SHALL NOT report a false "Available" status
