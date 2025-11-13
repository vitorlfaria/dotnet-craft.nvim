-- lua/dotnet-craft/templates.lua
local M = {}

-- Note: {{namespace}} will be just the namespace name (e.g., "MyApp.Models")
-- We add the "namespace" keyword and semicolon in the template

M["Class"] = [[
namespace {{namespace}};

public class {{name}}
{
}
]]

M["Sealed Class"] = [[
namespace {{namespace}};

public sealed class {{name}}
{
}
]]

M["Static Class"] = [[
namespace {{namespace}};

public static class {{name}}
{
}
]]

M["Interface"] = [[
namespace {{namespace}};

public interface {{name}}
{
}
]]

M["Record"] = [[
namespace {{namespace}};

public record {{name}}
{
}
]]

M["Sealed Record"] = [[
namespace {{namespace}};

public sealed record {{name}}
{
}
]]

M["Enum"] = [[
namespace {{namespace}};

public enum {{name}}
{
}
]]

M["Struct"] = [[
namespace {{namespace}};

public struct {{name}}
{
}
]]

M["Api Controller"] = [[
using Microsoft.AspNetCore.Mvc;

namespace {{namespace}};

[ApiController]
[Route("[controller]")]
[Produces("application/json")]
public class {{name}} : ControllerBase
{
}
]]

return M
