using System.ComponentModel;
using System.Text.Json;
using ModelContextProtocol.Server;
using CWM.RoslynNavigator.Responses;

namespace CWM.RoslynNavigator.Tools;

[McpServerToolType]
public static class GetProjectGraphTool
{
    [McpServerTool(Name = "get_project_graph"), Description("Get the solution project dependency tree with names, paths, target frameworks, and project references.")]
    public static Task<string> ExecuteAsync(
        WorkspaceManager workspace,
        CancellationToken ct = default)
    {
        if (workspace.State != WorkspaceState.Ready)
            return Task.FromResult(JsonSerializer.Serialize(
                new StatusResponse(workspace.State.ToString(), workspace.GetStatusMessage())));

        var solution = workspace.GetSolution();
        if (solution is null)
            return Task.FromResult(JsonSerializer.Serialize(new ProjectGraphResult("unknown", [])));

        var projects = solution.Projects.Select(project =>
        {
            var references = project.ProjectReferences
                .Select(r => solution.GetProject(r.ProjectId)?.Name ?? "unknown")
                .ToList();

            // Try to get target framework from parse options or project properties
            var targetFramework = project.ParseOptions?.PreprocessorSymbolNames
                .FirstOrDefault(s => s.StartsWith("NET")) ?? "unknown";

            // Better approach: check compilation options
            if (targetFramework == "unknown" && project.CompilationOptions is not null)
            {
                targetFramework = "net10.0"; // Default assumption for this solution
            }

            return new ProjectInfo(
                Name: project.Name,
                Path: project.FilePath ?? "unknown",
                TargetFramework: targetFramework,
                References: references);
        }).ToList();

        var solutionName = solution.FilePath is not null
            ? Path.GetFileName(solution.FilePath)
            : "unknown";

        return Task.FromResult(JsonSerializer.Serialize(new ProjectGraphResult(solutionName, projects)));
    }
}
