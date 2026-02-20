using System.Text.Json;
using CWM.RoslynNavigator.Responses;
using CWM.RoslynNavigator.Tests.Fixtures;
using CWM.RoslynNavigator.Tools;

namespace CWM.RoslynNavigator.Tests.Tools;

public class FindSymbolTests(TestSolutionFixture fixture) : IClassFixture<TestSolutionFixture>
{
    [Fact]
    public async Task FindSymbol_Class_ReturnsCorrectLocation()
    {
        var json = await FindSymbolTool.ExecuteAsync(fixture.WorkspaceManager, "Order", "class");
        var result = JsonSerializer.Deserialize<SymbolSearchResult>(json)!;

        Assert.NotEmpty(result.Symbols);
        Assert.Contains(result.Symbols, s => s.Name == "Order" && s.Kind == "class");
    }

    [Fact]
    public async Task FindSymbol_Interface_ReturnsCorrectKind()
    {
        var json = await FindSymbolTool.ExecuteAsync(fixture.WorkspaceManager, "IOrderRepository", "interface");
        var result = JsonSerializer.Deserialize<SymbolSearchResult>(json)!;

        Assert.Single(result.Symbols);
        Assert.Equal("interface", result.Symbols[0].Kind);
        Assert.Equal("SampleDomain", result.Symbols[0].Namespace);
    }

    [Fact]
    public async Task FindSymbol_Method_ReturnsMethodKind()
    {
        var json = await FindSymbolTool.ExecuteAsync(fixture.WorkspaceManager, "Cancel", "method");
        var result = JsonSerializer.Deserialize<SymbolSearchResult>(json)!;

        Assert.NotEmpty(result.Symbols);
        Assert.Contains(result.Symbols, s => s.Kind == "method");
    }

    [Fact]
    public async Task FindSymbol_Nonexistent_ReturnsEmpty()
    {
        var json = await FindSymbolTool.ExecuteAsync(fixture.WorkspaceManager, "NonExistentType12345");
        var result = JsonSerializer.Deserialize<SymbolSearchResult>(json)!;

        Assert.Empty(result.Symbols);
    }

    [Fact]
    public async Task FindSymbol_Enum_ReturnsEnumKind()
    {
        var json = await FindSymbolTool.ExecuteAsync(fixture.WorkspaceManager, "OrderStatus", "enum");
        var result = JsonSerializer.Deserialize<SymbolSearchResult>(json)!;

        Assert.Single(result.Symbols);
        Assert.Equal("enum", result.Symbols[0].Kind);
    }

    [Fact]
    public async Task FindSymbol_Record_ReturnsRecordKind()
    {
        var json = await FindSymbolTool.ExecuteAsync(fixture.WorkspaceManager, "OrderItem", "record");
        var result = JsonSerializer.Deserialize<SymbolSearchResult>(json)!;

        Assert.NotEmpty(result.Symbols);
    }
}
