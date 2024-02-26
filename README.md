# Get Soonest Available Runner

This action checks if a self-hosted runner is available using the Github API and if it is not, sets the depending on actions to use the alternate runner (a github hosted runner in my sample). It will first look for runners at the repo level, and if not found, automatically check at the org level.

## Usage example:

```yaml
 determine-runner-integration:
    name: Determine which runner to use for integration tests
    runs-on: ubuntu-latest
    outputs:
      runner: ${{ steps.set-runner.outputs.runner }}
    steps:
      - name: Determine which runner to use
        id: set-runner
        uses: benjaminmichaelis/get-soonest-available-runner@v1.1.0
        with:
          primary-runner: "self-hosted"
          fallback-runner: "ubuntu-latest"
          # This correlates to the number of free runners that must exist when the API queries.
          # Increasing this can help in case you have lots of actions querying at the same time for a race condition between the time you query the runner and when the runner actually takes the job it will execute.
          min-available-runners: 2
          github-token: ${{ secrets.GHTOKEN_DETERMINERUNNER }} # This token must have permissions to query the runner from your repo or organization (whichever you are looking for)

  test-csharp-integration:
    name: Run C# Integration Tests
    needs: determine-runner-integration
    runs-on: ${{ needs.determine-runner-integration.outputs.runner }}
    ...
```
