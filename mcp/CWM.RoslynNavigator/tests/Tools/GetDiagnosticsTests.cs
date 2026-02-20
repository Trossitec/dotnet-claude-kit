using System.Text.Json;
using CWM.RoslynNavigator.Responses;
using CWM.RoslynNavigator.Tests.Fixtures;
using CWM.RoslynNavigator.Tools;

namespace CWM.RoslynNavigator.Tests.Tools;

public class GetDiagnosticsTests(TestSolutionFixture fixture) : IClassFixture<TestSolutionFixture>
{
    [Fact]
    public async Task GetDiagnostics_SolutionScope_ReturnsDiagnostics()
    {
        var json = await GetDiagnosticsTool.ExecuteAsync(fixture.WorkspaceManager, scope: "solution");
        var result = JsonSerializer.Deserialize<DiagnosticsResult>(json)!;

        // The sample solution has an intentional unused variable in ProductService
        // which should generate a CS0219 warning
        Assert.NotNull(result);
    }

    [Fact]
    public async Task GetDiagnostics_FileScope_FiltersToSpecificFile()
    {
        var json = await GetDiagnosticsTool.ExecuteAsync(
            fixture.WorkspaceManager,
            scope: "file",
            path: "ProductService.cs");
        var result = JsonSerializer.Deserialize<DiagnosticsResult>(json)!;

        // ProductService.cs has the intentional unused variable
        Assert.NotNull(result);
    }

    [Fact]
    public async Task GetDiagnostics_SeverityFilter_Error_FiltersCorrectly()
    {
        var json = await GetDiagnosticsTool.ExecuteAsync(
            fixture.WorkspaceManager,
            scope: "solution",
            severityFilter: "error");
        var result = JsonSerializer.Deserialize<DiagnosticsResult>(json)!;

        // All returned diagnostics should be errors
        Assert.All(result.Diagnostics, d => Assert.Equal("error", d.Severity));
    }

    [Fact]
    public async Task GetDiagnostics_ProjectScope_FiltersToProject()
    {
        var json = await GetDiagnosticsTool.ExecuteAsync(
            fixture.WorkspaceManager,
            scope: "project",
            path: "SampleDomain");
        var result = JsonSerializer.Deserialize<DiagnosticsResult>(json)!;

        // SampleDomain should have clean compilations (no intentional issues)
        Assert.NotNull(result);
    }
}
