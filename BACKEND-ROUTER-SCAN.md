# Backend API Router Scan — Usage

Start Claude Code inside the repository you want to inspect.

```text
/ps-e2e-plan --role backend
/ps-e2e-plan W1 --role backend --target api --scope all-routes
```

**First command:** scans all discoverable HTTP routes in the current repository, whether or not a Wave has been defined. **Second command:** scans all discoverable routes while labeling those mapped to W1 acceptance criteria and identifying routes outside/unmapped to the Wave.

To focus a router registration file explicitly:

```text
/ps-e2e-plan --role backend --router-file src/routes/api.ts
```

Replace that path with your actual router file; file-scoped discovery cannot prove that all repository endpoints were found.

## Expected deliverables

1. API inventory: HTTP method + fully mounted effective URL path + registration source + confidence.
2. Scenario matrix per endpoint: happy path, validation, auth/authorization and contract/error cases when relevant and supported by code/spec.
3. Coverage matrix: verified routes, discovered-with-uncertainty routes, proposed scenarios, preexisting tests, unknown contracts and traceability gaps.
4. Human approval checkpoint before test file creation or execution.

No test results are claimed before Playwright actually runs. Static discovery can miss dynamic registrations; these must be reported, not made up. Router scans are read-only; API calls/mutations require separate approval and a safe non-production environment.
