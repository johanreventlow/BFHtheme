# Branding API Specification

**Capability:** branding-api

## MODIFIED Requirements

### Requirement: add_bfh_logo() Contract Honesty

The `add_bfh_logo()` function SHALL only declare and validate parameters that affect output, and SHALL only require dependencies it actually calls.

#### Scenario: alpha parameter affects rendering (if retained)

- **GIVEN** the function exposes an `alpha` parameter
- **WHEN** `add_bfh_logo(p, alpha = 0.3)` is called
- **THEN** the rendered logo SHALL appear at 30% opacity in the output
- **AND** the difference between `alpha = 1` and `alpha = 0.3` SHALL be visible in a snapshot test

#### Scenario: alpha parameter removed if not implemented

- **GIVEN** the implementation chooses not to apply `alpha`
- **WHEN** the user inspects `formals(add_bfh_logo)`
- **THEN** `alpha` SHALL NOT appear in the formals
- **AND** documentation SHALL NOT mention transparency control

#### Scenario: Missing required dependency fails hard

- **GIVEN** the user has not installed `cowplot`
- **WHEN** `add_bfh_logo(p)` is called
- **THEN** the function SHALL stop with a clear "install cowplot" hint
- **AND** the function SHALL NOT silently return the plot without a logo

#### Scenario: patchwork is not declared as a dependency

- **GIVEN** the implementation does not call any `patchwork::` function
- **WHEN** `add_bfh_logo()` source is inspected
- **THEN** `requireNamespace("patchwork")` SHALL NOT appear in the function body
- **AND** `patchwork` SHALL NOT be listed in DESCRIPTION Suggests for this purpose

## ADDED Requirements

### Requirement: Logo Image Caching

Repeated calls to `add_bfh_logo()` with the same logo path and unchanged file SHALL reuse the in-memory decoded image.

#### Scenario: Repeated calls hit cache

- **GIVEN** the user calls `add_bfh_logo(p, logo_path = path)` twice in succession
- **WHEN** the second call executes
- **THEN** `png::readPNG()` (or `jpeg::readJPEG()`) SHALL NOT be invoked again
- **AND** the cached decoded image array SHALL be returned

#### Scenario: Cache invalidates on file change

- **GIVEN** the logo file at `path` is modified after the first call (mtime changes)
- **WHEN** `add_bfh_logo()` is called again with the same path
- **THEN** the file SHALL be re-read
- **AND** the cache entry SHALL be replaced with the new decoded image

#### Scenario: Cache is per-process

- **GIVEN** the cache lives in the package's internal environment
- **WHEN** the R session restarts
- **THEN** the cache SHALL be empty
- **AND** the first call after restart SHALL re-read the file

### Requirement: Logo Input Resource Limits

The function SHALL reject logo inputs exceeding configurable size limits to mitigate decompression-bomb and memory-exhaustion risks.

#### Scenario: Oversized file rejected pre-decode

- **GIVEN** the user passes a logo file larger than `getOption("BFHtheme.logo_max_bytes", 5 * 1024^2)`
- **WHEN** `add_bfh_logo()` is called
- **THEN** the function SHALL stop with an "exceeds size limit" error
- **AND** the file SHALL NOT be decoded into memory

#### Scenario: Excessive dimensions rejected post-decode

- **GIVEN** a decoded logo image exceeds `getOption("BFHtheme.logo_max_dim", 4096)` pixels on either axis
- **WHEN** `add_bfh_logo()` processes the image
- **THEN** the function SHALL stop with a dimension-limit error before drawing

#### Scenario: Limits are user-configurable

- **GIVEN** the user sets `options(BFHtheme.logo_max_bytes = 10 * 1024^2)` for an exceptional case
- **WHEN** `add_bfh_logo()` is called with a 7 MB file
- **THEN** the function SHALL accept the file
- **AND** processing SHALL proceed normally
