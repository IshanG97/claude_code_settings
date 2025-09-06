# JavaScript/TypeScript Project Guidelines

## Code Style
- Use ES modules (import/export) syntax, not CommonJS (require)
- Destructure imports when possible: `import { foo } from 'bar'`
- Use const/let, never var
- Prefer arrow functions for callbacks and short functions
- Use template literals for string interpolation
- 2-space indentation (configurable in .editorconfig)

## Import/Export Style
```javascript
// Good - ES modules with proper grouping
// Standard library imports first
import fs from 'fs'
import path from 'path'

// Third-party imports
import { Component } from 'react'
import { debounce, throttle } from 'lodash'

// Local imports last
import utils from './utils.js'

// Avoid CommonJS
const React = require('react')
const _ = require('lodash')
```

### Import Organization
- Group imports: standard library, third-party, local imports
- Sort imports alphabetically within groups
- Use destructuring when importing specific items

## TypeScript Preferences
- Enable strict mode in tsconfig.json
- Use explicit types for function parameters and return values
- Prefer interfaces over type aliases for object shapes
- Use enums for constants with meaningful names
- Enable noImplicitAny and strictNullChecks

## Testing
- **Framework**: Jest for unit tests, Cypress/Playwright for E2E
- **File naming**: `*.test.js`, `*.test.ts`, or `__tests__/` directory
- **Coverage**: Aim for >80% test coverage
- **Mocking**: Use Jest mocks sparingly, prefer dependency injection

## Common Commands
- **Install dependencies**: `npm install` or `yarn install`
- **Run development server**: `npm run dev` or `npm start`
- **Build for production**: `npm run build`
- **Run tests**: `npm test` or `npm run test`
- **Run specific test**: `npm test -- --testNamePattern="test name"`
- **Lint code**: `npm run lint` or `eslint src/`
- **Format code**: `npm run format` or `prettier --write src/`
- **Type check**: `tsc --noEmit` (for TypeScript)

## Project Structure
```
project/
├── src/
│   ├── components/
│   ├── utils/
│   ├── types/
│   └── index.js
├── tests/
│   └── __tests__/
├── public/
├── package.json
├── tsconfig.json (if TypeScript)
├── .eslintrc.js
└── .prettierrc
```

## Package Management
- Use npm or yarn consistently across project
- Pin dependencies to specific versions in package-lock.json
- Separate devDependencies from dependencies
- Keep packages updated regularly

## Build Tools
- **Bundler**: Vite, Webpack, or Rollup
- **Transpiler**: Babel or TypeScript compiler
- **Development**: Hot module replacement (HMR)
- **Production**: Minification, tree-shaking, code splitting

## Code Quality
- **Linter**: ESLint with recommended rules
- **Formatter**: Prettier with consistent configuration
- **Pre-commit hooks**: Husky + lint-staged
- **Type checking**: TypeScript strict mode

## Framework-Specific Guidelines

### React
- Use functional components with hooks
- Prefer composition over inheritance
- Use PropTypes or TypeScript for prop validation
- Implement error boundaries for production apps

### Node.js
- Use async/await over Promises and callbacks
- Handle errors properly with try/catch
- Use environment variables for configuration
- Implement proper logging (Winston, Pino)

### Frontend Frameworks
- Follow framework-specific style guides
- Use official CLI tools for project scaffolding
- Implement proper state management (Redux, Zustand, etc.)
- Optimize for performance (lazy loading, memoization)

## Error Handling
- Use try/catch for async operations
- Implement global error handlers
- Log errors with context information
- Provide meaningful error messages to users

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
- Use lazy loading for large components/modules
- Implement proper caching strategies
- Optimize bundle size with code splitting
- Monitor performance with tools like Lighthouse
- Profile before optimizing
- Measure the impact of performance changes
- Consider maintainability vs performance tradeoffs
- Document performance-critical sections

## Documentation Standards

### Code Documentation
- Document public APIs with clear examples
- Include type information in documentation
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
- Use consistent project structure within JavaScript/TypeScript ecosystem
- Group related functionality together
- Separate concerns appropriately
- Follow JavaScript/TypeScript-specific conventions and idioms

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