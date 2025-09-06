# Git Commit Guidelines

## Commit Message Format
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

## Additional Rules
- Keep commits small and focused on single logical changes
- **Never mention Claude or AI assistance in commit messages**
- Write clear, descriptive commit messages explaining the "why"
- Use imperative mood: "Add feature" not "Added feature"

# Code Style
- Use ES modules (import/export) syntax, not CommonJS (require)
- Destructure imports when possible (eg. import { foo } from 'bar')

# Workflow
- Be sure to typecheck when you're done making a series of code changes
- Prefer running single tests, and not the whole test suite, for performance