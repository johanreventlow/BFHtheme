# Project Context

## Purpose

BFHtheme is a ggplot2 theming and branding package for Bispebjerg og Frederiksberg Hospital and Region Hovedstaden. The package provides:

- **Beautiful defaults** - Publication-ready ggplot2 themes with professional typography and spacing
- **Multi-organizational branding** - Support for both BFH and Region H visual identities
- **Composable API** - Themes, colors, scales, and branding elements that work together seamlessly
- **Production-ready** - Used by downstream packages (BFHcharts, SPCify) for SPC analysis and reporting

## Tech Stack

**Core Dependencies:**
- **ggplot2** - Theme framework and visualization engine
- **marquee** - Advanced text rendering with markdown support
- **grid/grDevices** - Logo placement and low-level graphics
- **systemfonts** - Cross-platform font detection with session caching
- **extrafont** - Fallback font loading mechanism

**Development Tools:**
- **devtools** - Package development workflow
- **testthat** - Testing framework (323 tests, 89.74% coverage)
- **styler** - Code formatting
- **lintr** - Static code analysis
- **covr** - Code coverage reporting

## Project Conventions

### Code Style

**Naming Conventions:**
- **Function names:** snake_case in English (e.g., `theme_bfh()`, not `tema_bfh()`)
- **Internal functions:** Prefix with dot (e.g., `.detect_font()`)
- **Variables:** snake_case (e.g., `base_family`, `cache_key`)
- **Constants:** SCREAMING_SNAKE_CASE (e.g., `.bfh_font_cache`)

**Code Organization:**
- **One concept per file:** `themes.R`, `colors.R`, `scales.R`, `fonts.R`, `branding.R`
- **Roxygen documentation:** All exported functions must have complete @param, @return, @examples
- **Internal utilities:** Separate file (`utils_operators.R` for `%||%`)
- **Package docs:** `BFHtheme-package.R` for package-level documentation

**Formatting:**
- Use `styler::style_pkg()` for consistent formatting
- Maximum line length: 80 characters (standard R)
- Indentation: 2 spaces (no tabs)
- Trailing commas in function calls spanning multiple lines

**Language Policy:**
- **Function names & docs:** English (standard for R packages)
- **Internal comments:** Danish (developer convenience)
- **Error messages:** English (user-facing, international standard)

**Common Patterns:**
```r
# NULL coalescing
base_family <- base_family %||% get_bfh_font()

# Input validation at function start
validate_palette(palette)
validate_size(size)

# Session-level caching for expensive operations
if (exists(cache_key, envir = .cache, inherits = FALSE)) {
  return(get(cache_key, envir = .cache))
}
```

### Architecture Patterns

**Layered API Design:**
```
User-facing API
├── Themes (theme_bfh, theme_bfh_minimal, theme_bfh_dark, theme_region_h)
├── Colors (bfh_cols, bfh_pal)
├── Scales (scale_color_bfh, scale_fill_bfh)
├── Branding (add_bfh_logo, add_bfh_footer, bfh_title_block)
└── Helpers (bfh_save, bfh_combine, bfh_labs)
```

**Session-Level Caching:**
```r
# Package-level environment for caching
.bfh_font_cache <- new.env(parent = emptyenv())

# 10-15x speedup for repeated font detection
get_bfh_font <- function(fonts, check_installed, silent) {
  cache_key <- paste0(fonts, check_installed, collapse = "_")

  if (exists(cache_key, envir = .bfh_font_cache, inherits = FALSE)) {
    return(get(cache_key, envir = .bfh_font_cache))
  }

  # Expensive operation only on cache miss
  selected_font <- .detect_font(fonts, check_installed, silent)
  assign(cache_key, selected_font, envir = .bfh_font_cache)
  selected_font
}
```

**Composability Pattern:**
```r
# Components work together seamlessly
ggplot(data, aes(x, y)) +
  geom_point() +
  theme_bfh() +                    # Base theme
  scale_color_bfh(palette = "main") +  # Color scale
  labs(title = "Title") %>%         # Labels
  add_bfh_logo(get_bfh_logo())      # Branding
```

**Graceful Degradation:**
- Font detection falls back: Mari → Roboto → Arial → sans
- Logo paths resolve multiple variants (color/grey, small/web)
- Silent failures with warnings (not errors) for non-critical operations

**Input Validation:**
All user-facing functions validate inputs early:
```r
theme_bfh <- function(base_size = 12, base_family = NULL, ...) {
  # Validate numeric parameters
  if (!is.numeric(base_size) || base_size <= 0) {
    stop("base_size must be a positive number", call. = FALSE)
  }

  # Validate optional parameters
  if (!is.null(base_family) && !is.character(base_family)) {
    stop("base_family must be a character string or NULL", call. = FALSE)
  }

  # ... implementation
}
```

### Testing Strategy

**Coverage Goals:**
- **≥90% overall coverage** (current: 89.74%)
- **100% on all exported functions**
- **Edge cases required:** NULL inputs, empty data, invalid types, path traversal
- **Integration tests:** Full workflows (theme → plot → save → branding)

**Test Organization:**
```
tests/testthat/
├── test-themes.R          # Theme function tests
├── test-colors.R          # Color palette tests
├── test-scales.R          # ggplot2 scale tests
├── test-fonts.R           # Font detection & caching
├── test-branding.R        # Logo and footer tests
├── test-logo_helpers.R    # Logo path resolution
├── test-helpers.R         # Save, combine, labs
└── test-utils.R           # Internal utilities
```

**Test Patterns:**

1. **Unit Tests:**
```r
test_that("bfh_cols returns all colors when no arguments provided", {
  result <- bfh_cols()

  expect_type(result, "character")
  expect_length(result, 28)
  expect_true(all(grepl("^#[0-9a-fA-F]{6}$", result)))
})
```

2. **Security Tests:**
```r
test_that("add_bfh_logo blocks path traversal attempts", {
  skip_if_not_installed("ggplot2")

  p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()

  expect_error(add_bfh_logo(p, "../../../etc/passwd"))
  expect_error(add_bfh_logo(p, "~/logo.png"))
  expect_error(add_bfh_logo(p, "..\\..\\Windows\\System32\\config\\SAM"))
})
```

3. **Integration Tests:**
```r
test_that("full workflow theme + scales + branding works", {
  skip_if_not_installed("ggplot2")

  p <- ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
    geom_point() +
    theme_bfh() +
    scale_color_bfh(palette = "main")

  expect_s3_class(p, "ggplot")
  expect_no_error(print(p))
})
```

**Known Coverage Gaps (Priority):**
1. `R/fonts.R` (72.90%) - extrafont fallback path untested
2. `R/logo_helpers.R` (77.42%) - grey/mark logo variants untested
3. `R/branding.R` (86.36%) - JPEG support untested

**Visual Regression Tests (TODO):**
- Currently missing vdiffr tests for theme consistency
- Planned for all theme variants (bfh, minimal, dark, region_h)

**Test Commands:**
```r
devtools::test()                    # Run all tests (323 tests)
devtools::test_coverage()           # Check coverage
testthat::test_file("tests/testthat/test-colors.R")  # Single file
```

### Git Workflow

**Branching Strategy:**
- **main** - Production-ready code, protected branch
- **Feature branches** - `feature/description` or `docs/description`
- **Bugfix branches** - `fix/description`
- **OpenSpec branches** - Created automatically by `/openspec:proposal`

**Branch Protection:**
- ❌ **NEVER commit directly to main/master**
- ❌ **NEVER merge to main without explicit approval**
- ❌ **NEVER push to remote without request**
- ❌ **NEVER use `--force` on shared branches**

**Commit Message Format:**
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat` - New feature or enhancement
- `fix` - Bug fix
- `docs` - Documentation changes
- `test` - Test additions or updates
- `refactor` - Code refactoring (no behavior change)
- `style` - Code formatting (no logic change)
- `perf` - Performance improvements
- `chore` - Maintenance tasks

**Examples:**
```
feat(themes): add dark mode variant with inverted colors
fix(fonts): correct cache key collision for different font sets
docs(vignettes): add branding workflow examples
test(logos): add path traversal security tests
```

**Pre-commit Checklist:**
- [ ] `devtools::document()` - Update docs and NAMESPACE
- [ ] `devtools::test()` - All tests pass
- [ ] `styler::style_pkg()` - Code formatted
- [ ] `lintr::lint_package()` - No linting errors
- [ ] `devtools::check()` - Package check passes (for releases)

**Pull Request Workflow:**
1. Create feature branch from main
2. Implement changes with tests
3. Run pre-commit checklist
4. Push branch to remote
5. Create PR with description
6. Address review feedback
7. Merge after approval (squash or merge commit)

**OpenSpec Integration:**
- OpenSpec changes tracked via GitHub issues
- Issue created automatically by `/openspec:proposal`
- Labels updated automatically: `openspec-proposal` → `openspec-implementing` → `openspec-deployed`
- Reference issue in commits: `fixes #142`, `relates to #142`

## Domain Context

**Healthcare Data Visualization:**
This package supports statistical process control (SPC) charts and clinical quality reporting at Bispebjerg og Frederiksberg Hospital and Region Hovedstaden. Users include:

- **Quality coordinators** - Track hospital performance metrics
- **Clinical researchers** - Publish academic papers
- **Hospital management** - Present to stakeholders
- **Data analysts** - Generate automated reports

**Multi-Organizational Branding:**

1. **BFH (Bispebjerg og Frederiksberg Hospital)**
   - Primary color: Hospital Blue (#007dbb)
   - Fonts: Mari (preferred), Roboto (fallback), Arial
   - Logo variants: color, greyscale, mark-only
   - Sizes: small (presentations), web (reports)

2. **Region Hovedstaden**
   - Primary color: Region Blue (#009ce8)
   - Shares font preferences with BFH
   - Separate logo assets
   - Similar branding patterns

**ggplot2 Ecosystem Integration:**

The package extends ggplot2 with:
- **Custom themes** - Complete theme() objects
- **Color scales** - scale_color_discrete/continuous
- **Branding layers** - Post-processing with grid graphics
- **Helper functions** - Wrapper around ggsave, patchwork, labs

**Design Philosophy:**
- **Beautiful by default** - Sensible defaults require no configuration
- **Composable** - Every function works with ggplot2's `+` operator
- **Non-breaking** - Extends ggplot2 without replacing behavior
- **Accessible** - Colorblind-safe palettes (future enhancement)

**Downstream Integration:**

BFHtheme is a foundational package for:
- **BFHcharts** - SPC chart rendering (control charts, run charts)
- **SPCify** - Shiny application for interactive SPC analysis

Changes to BFHtheme API must consider backward compatibility with these packages.

## Important Constraints

**Technical Constraints:**

1. **Exported Function Signatures** - Breaking changes require major version bump (semver)
   - Cannot change parameter names, defaults, or order
   - Must deprecate old signatures in minor version first
   - Provide migration guide for breaking changes

2. **NAMESPACE Management** - Auto-generated by roxygen2
   - ❌ **NEVER manually edit NAMESPACE file**
   - Use `@export` tags in roxygen comments
   - Run `devtools::document()` to regenerate

3. **R Version Compatibility**
   - Must support R ≥ 4.1.0 (current LTS)
   - Avoid using newest R features without compatibility checks
   - Test on multiple R versions before release

4. **ggplot2 API Stability**
   - Must work with ggplot2 ≥ 3.4.0
   - Avoid relying on internal ggplot2 functions
   - Use documented extension points only

**Business Constraints:**

1. **Brand Identity** - Official hospital colors
   - ❌ **NEVER modify color hex values without approval**
   - Color changes require sign-off from communications department
   - Document color rationale in commits

2. **Logo Assets** - Proprietary brand materials
   - ❌ **NEVER modify logo files directly**
   - Coordinate with communications for logo updates
   - Maintain color/greyscale/mark variants
   - Respect logo usage guidelines

3. **Backward Compatibility** - Downstream packages depend on stable API
   - BFHcharts and SPCify require advance notice for breaking changes
   - Maintain deprecated functions for at least one major version
   - Coordinate releases with downstream maintainers

**Security Constraints:**

1. **Path Traversal Protection** - File operations must validate paths
   ```r
   # Block dangerous patterns
   if (grepl("\\.\\.", path) || grepl("^~", path)) {
     stop("Path traversal patterns not allowed", call. = FALSE)
   }
   ```

2. **Input Validation** - All user inputs must be validated
   - Check types, ranges, and formats
   - Fail early with clear error messages
   - Use `call. = FALSE` for user-facing errors

3. **Dependency Management** - Minimize attack surface
   - Only essential dependencies in DESCRIPTION
   - Prefer base R over external packages when possible
   - Keep dependencies updated for security patches

**Regulatory Constraints:**

1. **Data Privacy** - No patient data in package
   - Example data must be synthetic or public
   - No screenshots or plots with real patient information
   - Sanitize all test fixtures

2. **License Compliance** - GPL-3 license
   - All contributions must be GPL-compatible
   - Credit third-party code in LICENSE
   - Document data source licenses

**Performance Constraints:**

1. **Load Time** - Package must load quickly
   - Font detection cached at session level
   - Lazy evaluation for expensive operations
   - No computation at package load time

2. **Memory Usage** - Efficient for large reports
   - No global state modifications
   - Clean up temporary objects
   - Use copy-on-modify semantics

## External Dependencies

**R Package Dependencies:**

**Required (Imports):**
- **ggplot2** (≥ 3.4.0) - Core theming and plotting engine
- **marquee** - Advanced text rendering with markdown support in plot titles
- **grid** - Low-level graphics for logo placement
- **grDevices** - Graphics device management for image loading
- **systemfonts** - Cross-platform font detection and enumeration

**Optional (Suggests):**
- **extrafont** - Fallback font loading mechanism (when systemfonts insufficient)
- **ragg** - High-quality graphics device for better rendering
- **svglite** - SVG export with embedded fonts
- **patchwork** - Multi-plot composition (used in `bfh_combine()`)
- **testthat** - Testing framework
- **vdiffr** - Visual regression testing (planned, not yet implemented)
- **covr** - Code coverage reporting

**System Dependencies:**

1. **Fonts:**
   - **Mari** (preferred) - BFH brand font, must be installed system-wide
   - **Roboto** (fallback) - Google font, widely available
   - **Arial** (fallback) - System font on most platforms
   - Package gracefully degrades to "sans" if none available

2. **Graphics Libraries:**
   - **libpng** - PNG logo loading (via grDevices)
   - **libjpeg** - JPEG support (optional, for logo variants)
   - **cairo** - Font rendering on Linux

**Downstream Dependencies (Reverse):**

Packages that depend on BFHtheme:
- **BFHcharts** - SPC chart visualization
- **SPCify** - Shiny application for SPC analysis

**External Services:**

None. BFHtheme is completely self-contained and does not make network requests or connect to external services.

**Version Pinning Philosophy:**

- **Minimum versions** specified for critical dependencies (ggplot2 ≥ 3.4.0)
- **No maximum versions** - Follow semantic versioning trust
- **Regular updates** - Review dependency updates quarterly
- **Security patches** - Update immediately for CVEs

**Dependency Graph:**
```
BFHtheme
├── ggplot2 (≥ 3.4.0) [CRITICAL]
│   ├── scales
│   ├── gtable
│   └── rlang
├── marquee [CRITICAL]
├── systemfonts [CRITICAL]
├── grid (base R)
├── grDevices (base R)
└── extrafont [OPTIONAL]
```

**Dependency Management Commands:**
```r
# Check dependency versions
tools::package_dependencies("BFHtheme", which = "all")

# Update dependencies
update.packages(ask = FALSE)

# Check for outdated dependencies
old.packages()

# Audit for vulnerabilities (manual process)
# Review security advisories for ggplot2, systemfonts
```

## GitHub Integration

### OpenSpec + GitHub Issues

This project uses a **complementary approach** where OpenSpec changes are tracked via both `tasks.md` files (source of truth for implementation details) and GitHub issues (high-level tracking and visibility).

**Rationale:**
- Preserves OpenSpec workflow (offline-first, structured validation)
- Gains GitHub visibility (project boards, search, notifications, cross-references)
- Enables automation via slash commands

### Label System

**OpenSpec-specific labels:**
- `openspec-proposal` - Change in proposal phase (yellow)
- `openspec-implementing` - Change being implemented (blue)
- `openspec-deployed` - Change archived/deployed (green)

**Type labels (existing):**
- `enhancement`, `bug`, `documentation`, `technical-debt`, `performance`, `testing`

### Automated Workflow

**Stage 1: Proposal** (`/openspec:proposal`)
```bash
# Automatically creates GitHub issue with:
gh issue create --title "[OpenSpec] add-feature" \
  --body "$(cat openspec/changes/add-feature/proposal.md)" \
  --label "openspec-proposal,enhancement"

# Issue reference added to proposal.md:
## Related
- GitHub Issue: #142
```

**Stage 2: Implementation** (`/openspec:apply`)
```bash
# Updates issue label and adds comment:
gh issue edit 142 --add-label "openspec-implementing" --remove-label "openspec-proposal"
gh issue comment 142 --body "Implementation started"
```

**Stage 3: Archive** (`/openspec:archive`)
```bash
# Updates label, closes issue with timestamp:
gh issue edit 142 --add-label "openspec-deployed" --remove-label "openspec-implementing"
gh issue close 142 --comment "Deployed via openspec archive on $(date +%Y-%m-%d)"
```

### Linking Pattern

**In proposal.md:**
```markdown
## Why
[Problem description]

## What Changes
- [Change list]

## Impact
- Affected specs: [capabilities]
- Affected code: [files]

## Related
- GitHub Issue: #142
```

**In tasks.md:**
```markdown
## 1. Implementation
- [ ] 1.1 Create schema (see #142)
- [ ] 1.2 Write tests (see #142)
- [ ] 1.3 Deploy (see #142)

Tracking: GitHub Issue #142
```

### Manual Operations

If automatic GitHub integration fails or needs manual intervention:

```bash
# Create issue manually
gh issue create --title "[OpenSpec] add-feature" \
  --body "$(cat openspec/changes/add-feature/proposal.md)" \
  --label "openspec-proposal,enhancement"

# Update labels manually during implementation
gh issue edit 142 --add-label "openspec-implementing" --remove-label "openspec-proposal"

# Close manually after deployment
gh issue close 142 --comment "Deployed via openspec archive on 2025-11-02"
```

### Best Practices

**Do:**
- ✅ Create GitHub issue for every OpenSpec change (automatic via `/openspec:proposal`)
- ✅ Reference issue in commit messages (`fixes #142`, `relates to #142`)
- ✅ Keep tasks.md as source of truth for implementation details
- ✅ Use GitHub issue for discussions and stakeholder visibility
- ✅ Update issue labels as workflow progresses (automatic via slash commands)

**Don't:**
- ❌ Skip GitHub issue creation
- ❌ Update tasks.md via GitHub (tasks.md is authoritative, sync is one-way)
- ❌ Close issues before archiving change (use `/openspec:archive` workflow)
- ❌ Use GitHub issues for implementation checklists (that's tasks.md's role)
