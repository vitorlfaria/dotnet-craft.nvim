local M = {}

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

M["Abstract Class"] = [[
namespace {{namespace}};

public abstract class {{name}}
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

M["Record Struct"] = [[
namespace {{namespace}};

public record struct {{name}}
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
namespace {{namespace}};

[ApiController]
[Route("[controller]")]
[Produces("application/json")]
public class {{name}} : ControllerBase
{
}
]]

M["Minimal Api Controller"] = [[
namespace {{namespace}};

[ApiController]
[Route("api/[controller]")]
public class {{name}} : ControllerBase
{
    [HttpGet]
    public IActionResult Get()
    {
        return Ok();
    }
}
]]

M["Exception"] = [[
namespace {{namespace}};

public class {{name}} : Exception
{
    public {{name}}()
    {
    }

    public {{name}}(string message) : base(message)
    {
    }

    public {{name}}(string message, Exception innerException) : base(message, innerException)
    {
    }
}
]]

M["Test Class"] = [[
namespace {{namespace}};

public class {{name}}
{
    [Fact]
    public void Test1()
    {
        // Arrange
        
        // Act
        
        // Assert
    }
}
]]

return M
