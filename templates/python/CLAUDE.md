# Python Project Guidelines

## Code Style
- Follow PEP 8 style guidelines
- Use type hints for all functions and methods
- Prefer f-strings for string formatting
- Use descriptive variable names
- Maximum line length of 88 characters (Black formatter default)

## Import Style
- Group imports: standard library, third-party, local imports
- Use absolute imports when possible
- Sort imports alphabetically within groups
- Use `from typing import` for type hints

## Testing
- Use pytest as the primary testing framework
- Name test files with `test_` prefix
- Write tests for all public functions and methods
- Aim for high test coverage (>90%)

## Common Commands

### Using uv (recommended)
- **Install dependencies**: `uv sync` or `uv install`
- **Run commands**: `uv run <command>` (automatically uses project environment)
- **Run tests**: `uv run pytest` or `uv run python -m pytest`
- **Run specific test**: `uv run pytest tests/test_filename.py::test_function_name`
- **Format code**: `uv run ruff format .` or `uv run black .`
- **Lint code**: `uv run ruff check .` or `uv run flake8`
- **Type check**: `uv run mypy src/`
- **Security check**: `uv run bandit -r src/`

### Alternative (pip/poetry)
- **Install dependencies**: `pip install -r requirements.txt` or `poetry install`
- **Run tests**: `pytest` or `python -m pytest`
- **Format code**: `black .` or `python -m black .`
- **Lint code**: `ruff check .` or `flake8`
- **Type check**: `mypy src/` or `python -m mypy src/`

## Project Structure
```
project/
├── src/
│   └── package/
│       ├── __init__.py
│       └── module.py
├── tests/
│   ├── __init__.py
│   └── test_module.py
├── requirements.txt
├── pyproject.toml
└── README.md
```

## Dependencies

### Using uv (recommended)
- **pyproject.toml**: Define all dependencies and project metadata
- **uv.lock**: Lockfile for reproducible installations
- **Dev dependencies**: Use `[tool.uv.dev-dependencies]` or dependency groups
- **Installation**: `uv sync` installs and manages virtual environment automatically

### Alternative approaches
- **Development**: pytest, ruff/black, flake8, mypy, pre-commit
- **Production**: Keep minimal, use virtual environments
- **Version pinning**: Pin exact versions in requirements.txt or use poetry

## Environment Management
- **uv**: Automatically creates and manages virtual environments per project
- **Traditional**: Use venv, conda, or poetry for environment isolation
- Keep dependencies organized and documented

## Error Handling
- Use specific exception types
- Include meaningful error messages
- Log errors appropriately
- Handle exceptions at the right level

## Git Commit Guidelines

### Commit Message Format
Always use conventional commit format with these prefixes:
- `feat:` - new features
- `fix:` - bug fixes
- `chore:` - maintenance tasks, dependency updates
- `refactor:` - code refactoring without functionality changes
- `docs:` - documentation changes
- `style:` - formatting, missing semicolons, etc.
- `test:` - adding or updating tests
- `perf:` - performance improvements
- `build:` - build system or external dependency changes
- `ci:` - CI/CD configuration changes

### Additional Commit Rules
- Keep commits small and focused on single logical changes
- **Never mention Claude or AI assistance in commit messages**
- Write clear, descriptive commit messages explaining the "why"
- Use imperative mood: "Add feature" not "Added feature"

## General Development Principles

### Code Quality
- Use meaningful variable and function names
- Prefer explicit over implicit when it improves clarity
- Write self-documenting code with clear intent
- Add comments only when the "why" isn't obvious from code

### Testing and Validation
- Always typecheck when done making a series of code changes
- Prefer running single tests over whole test suite for performance
- Run linting and formatting before committing changes
- Ensure all tests pass before pushing changes

### Error Handling Best Practices
- Use specific exception types, not generic ones
- Include meaningful error messages with context
- Handle errors at the appropriate level
- Log errors with sufficient detail for debugging

### Performance Considerations
- Profile before optimizing
- Measure the impact of performance changes
- Consider maintainability vs performance tradeoffs
- Document performance-critical sections

## Documentation Standards

### Code Documentation
- Use docstrings for all public functions, classes, and modules
- Follow Google or NumPy docstring conventions
- Include type information in docstrings
- Document public APIs with clear examples
- Explain complex algorithms and business logic
- Keep documentation up-to-date with code changes

### Project Documentation
- Maintain clear README with setup and usage instructions
- Document architecture decisions and rationale
- Include troubleshooting guides for common issues
- Provide contributing guidelines for team projects

## Security Best Practices

### Secrets and Configuration
- Never commit secrets, keys, or credentials
- Use environment variables for configuration
- Implement proper secret rotation policies
- Use secure methods for secret storage and access

### Input Validation
- Validate all external inputs
- Sanitize data before processing
- Use parameterized queries to prevent injection
- Implement proper authentication and authorization

## Code Organization
- Use consistent project structure within Python ecosystem
- Group related functionality together
- Separate concerns appropriately
- Follow PEP 8 and Python-specific conventions and idioms

## Dependency Management
- Pin dependency versions for reproducible builds
- Regularly update dependencies for security patches
- Remove unused dependencies
- Document why specific versions are required

## Debugging and Observability
- Include adequate logging at appropriate levels
- Use structured logging where possible
- Implement proper monitoring and alerting
- Make systems debuggable and observable