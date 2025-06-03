[![Manual SonarQube Analysis for Pre-Built Project - Automatic Analysis Disabled](https://github.com/diego4bits/quality-actions/actions/workflows/test-sonarqube.yml/badge.svg)](https://github.com/diego4bits/quality-actions/actions/workflows/test-sonarqube.yml)


[![Dependency-Check – Test run](https://github.com/diego4bits/quality-actions/actions/workflows/test-dependency-check.yaml/badge.svg)](https://github.com/diego4bits/quality-actions/actions/workflows/test-dependency-check.yaml)

# Quality Assurance Workflows for Java Projects

## Table of Contents

* [Overview](#overview)
* [Prerequisites](#prerequisites)
* [OWASP Dependency-Check Integration](#owasp-dependency-check-integration)

  * [Custom GitHub Action (`dependency-check`)](#custom-github-action-dependency-check)

    * [Inputs](#inputs)
    * [Outputs](#outputs)
    * [Permissions](#permissions)
    * [Usage Example](#usage-example)
  * [Workflow Example (`test-dependency-check.yaml`)](#workflow-example-test-dependency-checkyaml)
* [SonarQube Static Code Analysis](#sonarqube-static-code-analysis)

  * [Workflow (`test-sonarqube.yml`)](#workflow-test-sonarqubeyml)

    * [Setup Steps](#setup-steps)
    * [`sonar-project.properties` Configuration](#sonar-projectproperties-configuration)
    * [Environment Variables and Secrets](#environment-variables-and-secrets)
    * [Runner Requirements](#runner-requirements)
* [Checkmarx Scan (Future Consideration)](#checkmarx-scan-future-consideration)
* [Build Status in GitHub](#build-status-in-github)

  * [Automatic Status Updates](#automatic-status-updates)
  * [Workflow Status Badges](#workflow-status-badges)
* [References](#references)

---

## Overview

This repository provides GitHub Actions workflows for integrating automated quality assurance into Java projects. The primary tools used are:

* **OWASP Dependency-Check**: Identifies vulnerabilities in project dependencies.
* **SonarQube**: Static code analysis to detect bugs, vulnerabilities, and code quality issues.

Workflows are designed for manual execution (`workflow_dispatch`).

## Prerequisites

Ensure you have:

* A **GitHub repository** hosting your Java project.
* A Java project structure using Maven.

For SonarQube integration:

* Access to a SonarQube server instance.
* SonarQube project key, name, and authentication token (`SONAR_TOKEN`).

## OWASP Dependency-Check Integration

OWASP Dependency-Check scans for known vulnerabilities in project dependencies using a custom GitHub Action.

### Custom GitHub Action (`dependency-check`)

* **Source Directory**: `.github/actions/dependency-check/`
* **Key Files**:

  * `action.yml`: Defines inputs and outputs.
  * `entrypoint.sh`: Executes the dependency check scan.

#### Inputs

| Input       | Description                                         | Required |
| ----------- | --------------------------------------------------- | -------- |
| `scan-args` | Arguments passed directly to `dependency-check.sh`. | Yes      |

**Usage Example:**

```yaml
scan-args: |
  --noupdate
  --disableRetireJS
  --scan '**/target/*.jar'
  --format HTML
  --format JSON
  --format XML
  --out report
  --propertyfile ./dependency-check.properties
  --nodeAuditSkipDevDependencies
  --log report/dc.log
  --suppression ./exclusions.xml
```

#### Outputs

| Output        | Description                                  |
| ------------- | -------------------------------------------- |
| `report-path` | Directory or file path of generated reports. |

#### Permissions

```yaml
permissions: write-all
```

#### Usage Example

```yaml
- name: OWASP Dependency-Check
  uses: ./.github/actions/dependency-check
  with:
    scan-args: |
      --disableRetireJS
      --scan "**/*.java"
      --format HTML
```

### Workflow Example (`test-dependency-check.yaml`)

Trigger: `workflow_dispatch` (manual)

```yaml
steps:
  - name: Checkout repository
    uses: actions/checkout@v4

  - name: OWASP Dependency-Check
    uses: ./.github/actions/dependency-check
    with:
      scan-args: |
        --disableRetireJS
        --scan "**/*.java"
        --format HTML
```

## SonarQube Static Code Analysis

Uses the official SonarQube Scan action.

### Workflow (`test-sonarqube.yml`)

Trigger: `workflow_dispatch`

#### Setup Steps

1. Checkout repository:

```yaml
- uses: actions/checkout@v4
  with:
    fetch-depth: 0
```

2. Set up JDK 17:

```yaml
- uses: actions/setup-java@v4
  with:
    java-version: '17'
    distribution: 'temurin'
```

3. Create `sonar-project.properties`:

```yaml
- name: Create sonar-project.properties
  run: |
    echo "sonar.projectKey=${{ env.WORKFLOW_SONAR_PROJECT_KEY }}" > sonar-project.properties
    echo "sonar.projectName=${{ env.WORKFLOW_SONAR_PROJECT_NAME }}" >> sonar-project.properties
    echo "sonar.projectVersion=${{ env.WORKFLOW_SONAR_PROJECT_VERSION }}" >> sonar-project.properties
    echo "sonar.sources=main/java" >> sonar-project.properties
    echo "sonar.tests=test/java" >> sonar-project.properties
    echo "sonar.java.binaries=target/" >> sonar-project.properties
    echo "sonar.sourceEncoding=UTF-8" >> sonar-project.properties
```

4. Run SonarQube Scan:

```yaml
- uses: SonarSource/sonarqube-scan-action@master
  env:
    SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
```

#### `sonar-project.properties` Configuration

Key properties include:

* `sonar.projectKey`
* `sonar.projectName`
* `sonar.projectVersion`
* `sonar.sources`
* `sonar.tests`
* `sonar.java.binaries`
* `sonar.sourceEncoding`

#### Environment Variables and Secrets

| Type    | Name                             | Description               |
| ------- | -------------------------------- | ------------------------- |
| Env Var | `WORKFLOW_SONAR_PROJECT_KEY`     | SonarQube Project Key     |
| Env Var | `WORKFLOW_SONAR_PROJECT_NAME`    | SonarQube Project Name    |
| Env Var | `WORKFLOW_SONAR_PROJECT_VERSION` | SonarQube Project Version |
| Secret  | `SONAR_TOKEN`                    | SonarQube token           |
| Secret  | `SONAR_HOST_URL`                 | SonarQube server URL      |

#### Runner Requirements

Ensure the following are installed on a self-hosted runner or container:

* `curl` or `wget`
* `unzip`

## Checkmarx Scan (Future Consideration)

Consider future integration using the [Checkmarx CxFlow Action](https://github.com/marketplace/actions/checkmarx-cxflow-action).

## Build Status in GitHub

### Automatic Status Updates

GitHub automatically updates statuses based on workflow results.

### Workflow Status Badges

Include workflow status badges in `README.md`:

```markdown
[![SonarQube Analysis](https://github.com/diego4bits/quality-actions/actions/workflows/test-sonarqube.yml/badge.svg)](https://github.com/diego4bits/quality-actions/actions/workflows/test-sonarqube.yml)

[![Dependency-Check](https://github.com/diego4bits/quality-actions/actions/workflows/test-dependency-check.yaml/badge.svg)](https://github.com/diego4bits/quality-actions/actions/workflows/test-dependency-check.yaml)
```

## References

* [About Status Checks](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/about-status-checks)
* [Adding Workflow Status Badge](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/monitoring-workflows/adding-a-workflow-status-badge)
* [Official SonarQube Scan Action](https://github.com/marketplace/actions/official-sonarqube-scan)
* [Checkmarx CxFlow Action](https://github.com/marketplace/actions/checkmarx-cxflow-action)
* [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/)
