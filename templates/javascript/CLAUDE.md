# JavaScript/TypeScript Development Guidelines

## Code Style & Standards
- **Modules**: Use ES modules (`import/export`), not CommonJS (`require`)
- **Variables**: Use `const/let`, never `var`
- **Functions**: Prefer arrow functions for callbacks and short functions
- **Strings**: Use template literals for interpolation
- **Indentation**: 2 spaces (configurable in .editorconfig)

### Import Organization
```javascript
// Standard library imports first
import fs from 'fs'
import path from 'path'

// Third-party imports
import { Component } from 'react'
import { debounce } from 'lodash'

// Local imports last
import utils from './utils.js'
```

## TypeScript Configuration
- Enable strict mode, `noImplicitAny`, and `strictNullChecks`
- Use explicit types for function parameters and return values
- Prefer interfaces over type aliases for object shapes
- Use enums for meaningful constants

## Testing & Quality
- **Framework**: Jest for unit tests, Cypress/Playwright for E2E
- **Coverage**: Aim for >80% test coverage
- **Linting**: ESLint with recommended rules
- **Formatting**: Prettier with consistent configuration
- **Pre-commit**: Husky + lint-staged for quality gates

## Common Commands
```bash
npm install              # Install dependencies
npm run dev             # Development server
npm run build           # Production build
npm test                # Run tests
npm run lint            # Lint code
npm run format          # Format code
tsc --noEmit           # Type check (TypeScript)
```

## Framework Guidelines

### React
- Use functional components with hooks
- Prefer composition over inheritance
- Implement error boundaries for production

### Node.js
- Use async/await over callbacks
- Handle errors with try/catch
- Use environment variables for configuration

## Development Best Practices

### Code Quality
- Use meaningful variable and function names
- Write self-documenting code with clear intent
- Add comments only when the "why" isn't obvious
- Validate all external inputs and handle errors gracefully

### Performance & Security
- Use lazy loading for large components/modules
- Implement proper caching strategies
- Never commit secrets, keys, or credentials
- Use environment variables for configuration
- Keep dependencies updated for security patches

### Workflow
- Always typecheck after making code changes
- Run linting and formatting before committing
- Ensure all tests pass before pushing changes
- Pin dependency versions for reproducible builds

## Git Commit Standards

Use conventional commit format:
- `feat:` - new features
- `fix:` - bug fixes  
- `chore:` - maintenance, dependency updates
- `refactor:` - code restructuring without behavior changes
- `docs:` - documentation changes
- `test:` - adding or updating tests

**Commit Rules:**
- Keep commits focused on single logical changes
- Use imperative mood: "Add feature" not "Added feature"
- Write clear messages explaining the "why"