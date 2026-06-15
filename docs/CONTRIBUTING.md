# Contributing to FishMe

Thank you for your interest in contributing to FishMe! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Submitting Changes](#submitting-changes)
- [Review Process](#review-process)

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors.

### Our Standards

- Be respectful and inclusive
- Use welcoming language
- Be constructive in feedback
- Focus on what is best for the community
- Show empathy towards other community members

### Responsibilities

Maintainers are le for clarifying standards and taking action when standards are not met.

## Getting Started

### Prerequisites

- Bash shell
- PHP 7.4 or higher
- curl
- jq (for JSON processing)
- git
- Basic knowledge of shell scripting
- Basic knowledge of PHP (for templates)

### Setting Up Development Environment

```bash
# Clone the repository
git clone https://github.com/syed-sameer-ul-hassan/FishME.git
cd FishME

# Make the fishme script executable
chmod +x fishme

# Test the installation
./fishme -v
```

### Development Tools

Recommended tools for development:

- **ShellCheck**: For shell script linting
- **PHP**: For testing templates
- **jq**: For JSON processing
- **git**: For version control

## Development Workflow

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally
3. Add the upstream repository as a remote

```bash
git clone https://github.com/YOUR_USERNAME/FishME.git
cd FishME
git remote add upstream https://github.com/syed-sameer-ul-hassan/FishME.git
```

### Create a Branch

Create a new branch for your feature or fix:

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

### Make Changes

Make your changes following the coding standards.

### Test Your Changes

Test your changes thoroughly before committing.

### Commit Your Changes

Write clear, descriptive commit messages:

```bash
git add .
git commit -m "Add feature: brief description of changes"
```

### Push to Your Fork

Push your changes to your fork:

```bash
git push origin feature/your-feature-name
```

### Create a Pull Request

Create a pull request to the upstream repository.

## Coding Standards

### Shell Scripting

#### Naming Conventions

- Functions: `snake_case` (e.g., `get_template_info`)
- Variables: `snake_case` (e.g., `template_name`)
- Constants: `UPPER_SNAKE_CASE` (e.g., `BASE_DIR`)

#### Code Style

- Use 4 spaces for indentation
- Use meaningful variable names
- Add comments for complex logic
- Keep functions focused and small
- Use local variables in functions

#### Example

```bash
# Good
get_template_info() {
    local template_name="$1"
    local template_dir="${TEMPLATES_DIR}/${template_name}"
    
    if [[ ! -d "$template_dir" ]]; then
        echo "Template not found: $template_name"
        return 1
    fi
    
    # Process template info
    echo "Template: $template_name"
}

# Bad
gti() {
    t=$1
    if [ ! -d "$t" ]; then
        echo "error"
    fi
}
```

### PHP

#### Naming Conventions

- Functions: `snake_case` (e.g., `sanitize_input`)
- Variables: `snake_case` (e.g., `$username`)
- Classes: `PascalCase` (e.g., `TemplateManager`)

#### Code Style

- Use 4 spaces for indentation
- Use meaningful variable names
- Add comments for complex logic
- Follow PSR-12 coding standards
- Always sanitize user input

#### Example

```php
// Good
function sanitizeInput($input) {
    $sanitized = htmlspecialchars($input, ENT_QUOTES, 'UTF-8');
    return trim($sanitized);
}

// Bad
function s($i) {
    return htmlspecialchars($i);
}
```

### JSON

#### Formatting

- Use 2 spaces for indentation
- Use double quotes for keys and string values
- Include trailing commas in arrays/objects
- Sort keys alphabetically (optional)

#### Example

```json
{
  "name": "Template Name",
  "slug": "template-slug",
  "version": "1.0.0",
  "features": [
    "feature1",
    "feature2"
  ]
}
```

## Testing

### Unit Testing

Write unit tests for new functions:

```bash
# Test function
test_get_template_info() {
    local result
    result=$(get_template_info "facebook")
    assert_contains "$result" "facebook"
}
```

### Integration Testing

Test the integration of components:

```bash
# Test template creation
fishme template create test "Test Template" "Test" "test.com"
fishme template validate test
fishme template delete test
```

### Manual Testing

Test manually for complex features:

1. Start the server: `./fishme start`
2. Test the feature
3. Verify the output
4. Check logs: `./fishme log recent`

## Documentation

### Code Comments

Add comments for:
- Complex logic
- Non-obvious operations
- Public functions
- Configuration options

### README Updates

Update the README.md for:
- New features
- New commands
- Breaking changes
- Configuration changes

### Documentation Files

Update relevant documentation files:
- `docs/SECURITY.md` for security changes
- `docs/RELEASES.md` for release notes
- `docs/CATALOG.md` for template changes
- `docs/INSTALLATION.md` for installation changes
- `docs/TROUBLESHOOTING.md` for known issues

## Submitting Changes

### Pull Request Guidelines

1. **Title**: Use a clear, descriptive title
2. **Description**: Explain what and why
3. **Related Issues**: Link to related issues
4. **Testing**: Describe how you tested
5. **Screenshots**: Add screenshots for UI changes

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
How did you test these changes?

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests added/updated
- [ ] All tests passing
```

## Review Process

### Review Criteria

Pull requests are reviewed based on:

- Code quality and style
- Functionality and correctness
- Test coverage
- Documentation completeness
- Security considerations
- Performance impact

### Review Timeline

- Initial review: 2-3 days
- Follow-up review: 1-2 days
- Merge decision: After approval

### Feedback

Maintainers may request:
- Code changes
- Additional tests
- Documentation updates
- Security improvements

### Merging

Pull requests are merged when:
- All reviewers approve
- All checks pass
- No conflicts with main branch
- Documentation is updated

## Feature Requests

### Submitting a Feature

1. Check existing issues first
2. Create a new issue with:
   - Clear description
   - Use cases
   - Proposed implementation
   - Alternatives considered

### Feature Discussion

Features are discussed in issues before implementation.

## Bug Reports

### Submitting a Bug

1. Check existing issues first
2. Create a new issue with:
   - Clear description
   - Steps to reproduce
   - Expected behavior
   - Actual behavior
   - Environment details
   - Logs/screenshots

### Bug Fix Template

```markdown
## Description
Bug description

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- OS: 
- FishMe version:
- PHP version:

## Logs
Relevant log output
```

## Security Issues

### Reporting Security Issues

Do NOT create public issues for security vulnerabilities.

Email: security@example.com (placeholder)

Include:
- Description of vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix

## Recognition

Contributors are recognized in:
- CONTRIBUTORS.md file
- Release notes
- Project documentation

## Getting Help

### Questions

Ask questions in:
- GitHub Issues (for bugs/features)
- GitHub Discussions (for questions)
- Email: support@example.com (placeholder)

### Resources

- [README.md](../README.md)
- [SECURITY.md](SECURITY.md)
- [ARCHITECTURE.md](ARCHITECTURE.md)
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## Contact

For questions about contributing:
- GitHub: https://github.com/syed-sameer-ul-hassan/FishME
- Email: support@example.com (placeholder)

---

**Last Updated**: 2026-06-13
