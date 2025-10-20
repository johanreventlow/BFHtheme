# Contributing to BFHtheme

Thank you for your interest in contributing to BFHtheme! This guide will help you get started with development, testing, and submitting contributions.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Development Workflow](#development-workflow)
3. [Code Style Guidelines](#code-style-guidelines)
4. [Testing](#testing)
5. [Documentation](#documentation)
6. [Commit Guidelines](#commit-guidelines)
7. [Pull Request Process](#pull-request-process)
8. [Review Checklist](#review-checklist)

---

## Getting Started

### Prerequisites

- R (>= 4.0.0)
- RStudio (recommended)
- Git

### Setup Development Environment

1. **Clone the repository:**

```bash
git clone https://github.com/johanreventlow/BFHtheme.git
cd BFHtheme
```

2. **Install development dependencies:**

```r
# Install devtools if not already installed
install.packages("devtools")

# Install all package dependencies
devtools::install_dev_deps()

# Install suggested packages for full functionality
install.packages(c("testthat", "covr", "lintr", "styler", "roxygen2"))
```

3. **Load the package for development:**

```r
devtools::load_all()
```

4. **Verify installation:**

```r
# Run all tests
devtools::test()

# Check package
devtools::check()
```

---

## Development Workflow

BFHtheme follows **Test-Driven Development (TDD)** principles:

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

**Branch naming conventions:**
- `feature/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation changes
- `test/` - Test additions or modifications

### 2. Write Tests First

Before implementing any feature or fix:

```r
# Create or modify test file in tests/testthat/
# Example: tests/testthat/test-your-feature.R

test_that("your feature works correctly", {
  result <- your_function(input)
  expect_equal(result, expected_output)
})
```

### 3. Implement the Feature

Write minimal code to make tests pass:

```r
# In R/your-file.R
your_function <- function(input) {
  # Implementation
}
```

### 4. Run Tests Continuously

```r
# Run all tests
devtools::test()

# Run specific test file
testthat::test_file("tests/testthat/test-your-feature.R")

# Check entire package
devtools::check()
```

### 5. Document Your Code

Update roxygen comments and regenerate documentation:

```r
devtools::document()
```

### 6. Code Quality Checks

```r
# Format code
styler::style_pkg()

# Lint code
lintr::lint_package()

# Check code coverage
covr::package_coverage()
```

---

## Code Style Guidelines

### Naming Conventions

- **Functions**: `snake_case`
- **Arguments**: `snake_case`
- **Objects/Variables**: `snake_case`
- **Internal functions**: Prefix with `.` (e.g., `.resolve_base_family`)

```r
# ✅ Good
theme_bfh <- function(base_size = 12, base_family = NULL) { }

# ❌ Bad
themeBFH <- function(baseSize = 12, baseFamily = NULL) { }
```

### Comments

- **Danish comments** for internal documentation
- **English** for exported function documentation (roxygen2)

```r
# Danske kommentarer for intern logik
.resolve_base_family <- function(base_family) {
  base_family %||% get_bfh_font(check_installed = TRUE, silent = TRUE)
}

#' BFH Theme for ggplot2
#'
#' English documentation for exported functions
#' @export
theme_bfh <- function() { }
```

### Defensive Programming

Always validate inputs for exported functions:

```r
theme_bfh <- function(base_size = 12, base_family = NULL, ...) {
  # Input validation
  if (!is.numeric(base_size) || base_size <= 0) {
    stop("base_size must be a positive number", call. = FALSE)
  }

  # NULL coalescing with %||% operator
  base_family <- base_family %||% get_bfh_font(check_installed = TRUE, silent = TRUE)

  # ... implementation
}
```

### NULL Handling

Use the `%||%` operator (defined in `utils_operators.R`):

```r
# ✅ Good - use %||% for defaults
base_family <- base_family %||% get_bfh_font()
text <- text %||% "Default text"

# ❌ Bad - missing fallback
base_family <- base_family
```

### ggplot2 Patterns

```r
# ✅ Good - Return ggplot objects for composition
create_plot <- function(data) {
  ggplot(data, aes(x = x, y = y)) +
    geom_line() +
    theme_bfh()
}

# ❌ Bad - Don't print inside functions
create_plot <- function(data) {
  plot <- ggplot(data, aes(x = x, y = y)) + geom_line()
  print(plot)  # DON'T DO THIS
}
```

---

## Testing

### Test Structure

Tests are organized in `tests/testthat/` by module:

- `test-themes.R` - Theme functions
- `test-colors.R` - Color palettes
- `test-scales.R` - Scale functions
- `test-fonts.R` - Font detection
- `test-helpers.R` - Plot helpers
- `test-branding.R` - Logo and branding
- `test-defaults.R` - Global defaults

### Writing Tests

```r
test_that("function handles valid input correctly", {
  # Arrange
  input <- valid_data

  # Act
  result <- your_function(input)

  # Assert
  expect_type(result, "character")
  expect_length(result, 5)
})

test_that("function validates input parameters", {
  # Act & Assert
  expect_error(
    your_function(invalid_input),
    "Expected error message"
  )
})
```

### Running Tests

```r
# All tests
devtools::test()

# Specific test file
testthat::test_file("tests/testthat/test-colors.R")

# With coverage report
covr::package_coverage()
```

### Coverage Goals

- **≥90% overall coverage** (current: 89.74%)
- **100% on exported functions**
- **Edge cases**: NULL inputs, empty data, invalid types
- **Security tests**: Path traversal, input validation

### Test Best Practices

1. Test one thing per test
2. Use descriptive test names
3. Include both positive and negative test cases
4. Test edge cases and error conditions
5. Use `skip_if_not_installed()` for optional dependencies

```r
test_that("add_bfh_logo requires ggplot2", {
  skip_if_not_installed("ggplot2")

  p <- ggplot(mtcars, aes(wt, mpg)) + geom_point()
  result <- add_bfh_logo(p, get_bfh_logo())

  expect_s3_class(result, "ggplot")
})
```

---

## Documentation

### Roxygen2 Format

All exported functions must have complete roxygen documentation:

```r
#' Short Title (One Line)
#'
#' @description
#' Detailed description of what the function does, when to use it,
#' and any important details about behavior.
#'
#' @param param_name Description of parameter, including type and valid values
#' @param another_param Another parameter description
#'
#' @return Description of what is returned, including type
#'
#' @export
#'
#' @examples
#' # Example with comments
#' result <- my_function(x = 1:10)
#'
#' # More complex example
#' result2 <- my_function(x = data, param = "value")
#'
#' \dontrun{
#' # Example requiring external data
#' my_function(data = external_data)
#' }
my_function <- function(param_name, another_param = NULL) {
  # Implementation
}
```

### Required Roxygen Tags

- `@description` - Detailed function description
- `@param` - For each parameter
- `@return` - What the function returns
- `@export` - For exported functions
- `@examples` - Working examples
- `@importFrom` - For imported functions from other packages

### Update Documentation

After modifying roxygen comments:

```r
# Regenerate documentation and NAMESPACE
devtools::document()

# Verify documentation builds without errors
devtools::check_man()
```

### Vignettes

For major features, consider adding a vignette:

```r
# Create new vignette
usethis::use_vignette("your-feature-name")
```

---

## Commit Guidelines

### Commit Message Format

```
type(scope): short action-oriented description

Optional longer description providing context and rationale.

- Bullet points for multiple changes
- Breaking changes marked explicitly
```

### Commit Types

- `feat` - New feature
- `fix` - Bug fix
- `refactor` - Code refactoring (no behavior change)
- `test` - Adding or modifying tests
- `docs` - Documentation changes
- `chore` - Maintenance tasks
- `perf` - Performance improvements

### Examples

```bash
# Good commit messages
git commit -m "feat(themes): add theme_bfh_dark for dark backgrounds"
git commit -m "fix(colors): resolve bfh_cols() zero-argument bug"
git commit -m "test(fonts): add coverage for extrafont fallback path"
git commit -m "docs(readme): update installation instructions"

# Bad commit messages
git commit -m "update code"
git commit -m "fix bug"
git commit -m "changes"
```

### Important Commit Rules

**DO NOT include:**
- ❌ "🤖 Generated with [Claude Code]"
- ❌ "Co-Authored-By: Claude <noreply@anthropic.com>"
- ❌ Other AI attribution footers

These should only be used when explicitly requested by maintainers.

---

## Pull Request Process

### Before Submitting

Complete this checklist:

- [ ] All tests pass (`devtools::test()`)
- [ ] Package check passes (`devtools::check()`)
- [ ] Code is formatted (`styler::style_pkg()`)
- [ ] Code is linted (`lintr::lint_package()`)
- [ ] Documentation is updated (`devtools::document()`)
- [ ] Examples are verified and working
- [ ] NAMESPACE is regenerated (via `devtools::document()`)
- [ ] Coverage is maintained or improved

### Creating a Pull Request

1. **Push your branch:**

```bash
git push origin feature/your-feature-name
```

2. **Create PR on GitHub:**
   - Go to https://github.com/johanreventlow/BFHtheme
   - Click "New Pull Request"
   - Select your branch
   - Fill in the PR template

3. **PR Description Template:**

```markdown
## Summary
Brief description of changes

## Motivation
Why this change is needed

## Changes
- List of specific changes
- Include breaking changes if any

## Testing
How the changes were tested

## Checklist
- [ ] Tests pass
- [ ] Documentation updated
- [ ] Code formatted and linted
```

### PR Review Process

- Maintainers will review your PR
- Address any feedback or requested changes
- Tests must pass before merging
- At least one maintainer approval required

---

## Review Checklist

When reviewing code (or self-reviewing before submission):

### Functionality
- [ ] Code does what it's supposed to do
- [ ] Edge cases are handled
- [ ] Error messages are informative
- [ ] No breaking changes to existing API (unless discussed)

### Code Quality
- [ ] Follows snake_case naming convention
- [ ] Input validation for exported functions
- [ ] NULL safety using `%||%` operator
- [ ] No hardcoded values (use constants/parameters)
- [ ] DRY principle followed (no unnecessary duplication)

### Testing
- [ ] Tests are comprehensive
- [ ] Tests cover edge cases
- [ ] Tests include error conditions
- [ ] Coverage maintained or improved (≥90%)

### Documentation
- [ ] Roxygen documentation complete
- [ ] Examples are working and useful
- [ ] README updated if needed
- [ ] Vignettes updated if applicable

### Performance
- [ ] No obvious performance issues
- [ ] Efficient algorithms used
- [ ] Caching used where appropriate

### Security
- [ ] Input validation prevents path traversal
- [ ] No hardcoded credentials or sensitive data
- [ ] File operations use safe paths

---

## Additional Resources

### Package Development
- [R Packages book](https://r-pkgs.org/)
- [ggplot2 documentation](https://ggplot2.tidyverse.org/)
- [testthat documentation](https://testthat.r-lib.org/)

### BFHtheme Specific
- [CLAUDE.md](CLAUDE.md) - Detailed development instructions
- [README.md](README.md) - Package overview and usage
- [FONTS.md](FONTS.md) - Font system documentation
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues

### Getting Help

- **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/johanreventlow/BFHtheme/issues)
- **Discussions**: Ask questions in GitHub Discussions
- **Email**: Contact the maintainers directly

---

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Focus on what's best for the project and community
- Accept constructive criticism gracefully
- Show empathy towards other contributors

### Our Responsibilities

Maintainers are responsible for clarifying standards of acceptable behavior and will take appropriate action in response to any unacceptable behavior.

---

## License

By contributing to BFHtheme, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to BFHtheme! Your efforts help make healthcare data visualization more accessible and professional.
