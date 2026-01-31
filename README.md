# get-env-vars

A GitHub Action that fetches environment variables from a repository environment using the `gh` CLI and exports them into the workflow environment. It also writes results to files.

Important workspace files:
- [`action.yml`](action.yml)
- [`index.js`](index.js) (contains the [`run`](index.js) entry)
- [`script.sh`](script.sh)
- [`package.json`](package.json)

## Features
- Retrieves environment variables for one or more environments using `gh variable list`.
- Supports multiple environments by providing a comma-separated list (e.g., "development,staging").
- Creates separate output files for each environment (e.g., `development.json`, `staging.json`).
- Supports three file types: `json` (default), `txt`, and `csv`.
- Exports each variable into the workflow environment via `$GITHUB_ENV`.
- If repo name is not given, by default it will fetch environment variables from the current repository in which the workflow is executed.

## Prerequisites
- The runner must have the GitHub CLI (`gh`) installed and authenticated.
- `jq` must be available on the runner (used to parse JSON).
- The action uses Node (`node20`) via [`action.yml`](action.yml).

## Inputs
All inputs are defined in [`action.yml`](action.yml).

- [`repo`](action.yml) (optional, default: `${{ github.repository }}`)
  - Description: Repository to query for environment variables (format: `owner/repo`). If not provided, defaults to the current repository where the workflow is executed.
- [`env_name`](action.yml) (required)
  - Description: The name(s) of the environment(s) to read variables from. Supports multiple environments as a comma-separated list (e.g., "development,staging"). For each environment, a separate file will be created.
- [`gh_token`](action.yml) (required)
  - Description: GitHub token used by `gh` for authentication (pass via secrets).
- [`file_type`](action.yml) (optional, default: `json`)
  - Description: Output file format. Supported values: `json`, `txt`, or `csv`. If not provided, defaults to `json` and generates files in the root folder.

## Outputs / Side effects
- For each environment specified, creates a separate file in the root folder (e.g., `development.json`, `staging.json`).
  - `json`: JSON array with the result of `gh variable list`.
  - `txt`: Text file with `NAME=VALUE` lines.
  - `csv`: CSV file with columns for name and value.
- Exports each variable to the workflow environment by appending `NAME=VALUE` lines to `$GITHUB_ENV` (so subsequent steps can read them).

## Example usage
Use the action from the same repository (local action):
```yaml
- name: Get environment variables
  uses: Sumit007521/get-env-vars@v1
  with:
    repo: "owner/repo"                      # optional, defaults to current repo    
    env_name: "development,staging"         # required, comma-separated for multiple
    gh_token: ${{ secrets.GITHUB_TOKEN }}   # required
    file_type: "json"                       # optional, defaults to json
