# Python Development Guidelines

## Prerequisites: uv Package Manager
This project uses `uv` for dependency management. If not installed:

**Install uv:**
```bash
# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# Alternative (via pip)
pip install uv
```

## Code Standards
- Follow PEP 8 with 88-character line limit (Black default)
- Use type hints for all functions and methods
- Prefer f-strings for string formatting
- Group imports: standard library, third-party, local
- Use descriptive variable names and self-documenting code

## Common Commands
- **Setup**: `uv sync` - installs dependencies and manages venv
- **Run**: `uv run <command>` - executes in project environment
- **Test**: `uv run pytest` or `uv run pytest tests/test_file.py::test_name`
- **Format**: `uv run ruff format .`
- **Lint**: `uv run ruff check .`
- **Type check**: `uv run mypy src/`
- **Security**: `uv run bandit -r src/`

## Project Structure
```
project/
├── src/package/
│   ├── __init__.py
│   └── module.py
├── tests/
│   └── test_module.py
├── pyproject.toml
└── requirements.txt
```

## Testing
- Use pytest with `test_` prefix for files and functions
- Write tests for all public APIs
- Run specific tests for faster feedback
- Aim for >90% test coverage

## Git Commit Format
Use conventional commit prefixes:
- `feat:` - new features
- `fix:` - bug fixes  
- `chore:` - maintenance, dependencies
- `refactor:` - code restructuring
- `docs:` - documentation
- `style:` - formatting
- `test:` - tests
- `perf:` - performance
- `build:` - build system
- `ci:` - CI/CD

**Rules**: Keep commits atomic, use imperative mood, never mention AI assistance

## Security Best Practices
- Never commit secrets, keys, or credentials
- Use environment variables for configuration
- Validate all external inputs
- Use parameterized queries to prevent injection
- Keep dependencies updated
- Remove secrets from git history using `git-filter-repo` if accidentally committed

### Git History Management with git-filter-repo
Use `git-filter-repo` for repository history modifications:

```bash
# Remove sensitive files from history
git filter-repo --path .env --invert-paths

# Replace API keys across all files and commits
git filter-repo --replace-text <(echo 'sk-abc123==>sk-xxxxxxxx')

# Update author information
git filter-repo --mailmap .mailmap

# Standardize commit messages
git filter-repo --replace-message <(echo 'fix typo==>fix: correct typo')

# Restructure Python package layout
git filter-repo --path src/ --to-subdirectory-filter mypackage/
```

## Error Handling
- Use specific exception types with meaningful messages
- Handle exceptions at appropriate levels
- Include sufficient context for debugging
- Log errors with structured data when possible

## Development Workflow
1. Always typecheck after code changes
2. Run linting and formatting before commits
3. Ensure tests pass before pushing
4. Use docstrings for public APIs (Google/NumPy style)
5. Pin dependency versions for reproducible builds