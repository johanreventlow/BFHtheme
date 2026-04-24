# Package Hygiene Specification

**Capability:** package-hygiene

## ADDED Requirements

### Requirement: Test Isolation From User Filesystem

Test code SHALL NOT write to or under the user's home directory.

#### Scenario: No writes to home directory

- **GIVEN** the test suite runs in any environment
- **WHEN** any test creates a temporary file
- **THEN** the file path SHALL be under `tempdir()` or a subdirectory created by `withr::local_tempdir()`
- **AND** the file path SHALL NOT contain `~` or `path.expand("~")` as a write target

#### Scenario: Path traversal tests use synthetic inputs

- **GIVEN** a test verifies `add_bfh_logo()` rejects `~`-prefixed paths
- **WHEN** the test runs
- **THEN** the test SHALL pass a `~`-prefixed string as INPUT
- **AND** the test SHALL NOT actually create a file under the user's home directory

#### Scenario: Tests clean up after themselves

- **GIVEN** a test mutates global state (options, theme, env vars, ggplot2 defaults)
- **WHEN** the test completes (pass or fail)
- **THEN** the previous state SHALL be restored via `withr::defer()` or equivalent

### Requirement: Source Tarball Hygiene

The package source tarball SHALL NOT include build artifacts, IDE config, or transient test outputs.

#### Scenario: Rplots.pdf excluded from build

- **GIVEN** running `R CMD build .`
- **WHEN** the resulting tarball is inspected
- **THEN** `Rplots.pdf` SHALL NOT be present at any path
- **AND** `Rplots.pdf` SHALL be listed in both `.gitignore` and `.Rbuildignore`

#### Scenario: Rplots.pdf not committed

- **GIVEN** the repository working tree
- **WHEN** `git ls-files | grep Rplots.pdf` is run
- **THEN** the result SHALL be empty

### Requirement: Public Function Input Validation

All exported functions SHALL validate numeric and structural inputs at entry, producing clear error messages instead of late or cryptic failures.

#### Scenario: theme_bfh rejects invalid base_size

- **GIVEN** the user calls `theme_bfh(base_size = -1)` or `theme_bfh(base_size = NULL)` or `theme_bfh(base_size = 0)`
- **WHEN** the function executes
- **THEN** the function SHALL stop with a "base_size must be positive numeric" error
- **AND** the failure SHALL occur before any theme construction

#### Scenario: theme_bfh accepts valid base_size

- **GIVEN** the user calls `theme_bfh(base_size = 14)`
- **WHEN** the function executes
- **THEN** the function SHALL return a valid `theme` object
- **AND** no error SHALL be raised

#### Scenario: bfh_save rejects invalid dimensions

- **GIVEN** the user calls `bfh_save("x.png", width = -1)` or `bfh_save("x.png", height = 0)` or `bfh_save("x.png", dpi = -300)`
- **WHEN** the function executes
- **THEN** the function SHALL stop with a clear "must be positive" error
- **AND** the failure SHALL occur before any rendering attempt

#### Scenario: add_bfh_footer rejects invalid height

- **GIVEN** the user calls `add_bfh_footer(p, height = -1)` or `add_bfh_footer(p, height = 2)`
- **WHEN** the function executes
- **THEN** the function SHALL stop with a "height must be in (0, 1]" error

### Requirement: Visual Regression Workflow Is Documented

The contribution guide SHALL document the procedure for managing visual regression snapshots.

#### Scenario: Contributor finds snapshot acceptance procedure

- **GIVEN** a contributor runs the test suite and sees a vdiffr snapshot diff
- **WHEN** they consult `CONTRIBUTING.md`
- **THEN** they SHALL find instructions for inspecting the diff
- **AND** they SHALL find instructions for accepting (`vdiffr::manage_cases()`) or rejecting the change
