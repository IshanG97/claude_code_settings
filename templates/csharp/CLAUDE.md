# .NET WinForms Project Guidelines

## Code Style
- Follow Microsoft's C# Coding Conventions
- Use PascalCase for public members, camelCase for private fields
- Use meaningful names for classes, methods, and variables
- Prefer explicit types over `var` unless type is obvious
- Use nullable reference types in .NET 6+
- Maximum line length of 120 characters

## Naming Conventions
```csharp
// Forms and Controls - PascalCase with descriptive suffix
public partial class MainForm : Form
public class UserListControl : UserControl

// Event handlers - ObjectName_EventName pattern
private void SaveButton_Click(object sender, EventArgs e)
private void UserDataGrid_CellValueChanged(object sender, DataGridViewCellEventArgs e)

// Fields - camelCase with underscore prefix
private readonly UserService _userService;
private readonly string _connectionString;

// Local variables, parameters - camelCase
public void ProcessUserData(string userName, int userId)
{
    var result = GetUserData(userName);
}
```

## WinForms Project Structure
```
WinFormsApp/
├── Forms/                          # Application forms
│   ├── MainForm.cs
│   ├── MainForm.Designer.cs
│   ├── MainForm.resx
│   ├── UserEditForm.cs
│   └── SettingsForm.cs
├── Controls/                       # Custom user controls
│   ├── CustomDataGrid.cs
│   └── StatusPanel.cs
├── Services/                       # Business logic
│   ├── UserService.cs
│   └── DataService.cs
├── Models/                         # Data models
│   ├── User.cs
│   └── AppSettings.cs
├── Resources/                      # Images, icons, strings
│   ├── Images/
│   ├── Icons/
│   └── Strings.resx
├── Data/                          # Data access layer
│   ├── Repositories/
│   └── DbContext.cs
├── Utilities/                     # Helper classes
├── Program.cs                     # Application entry point
├── App.config                     # Configuration file
└── WinFormsApp.csproj
```

## Form Design Best Practices
- **Layout**: Use TableLayoutPanel and FlowLayoutPanel for responsive layouts
- **Anchoring**: Set Anchor properties for proper resizing behavior
- **Tab Order**: Set TabIndex properties for logical navigation
- **Accessibility**: Set AccessibleName and AccessibleDescription properties
- **Icons**: Use consistent icon sizes (16x16 for small, 32x32 for large)
- **Colors**: Respect system theme colors (SystemColors class)

## Common WinForms Patterns
```csharp
// Form initialization pattern
public partial class MainForm : Form
{
    private readonly UserService _userService;
    
    public MainForm(UserService userService)
    {
        InitializeComponent();
        _userService = userService;
        InitializeCustomComponents();
    }
    
    private void InitializeCustomComponents()
    {
        // Custom initialization logic
        LoadUserData();
        SetupEventHandlers();
    }
}

// Data binding pattern
private void BindUserData()
{
    var bindingSource = new BindingSource();
    bindingSource.DataSource = _users;
    userDataGrid.DataSource = bindingSource;
}

// Background operations pattern
private async void LoadDataButton_Click(object sender, EventArgs e)
{
    loadingProgressBar.Visible = true;
    loadDataButton.Enabled = false;
    
    try
    {
        var users = await _userService.GetUsersAsync();
        userDataGrid.DataSource = users;
    }
    catch (Exception ex)
    {
        MessageBox.Show($"Error loading data: {ex.Message}", "Error", 
            MessageBoxButtons.OK, MessageBoxIcon.Error);
    }
    finally
    {
        loadingProgressBar.Visible = false;
        loadDataButton.Enabled = true;
    }
}
```

## Data Access with Entity Framework Core
```csharp
// DbContext for WinForms
public class AppDbContext : DbContext
{
    public DbSet<User> Users { get; set; }
    
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
    }
}

// Repository pattern for WinForms
public class UserRepository
{
    public async Task<List<User>> GetAllUsersAsync()
    {
        using var context = new AppDbContext();
        return await context.Users.ToListAsync();
    }
}
```

## Configuration Management
```csharp
// App.config
<?xml version="1.0" encoding="utf-8"?>
<configuration>
    <connectionStrings>
        <add name="DefaultConnection" 
             connectionString="Server=.;Database=MyApp;Trusted_Connection=true;" />
    </connectionStrings>
    <appSettings>
        <add key="WindowWidth" value="1024" />
        <add key="WindowHeight" value="768" />
    </appSettings>
</configuration>

// Accessing configuration
string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
int windowWidth = int.Parse(ConfigurationManager.AppSettings["WindowWidth"]);
```

## Error Handling in WinForms
```csharp
// Application-level exception handling
static void Main()
{
    Application.SetUnhandledExceptionMode(UnhandledExceptionMode.CatchException);
    Application.ThreadException += Application_ThreadException;
    AppDomain.CurrentDomain.UnhandledException += CurrentDomain_UnhandledException;
    
    Application.EnableVisualStyles();
    Application.SetCompatibleTextRenderingDefault(false);
    Application.Run(new MainForm());
}

private static void Application_ThreadException(object sender, ThreadExceptionEventArgs e)
{
    MessageBox.Show($"An error occurred: {e.Exception.Message}", "Error", 
        MessageBoxButtons.OK, MessageBoxIcon.Error);
}
```

## Performance Considerations
- **Lazy Loading**: Load data only when needed
- **Virtual Mode**: Use DataGridView virtual mode for large datasets
- **Background Threading**: Use async/await for I/O operations
- **Control Updates**: Use BeginInvoke/Invoke for cross-thread operations
- **Memory Management**: Dispose resources properly (using statements)

## Common Commands
- **Create WinForms project**: `dotnet new winforms -n MyWinFormsApp`
- **Add Entity Framework**: `dotnet add package Microsoft.EntityFrameworkCore.SqlServer`
- **Build solution**: `dotnet build`
- **Run application**: `dotnet run`
- **Run tests**: `dotnet test`
- **Publish**: `dotnet publish -c Release --self-contained`

## Testing WinForms Applications
```csharp
// Unit testing business logic
[Test]
public void UserService_GetUser_ReturnsCorrectUser()
{
    // Arrange
    var userService = new UserService();
    
    // Act
    var user = userService.GetUser(1);
    
    // Assert
    Assert.AreEqual("John Doe", user.Name);
}

// Integration testing with forms (using White framework)
[Test]
public void MainForm_LoadUsers_DisplaysCorrectCount()
{
    var application = Application.Launch("MyWinFormsApp.exe");
    var mainWindow = application.GetWindow("Main Form");
    
    var loadButton = mainWindow.Get<Button>("LoadUsersButton");
    loadButton.Click();
    
    var dataGrid = mainWindow.Get<ListView>("UsersDataGrid");
    Assert.AreEqual(5, dataGrid.Rows.Count);
    
    application.Close();
}
```

## Deployment
- **ClickOnce**: For easy deployment and auto-updates
- **Self-contained**: Include .NET runtime with application
- **Framework-dependent**: Smaller size, requires .NET runtime installed
- **MSI/Setup**: Use tools like WiX or InstallShield for complex installations

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
- Use consistent project structure within .NET ecosystem
- Group related functionality together
- Separate concerns appropriately
- Follow C# and .NET-specific conventions and idioms

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