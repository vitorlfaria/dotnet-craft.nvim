local M = {}

M["Class"] = [[
{{namespace}};

public class {{name}}
{
}
]]

M["Sealed Class"] = [[
{{namespace}};

public sealed class {{name}}
{
}
]]

M["Static Class"] = [[
{{namespace}};

public static class {{name}}
{
}
]]

M["Interface"] = [[
{{namespace}};

public interface {{name}}
{
}
]]

M["Record"] = [[
{{namespace}};

public record {{name}}
{
}
]]

M["Sealed Record"] = [[
{{namespace}};

public sealed record {{name}}
{
}
]]

M["Enum"] = [[
{{namespace}};

public enum {{name}}
{
}
]]

M["Struct"] = [[
{{namespace}};

public struct {{name}}
{
}
]]

M["Api Controller"] = [[
using Microsoft.AspNetCore.Mvc;

{{namespace}};

[ApiController]
[Route("[controller]")]
[Produces("application/json")]
public class {{name}} : ControllerBase
{
}
]]

return M
