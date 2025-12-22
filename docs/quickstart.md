# Quick Start Guide

This guide will help you get started with Spec-Driven Development using RapidRapidSpec-Kit.

> [!NOTE]
> RapidRapidSpec-Kit includes complete 9-phase automation with all scripts in both Bash (`.sh`) and PowerShell (`.ps1`) variants. The `specify` CLI auto-selects based on OS unless you pass `--script sh|ps`.

## The 9-Phase RapidSpec Automation Workflow

> [!TIP]
> **Context Awareness**: RapidSpec-Kit commands automatically detect the active feature based on your current Git branch (e.g., `001-feature-name`). To switch between different specifications, simply switch Git branches.

### Step 1: Install Specify

**In your terminal**, run the `specify` CLI command to initialize your project:

```bash

# Create a new project directory

uvx --from git+https://github.com/benzntech/rapidspec-kit.git rapidspec init <PROJECT_NAME>

# OR initialize in the current directory

uvx --from git+https://github.com/benzntech/rapidspec-kit.git rapidspec init .

```text

Pick script type explicitly (optional):

```bash

uvx --from git+https://github.com/benzntech/rapidspec-kit.git rapidspec init <PROJECT_NAME> --script ps  # Force PowerShell

uvx --from git+https://github.com/benzntech/rapidspec-kit.git rapidspec init <PROJECT_NAME> --script sh  # Force POSIX shell

```text

### Step 2: Define Your Constitution

**In your AI Agent's chat interface**, use the `/rapidspec.constitution` slash command to establish the core rules and principles for your project. You should provide your project's specific principles as arguments.

```markdown

/rapidspec.constitution This project follows a "Library-First" approach. All features must be implemented as standalone libraries first. We use TDD strictly. We prefer functional programming patterns.

```text

### Step 3: Create the Spec

**In the chat**, use the `/rapidspec.specify` slash command to describe what you want to build. Focus on the **what** and **why**, not the tech stack.

```markdown

/rapidspec.specify Build an application that can help me organize my photos in separate photo albums. Albums are grouped by date and can be re-organized by dragging and dropping on the main page. Albums are never in other nested albums. Within each album, photos are previewed in a tile-like interface.

```text

### Step 4: Research Tech Stack Options

**In the chat**, use the `/rapidspec.research` slash command to conduct web research and gather evidence for technical decisions.

```markdown

/rapidspec.research

```text

### Step 5: Verify Existing Code (if brownfield)

**In the chat**, use the `/rapidspec.verify` slash command to verify actual code exists and detect frameworks.

```markdown

/rapidspec.verify

```text

### Step 6: Generate Implementation Approaches

**In the chat**, use the `/rapidspec.options` slash command to have AI generate 2-3 implementation approaches.

```markdown

/rapidspec.options

```text

### Step 7: Create Technical Implementation Plan

**In the chat**, use the `/rapidspec.plan` slash command to provide your tech stack and architecture choices.

```markdown

/rapidspec.plan The application uses Vite with minimal number of libraries. Use vanilla HTML, CSS, and JavaScript as much as possible. Images are not uploaded anywhere and metadata is stored in a local SQLite database.

```text

### Step 8: Generate Tasks and Apply Implementation

**In the chat**, use the `/rapidspec.tasks` slash command to create an actionable task list, then `/rapidspec.apply` to implement with checkpoints.

```markdown

/rapidspec.tasks

```text

Then apply implementation:

```markdown

/rapidspec.apply

```text

### Step 9: Quality Review

**In the chat**, use the `/rapidspec.review` slash command for multi-agent quality review.

```markdown

/rapidspec.review

```text

### Step 10: Create Commits and PR

**In the chat**, use the `/rapidspec.commit` slash command to generate conventional commits and create PR.

```markdown

/rapidspec.commit

```text

### Step 11: Archive and Deploy

**In the chat**, use the `/rapidspec.archive` slash command to archive completed work and merge specs.

```markdown

/rapidspec.archive

```text

## Detailed Example: Building Taskify

Here's a complete example of building a team productivity platform:

### Step 1: Define Constitution

Initialize the project's constitution to set ground rules:

```markdown

/rapidspec.constitution Taskify is a "Security-First" application. All user inputs must be validated. We use a microservices architecture. Code must be fully documented.

```text

### Step 2: Define Requirements with `/rapidspec.specify`

```text

Develop Taskify, a team productivity platform. It should allow users to create projects, add team members,
assign tasks, comment and move tasks between boards in Kanban style. In this initial phase for this feature,
let's call it "Create Taskify," let's have multiple users but the users will be declared ahead of time, predefined.
I want five users in two different categories, one product manager and four engineers. Let's create three
different sample projects. Let's have the standard Kanban columns for the status of each task, such as "To Do,"
"In Progress," "In Review," and "Done." There will be no login for this application as this is just the very
first testing thing to ensure that our basic features are set up.

```text

### Step 3: Research Tech Stack Options

Research different technology approaches:

```bash

/rapidspec.research

```text

### Step 4: Generate Implementation Approaches

Let AI generate multiple implementation approaches:

```bash

/rapidspec.options

```text

### Step 5: Generate Technical Plan with `/rapidspec.plan`

Be specific about your tech stack and technical requirements:

```bash

/rapidspec.plan We are going to generate this using .NET Aspire, using Postgres as the database. The frontend should use Blazor server with drag-and-drop task boards, real-time updates. There should be a REST API created with a projects API, tasks API, and a notifications API.

```text

### Step 6: Apply Implementation with Checkpoints

Generate tasks and apply implementation:

```bash

/rapidspec.tasks
/rapidspec.apply

```text

### Step 7: Quality Review

Run multi-agent quality review:

```bash

/rapidspec.review

```text

### Step 8-9: Create Commits and Archive

Create commits and PR, then archive completed work:

```bash

/rapidspec.commit
/rapidspec.archive

```text

## Key Principles

- **Be explicit** about what you're building and why

- **Don't focus on tech stack** during specification phase

- **Research tech options** before making architecture decisions

- **Verify existing code** before planning changes (brownfield projects)

- **Generate multiple approaches** to compare trade-offs

- **Get checkpoints approved** before implementing code

- **Run quality review** before creating commits

- **Let the AI agents handle** the implementation details

## Next Steps

- Read the [complete methodology](../spec-driven.md) for in-depth guidance

- Check out [more examples](../templates) in the repository

- Explore the [TOOLS.md](../TOOLS.md) for comprehensive command reference

- Visit the [RapidRapidSpec-Kit repository](https://github.com/benzntech/rapidspec-kit)
