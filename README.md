# 🛠️ dotnet-craft.nvim

> A Neovim plugin for scaffolding .NET files — quickly create classes, interfaces, controllers, and more, without manually typing averything.

`dotnet-craft.nvim` brings .NET scaffolding to your fingertips. Generate boilerplate C# files with ease, directly from your editor — keeping your focus in code.

---

## ✨ Features

- 🧱 Scaffold **C# classes, interfaces, records, enums, api controllers and more**
- 📁 Smart file placement based on project structure
- 🧩 Custom templates support (define your own scaffolds)
- ⚡ Fast and async (non-blocking UI)
- 🧠 Detects project namespace automatically

---

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
	"vitorlfaria/dotnet-craft.nvim",
	config = function()
		local dotnet_craft = require("dotnet-craft")
		vim.keymap.set("n", "<leader>dc", dotnet_craft.craft, { desc = "Dotnet Craft" })
	end,
}
```

## Setup

Call `setup()` in your Neovim configuration:

```lua
require('dotnet-craft').setup({
    -- Your configuration here
})
```

## Configuration Options

### UI Settings

```lua
ui = {
    width = 60,                      -- Width of popup windows
    height_percentage = 0.2,          -- Height as percentage of screen (0.2 = 20%)
    max_height_percentage = 0.6,      -- Maximum height (0.6 = 60%)
    line = 5,                         -- Starting line position
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
}
```

### Excluded Directories

Directories that won't appear in the folder tree:

```lua
excluded_dirs = {
    "bin", "obj", "node_modules", ".git",
    ".vs", ".vscode", "packages", "TestResults",
}
```

### Template Placeholders

Define custom values for template placeholders:

```lua
template_placeholders = {
    author = "Your Name",
    company = "Your Company",
    -- {{year}} and {{date}} are automatically set
}
```

Available placeholders in templates:
- `{{name}}` - The class/interface name
- `{{namespace}}` - The calculated namespace
- `{{author}}` - From configuration
- `{{company}}` - From configuration
- `{{year}}` - Current year
- `{{date}}` - Current date (YYYY-MM-DD)

### File Header

Add a copyright/author header to all generated files:

```lua
add_file_header = true,
file_header = [[
// Copyright (c) {{year}} {{company}}
// Author: {{author}}
// Created: {{date}}
]],
```

### Common Using Statements

Automatically add using statements based on template type:

```lua
add_common_usings = true,
common_usings = {
    ["Api Controller"] = {
        "using Microsoft.AspNetCore.Mvc;",
    },
    ["Test Class"] = {
        "using Xunit;",
        "using FluentAssertions;",
    },
},
```

### Custom Templates

Add your own templates:

```lua
custom_templates = {
    ["MVVM ViewModel"] = [[
namespace {{namespace}};

public class {{name}} : ViewModelBase
{
    public {{name}}()
    {
    }
}
]],
}
```

You can also add templates programmatically:

```lua
local config = require('dotnet-craft.config')
config.add_template("My Template", "template content here")
```

### Notifications

Control notification behavior:

```lua
notifications = {
    enabled = true,           -- Enable/disable all notifications
    on_success = true,        -- Notify on successful file creation
    warn_no_csproj = true,    -- Warn when not in a .NET project
}
```

### Behavior Settings

```lua
behavior = {
    open_file_after_creation = true,  -- Auto-open created file
    confirm_overwrite = true,         -- Confirm before overwriting
    auto_format = false,              -- Auto-format after creation (requires formatter)
}
```

## Built-in Templates

The plugin includes these templates:
- **Class** - Basic public class
- **Sealed Class** - Sealed class
- **Static Class** - Static class
- **Abstract Class** - Abstract class
- **Interface** - Interface
- **Record** - Record type
- **Sealed Record** - Sealed record
- **Record Struct** - Record struct
- **Enum** - Enumeration
- **Struct** - Struct type
- **Api Controller** - ASP.NET API controller
- **Minimal Api Controller** - Minimal API controller with GET endpoint
- **Service** - Service class
- **Service Interface** - Service interface (with I prefix)
- **Repository** - Repository class
- **Repository Interface** - Repository interface (with I prefix)
- **Exception** - Custom exception class
- **Test Class** - xUnit test class

## Example Configuration

```lua
require('dotnet-craft').setup({
    template_placeholders = {
        author = "Jane Developer",
        company = "Tech Corp",
    },
    
    add_file_header = true,
    
    custom_templates = {
        ["Domain Entity"] = [[
namespace {{namespace}};

public class {{name}}
{
    public Guid Id { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}
]],
    },
    
    behavior = {
        open_file_after_creation = true,
        confirm_overwrite = true,
    },
})

-- Add keybinding
vim.keymap.set('n', '<leader>nc', ':DotNetCraft<CR>', { desc = 'New C# file' })
```

## Usage

1. Run `:DotNetCraft` or use your keybinding
2. Select the target folder
3. Choose a template
4. Enter the class/interface name
5. File is created with proper namespace and opened automatically

## API Functions

For advanced usage:

```lua
local config = require('dotnet-craft.config')

-- Add a custom template
config.add_template("Template Name", "template content")

-- Get all templates (built-in + custom)
local all_templates = config.get_all_templates()

-- Get current configuration
local cfg = config.get()

-- Update a specific value
config.set_value("ui.width", 80)

-- Reset to defaults
config.reset()
```
