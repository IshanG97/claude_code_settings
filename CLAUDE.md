# Development Guidelines

## Git Commit Standards

### Conventional Commit Format
Use these standardized prefixes for all commits:
- `feat:` - new features or functionality
- `fix:` - bug fixes and issue resolutions
- `chore:` - maintenance, dependencies, tooling
- `refactor:` - code restructuring without behavior changes
- `docs:` - documentation updates
- `style:` - formatting, linting fixes
- `test:` - test additions or modifications
- `perf:` - performance improvements
- `build:` - build system changes
- `ci:` - CI/CD configuration updates

### Commit Best Practices
- Keep commits atomic and focused on single logical changes
- Write clear, descriptive messages explaining the "why"
- Use imperative mood: "Add feature" not "Added feature"
- Never mention AI assistance in commit messages
- Retry commits if pre-commit hooks make changes

## Security Guidelines

### Secrets Management
- Never commit API keys, passwords, tokens, or credentials
- Use environment variables or secure configuration management
- Scan for accidentally committed secrets before pushing
- Remove secrets from git history if accidentally committed

### Code Security
- Follow security best practices for the language/framework
- Validate all user inputs
- Use parameterized queries for database operations
- Keep dependencies updated and scan for vulnerabilities

## Code Quality Standards

### General Principles
- Follow existing project conventions and patterns
- Prioritize readability and maintainability
- Use consistent naming conventions
- Add comments only when necessary for complex logic
- Prefer composition over inheritance
- Write self-documenting code

### Testing Requirements
- Write tests for new functionality
- Maintain existing test coverage
- Run full test suite before committing
- Fix failing tests immediately