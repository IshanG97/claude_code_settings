# C# WinForms Development Guidelines

## Code Style & Conventions
- Follow Microsoft's C# Coding Conventions
- Use PascalCase for public members, camelCase for private fields with underscore prefix
- Event handlers: `ObjectName_EventName` pattern
- Forms/Controls: PascalCase with descriptive suffix (e.g., `MainForm`, `UserListControl`)
- Prefer explicit types over `var` unless type is obvious
- Use nullable reference types in .NET 6+

## Project Structure
```
WinFormsApp/
├── Forms/                    # Application forms (MainForm.cs, UserEditForm.cs)
├── Controls/                 # Custom user controls  
├── Services/                 # Business logic
├── Models/                   # Data models
├── Resources/                # Images, icons, strings
├── Data/                     # Data access layer
├── Program.cs                # Application entry point
└── App.config               # Configuration
```

## WinForms Best Practices
- Use TableLayoutPanel/FlowLayoutPanel for responsive layouts
- Set Anchor properties for proper resizing behavior
- Configure TabIndex for logical navigation
- Set AccessibleName/AccessibleDescription for accessibility
- Use consistent icon sizes and system theme colors (SystemColors)

## Essential Patterns

### Form Initialization
```csharp
public partial class MainForm : Form
{
    private readonly UserService _userService;
    
    public MainForm(UserService userService)
    {
        InitializeComponent();
        _userService = userService;
        InitializeCustomComponents();
    }
}
```

### Async Operations
```csharp
private async void LoadButton_Click(object sender, EventArgs e)
{
    loadButton.Enabled = false;
    try
    {
        var data = await _service.GetDataAsync();
        dataGrid.DataSource = data;
    }
    catch (Exception ex)
    {
        MessageBox.Show($"Error: {ex.Message}", "Error", 
            MessageBoxButtons.OK, MessageBoxIcon.Error);
    }
    finally
    {
        loadButton.Enabled = true;
    }
}
```

## Data Access
```csharp
// Entity Framework DbContext
public class AppDbContext : DbContext
{
    public DbSet<User> Users { get; set; }
    
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString);
    }
}

// Repository pattern
public class UserRepository
{
    public async Task<List<User>> GetAllUsersAsync()
    {
        using var context = new AppDbContext();
        return await context.Users.ToListAsync();
    }
}
```

## Configuration
```xml
<!-- App.config -->
<configuration>
    <connectionStrings>
        <add name="DefaultConnection" 
             connectionString="Server=.;Database=MyApp;Trusted_Connection=true;" />
    </connectionStrings>
    <appSettings>
        <add key="WindowWidth" value="1024" />
    </appSettings>
</configuration>
```

```csharp
// Accessing configuration
string connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
int windowWidth = int.Parse(ConfigurationManager.AppSettings["WindowWidth"]);
```

## Exception Handling
```csharp
// Application-level exception handling in Program.cs
static void Main()
{
    Application.SetUnhandledExceptionMode(UnhandledExceptionMode.CatchException);
    Application.ThreadException += Application_ThreadException;
    Application.EnableVisualStyles();
    Application.Run(new MainForm());
}

private static void Application_ThreadException(object sender, ThreadExceptionEventArgs e)
{
    MessageBox.Show($"Error: {e.Exception.Message}", "Error", 
        MessageBoxButtons.OK, MessageBoxIcon.Error);
}
```

## Common Commands
- Create WinForms project: `dotnet new winforms -n MyWinFormsApp`
- Add Entity Framework: `dotnet add package Microsoft.EntityFrameworkCore.SqlServer`
- Build: `dotnet build` 
- Run: `dotnet run`
- Test: `dotnet test`
- Publish: `dotnet publish -c Release --self-contained`

## Performance Tips
- Use DataGridView virtual mode for large datasets  
- Implement async/await for I/O operations
- Use BeginInvoke/Invoke for cross-thread operations
- Dispose resources properly with `using` statements

## Deployment Options
- **ClickOnce**: Easy deployment with auto-updates
- **Self-contained**: Includes .NET runtime  
- **Framework-dependent**: Smaller size, requires runtime
- **MSI/Setup**: Use WiX or InstallShield for complex installations