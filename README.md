<div align="center">
    <img src="./media/logo_large.webp" alt="RapidSpec-Kit Logo" width="200" height="200"/>
    <h1>🌱 RapidSpec-Kit</h1>
    <h3><em>Build high-quality software faster.</em></h3>
</div>

<p align="center">
    <strong>An open source toolkit that allows you to focus on product scenarios and predictable outcomes instead of vibe coding every piece from scratch.</strong>
</p>

<p align="center">
    <a href="https://github.com/benzntech/rapidspec-kit/actions/workflows/release.yml"><img src="https://img.shields.io/github/actions/workflow/status/benzntech/rapidspec-kit/release.yml?branch=main&label=Build" alt="Build"/></a>
    <a href="https://github.com/benzntech/rapidspec-kit/stargazers"><img src="https://img.shields.io/github/stars/benzntech/rapidspec-kit?style=social" alt="GitHub stars"/></a>
    <a href="https://github.com/benzntech/rapidspec-kit/blob/main/LICENSE"><img src="https://img.shields.io/github/license/benzntech/rapidspec-kit" alt="License"/></a>
    <a href="https://github.com/benzntech/rapidspec-kit"><img src="https://img.shields.io/badge/repo-RapidSpec--Kit-blue" alt="Repository"/></a>
</p>

---

## Table of Contents

- [🤔 What is Spec-Driven Development?](#-what-is-spec-driven-development)
- [⚡ Get Started](#-get-started)
- [🤖 Supported AI Agents](#-supported-ai-agents)
- [🔧 Specify CLI Reference](#-specify-cli-reference)
- [📚 Core Philosophy](#-core-philosophy)
- [🌟 Development Phases](#-development-phases)
- [🎯 Experimental Goals](#-experimental-goals)
- [🔧 Prerequisites](#-prerequisites)
- [📖 Learn More](#-learn-more)
- [📋 Detailed Process](#-detailed-process)
- [🔍 Troubleshooting](#-troubleshooting)
- [👥 Maintainers](#-maintainers)
- [💬 Support](#-support)
- [🙏 Acknowledgements](#-acknowledgements)
- [📄 License](#-license)

## 🤔 What is Spec-Driven Development?

Spec-Driven Development **flips the script** on traditional software development. For decades, code has been king — specifications were just scaffolding we built and discarded once the "real work" of coding began. Spec-Driven Development changes this: **specifications become executable**, directly generating working implementations rather than just guiding them.

## ⚡ Get Started

### 1. Install Specify CLI

Choose your preferred installation method:

#### Option 1: Persistent Installation (Recommended)

Install once and use everywhere:

```bash
uv tool install rapidspec-cli --from git+https://github.com/benzntech/rapidspec-kit.git
```

Then use the tool directly:

```bash
# Create new project
rapidspec init <PROJECT_NAME>

# Or initialize in existing project
rapidspec init . --ai claude
# or
rapidspec init --here --ai claude

# Check installed tools
rapidspec check
```

To upgrade Specify, see the [Upgrade Guide](./docs/upgrade.md) for detailed instructions. Quick upgrade:

```bash
uv tool install rapidspec-cli --force --from git+https://github.com/benzntech/rapidspec-kit.git
```

#### Option 2: One-time Usage

Run directly without installing:

```bash
uvx --from git+https://github.com/benzntech/rapidspec-kit.git rapidspec init <PROJECT_NAME>
```

**Benefits of persistent installation:**

- Tool stays installed and available in PATH
- No need to create shell aliases
- Better tool management with `uv tool list`, `uv tool upgrade`, `uv tool uninstall`
- Cleaner shell configuration

### 2. Establish project principles

Launch your AI assistant in the project directory. The `/rapidspec.*` commands are available in the assistant.

Use the **`/rapidspec.constitution`** command to create your project's governing principles and development guidelines that will guide all subsequent development.

```bash
/rapidspec.constitution Create principles focused on code quality, testing standards, user experience consistency, and performance requirements
```

### 3. Create the spec

Use the **`/rapidspec.specify`** command to describe what you want to build. Focus on the **what** and **why**, not the tech stack.

```bash
/rapidspec.specify Build an application that can help me organize my photos in separate photo albums. Albums are grouped by date and can be re-organized by dragging and dropping on the main page. Albums are never in other nested albums. Within each album, photos are previewed in a tile-like interface.
```

### 4. Create a technical implementation plan

Use the **`/rapidspec.plan`** command to provide your tech stack and architecture choices.

```bash
/rapidspec.plan The application uses Vite with minimal number of libraries. Use vanilla HTML, CSS, and JavaScript as much as possible. Images are not uploaded anywhere and metadata is stored in a local SQLite database.
```

### 5. Break down into tasks

Use **`/rapidspec.tasks`** to create an actionable task list from your implementation plan.

```bash
/rapidspec.tasks
```

### 6. Execute implementation

Use **`/rapidspec.implement`** to execute all tasks and build your feature according to the plan.

```bash
/rapidspec.implement
```

For detailed step-by-step instructions, see our [comprehensive guide](./spec-driven.md).

## 🤖 Supported AI Agents

| Agent                                                                                | Support | Notes                                                                                                                                     |
| ------------------------------------------------------------------------------------ | ------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| [Qoder CLI](https://qoder.com/cli)                                                   | ✅      |                                                                                                                                           |
| [Amazon Q Developer CLI](https://aws.amazon.com/developer/learning/q-developer-cli/) | ⚠️      | Amazon Q Developer CLI [does not support](https://github.com/aws/amazon-q-developer-cli/issues/3064) custom arguments for slash commands. |
| [Amp](https://ampcode.com/)                                                          | ✅      |                                                                                                                                           |
| [Auggie CLI](https://docs.augmentcode.com/cli/overview)                              | ✅      |                                                                                                                                           |
| [Claude Code](https://www.anthropic.com/claude-code)                                 | ✅      |                                                                                                                                           |
| [CodeBuddy CLI](https://www.codebuddy.ai/cli)                                        | ✅      |                                                                                                                                           |
| [Codex CLI](https://github.com/openai/codex)                                         | ✅      |                                                                                                                                           |
| [Cursor](https://cursor.sh/)                                                         | ✅      |                                                                                                                                           |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli)                            | ✅      |                                                                                                                                           |
| [GitHub Copilot](https://code.visualstudio.com/)                                     | ✅      |                                                                                                                                           |
| [IBM Bob](https://www.ibm.com/products/bob)                                          | ✅      | IDE-based agent with slash command support                                                                                                |
| [Jules](https://jules.google.com/)                                                   | ✅      |                                                                                                                                           |
| [Kilo Code](https://github.com/Kilo-Org/kilocode)                                    | ✅      |                                                                                                                                           |
| [opencode](https://opencode.ai/)                                                     | ✅      |                                                                                                                                           |
| [Qwen Code](https://github.com/QwenLM/qwen-code)                                     | ✅      |                                                                                                                                           |
| [Roo Code](https://roocode.com/)                                                     | ✅      |                                                                                                                                           |
| [SHAI (OVHcloud)](https://github.com/ovh/shai)                                       | ✅      |                                                                                                                                           |
| [Windsurf](https://windsurf.com/)                                                    | ✅      |                                                                                                                                           |

## 🔧 Specify CLI Reference

The `rapidspec` command supports the following options:

### Commands

| Command | Description                                                                                                                                             |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `init`  | Initialize a new RapidSpec project from the latest template                                                                                            |
| `check` | Check for installed tools (`git`, `claude`, `gemini`, `code`/`code-insiders`, `cursor-agent`, `windsurf`, `qwen`, `opencode`, `codex`, `shai`, `qoder`) |

### `rapidspec init` Arguments & Options

| Argument/Option        | Type     | Description                                                                                                                                                                                  |
| ---------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `<project-name>`       | Argument | Name for your new project directory (optional if using `--here`, or use `.` for current directory)                                                                                           |
| `--ai`                 | Option   | AI assistant to use: `claude`, `gemini`, `copilot`, `cursor-agent`, `qwen`, `opencode`, `codex`, `windsurf`, `kilocode`, `auggie`, `roo`, `codebuddy`, `amp`, `shai`, `q`, `bob`, or `qoder` |
| `--script`             | Option   | Script variant to use: `sh` (bash/zsh) or `ps` (PowerShell)                                                                                                                                  |
| `--ignore-agent-tools` | Flag     | Skip checks for AI agent tools like Claude Code                                                                                                                                              |
| `--no-git`             | Flag     | Skip git repository initialization                                                                                                                                                           |
| `--here`               | Flag     | Initialize project in the current directory instead of creating a new one                                                                                                                    |
| `--force`              | Flag     | Force merge/overwrite when initializing in current directory (skip confirmation)                                                                                                             |
| `--skip-tls`           | Flag     | Skip SSL/TLS verification (not recommended)                                                                                                                                                  |
| `--debug`              | Flag     | Enable detailed debug output for troubleshooting                                                                                                                                             |
| `--github-token`       | Option   | GitHub token for API requests (or set GH_TOKEN/GITHUB_TOKEN env variable)                                                                                                                    |

### Examples

```bash
# Basic project initialization
rapidspec init my-project

# Initialize with specific AI assistant
rapidspec init my-project --ai claude
rapidspec init my-project --ai gemini
rapidspec init my-project --ai copilot

# Initialize in current directory
rapidspec init . --ai copilot
# or use the --here flag
rapidspec init --here --ai copilot

# Force merge into current (non-empty) directory without confirmation
rapidspec init . --force --ai copilot
# or
rapidspec init --here --force --ai copilot

# Skip git initialization
rapidspec init my-project --ai gemini --no-git

# Enable debug output for troubleshooting
rapidspec init my-project --ai claude --debug

# Use GitHub token for API requests (helpful for corporate environments)
rapidspec init my-project --ai claude --github-token ghp_your_token_here

# Check system requirements
rapidspec check
```

### Available Slash Commands

After running `rapidspec init`, your AI coding agent will have access to these slash commands for structured development:

#### Core Commands

Essential commands for the Spec-Driven Development workflow:

| Command                    | Description                                                              |
| -------------------------- | ------------------------------------------------------------------------ |
| `/rapidspec.constitution`  | Create or update project governing principles and development guidelines |
| `/rapidspec.specify`       | Define what you want to build (requirements and user stories)            |
| `/rapidspec.plan`          | Create technical implementation plans with your chosen tech stack        |
| `/rapidspec.tasks`         | Generate actionable task lists for implementation                        |
| `/rapidspec.implement`     | Execute all tasks to build the feature according to the plan             |

#### Optional Commands

Additional commands for enhanced quality and validation:

| Command              | Description                                                                                                                          |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `/rapidspec.clarify` | Clarify underspecified areas (recommended before `/rapidspec.plan`)                                                                   |
| `/rapidspec.analyze` | Cross-artifact consistency & coverage analysis (run after `/rapidspec.tasks`, before `/rapidspec.implement`)                        |
| `/rapidspec.review`  | Comprehensive agent reviews (optional) - quality review after implementation                                                         |

#### Memory Bank Commands (v0.2.0+)

Project context tracking and decision logging:

| Command              | Description                                                                                                                          |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `/rapidspec.constitution` | Initialize and manage project memory bank with intelligent analysis                                                               |
| `/rapidspec.umb`     | Update memory bank during development sessions to track decisions and progress                                                       |

## 📚 Core Philosophy

Spec-Driven Development is a structured process that emphasizes:

- **Intent-driven development** where specifications define the "*what*" before the "*how*"
- **Rich specification creation** using guardrails and organizational principles
- **Multi-step refinement** rather than one-shot code generation from prompts
- **Heavy reliance** on advanced AI model capabilities for specification interpretation

## 🌟 Development Phases

| Phase                                    | Focus                    | Key Activities                                                                                                                                                     |
| ---------------------------------------- | ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **0-to-1 Development** ("Greenfield")    | Generate from scratch    | <ul><li>Start with high-level requirements</li><li>Generate specifications</li><li>Plan implementation steps</li><li>Build production-ready applications</li></ul> |
| **Creative Exploration**                 | Parallel implementations | <ul><li>Explore diverse solutions</li><li>Support multiple technology stacks & architectures</li><li>Experiment with UX patterns</li></ul>                         |
| **Iterative Enhancement** ("Brownfield") | Brownfield modernization | <ul><li>Add features iteratively</li><li>Modernize legacy systems</li><li>Adapt processes</li></ul>                                                                |

## 🎯 Experimental Goals

Our research and experimentation focus on:

### Technology independence

- Create applications using diverse technology stacks
- Validate the hypothesis that Spec-Driven Development is a process not tied to specific technologies, programming languages, or frameworks

### Enterprise constraints

- Demonstrate mission-critical application development
- Incorporate organizational constraints (cloud providers, tech stacks, engineering practices)
- Support enterprise design systems and compliance requirements

### User-centric development

- Build applications for different user cohorts and preferences
- Support various development approaches (from vibe-coding to AI-native development)

### Creative & iterative processes

- Validate the concept of parallel implementation exploration
- Provide robust iterative feature development workflows
- Extend processes to handle upgrades and modernization tasks

## 🔧 Prerequisites

- **Linux/macOS/Windows**
- [Supported](#-supported-ai-agents) AI coding agent.
- [uv](https://docs.astral.sh/uv/) for package management
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

If you encounter issues with an agent, please open an issue so we can refine the integration.

## 📖 Learn More

- **[Complete Spec-Driven Development Methodology](./spec-driven.md)** - Deep dive into the full process
- **[Detailed Walkthrough](#-detailed-process)** - Step-by-step implementation guide

---

## 📋 Detailed Process

<details>
<summary>Click to expand the detailed step-by-step walkthrough</summary>

You can use the Specify CLI to bootstrap your project, which will bring in the required artifacts in your environment. Run:

```bash
rapidspec init <project_name>
```

Or initialize in the current directory:

```bash
rapidspec init .
# or use the --here flag
rapidspec init --here
# Skip confirmation when the directory already has files
rapidspec init . --force
# or
rapidspec init --here --force
```

![Specify CLI bootstrapping a new project in the terminal](./media/specify_cli.gif)

You will be prompted to select the AI agent you are using. You can also proactively specify it directly in the terminal:

```bash
rapidspec init <project_name> --ai claude
rapidspec init <project_name> --ai gemini
rapidspec init <project_name> --ai copilot

# Or in current directory:
rapidspec init . --ai claude
rapidspec init . --ai codex

# or use --here flag
rapidspec init --here --ai claude
rapidspec init --here --ai codex

# Force merge into a non-empty current directory
rapidspec init . --force --ai claude

# or
rapidspec init --here --force --ai claude
```

The CLI will check if you have Claude Code, Gemini CLI, Cursor CLI, Qwen CLI, opencode, Codex CLI, Qoder CLI, or Amazon Q Developer CLI installed. If you do not, or you prefer to get the templates without checking for the right tools, use `--ignore-agent-tools` with your command:

```bash
rapidspec init <project_name> --ai claude --ignore-agent-tools
```

### **STEP 1:** Establish project principles

Go to the project folder and run your AI agent. In our example, we're using `claude`.

![Bootstrapping Claude Code environment](./media/bootstrap-claude-code.gif)

You will know that things are configured correctly if you see the `/rapidspec.constitution`, `/rapidspec.specify`, `/rapidspec.plan`, `/rapidspec.tasks`, and `/rapidspec.implement` commands available.

The first step should be establishing your project's governing principles using the `/rapidspec.constitution` command. This helps ensure consistent decision-making throughout all subsequent development phases:

```bash
/rapidspec.constitution Create principles focused on code quality, testing standards, user experience consistency, and performance requirements. Include governance for how these principles should guide technical decisions and implementation choices.
```

This step creates or updates the `.rapidspec/memory/constitution.md` file with your project's foundational guidelines that the AI agent will reference during specification, planning, and implementation phases.

### **STEP 2:** Create project specifications

With your project principles established, you can now create the functional specifications. Use the `/rapidspec.specify` command and then provide the concrete requirements for the project you want to develop.

> [!IMPORTANT]
> Be as explicit as possible about *what* you are trying to build and *why*. **Do not focus on the tech stack at this point**.

An example prompt:

```
Develop Taskify, a team productivity platform. It should allow users to create projects, add team members,
assign tasks, comment and move tasks between boards in Kanban style. In this initial phase for this feature,
let's call it "Create Taskify," let's have multiple users but the users will be declared ahead of time, predefined.
I want five users in two different categories, one product manager and four engineers. Let's create three
different sample projects. Let's have the standard Kanban columns for the status of each task, such as "To Do,"
"In Progress," "In Review," and "Done." There will be no login for this application as this is just the very
first testing thing to ensure that our basic features are set up. For each task in the UI for a task card,
you should be able to change the current status of the task between the different columns in the Kanban work board.
You should be able to leave an unlimited number of comments for a particular card. You should be able to, from that task
card, assign one of the valid users. When you first launch Taskify, it's going to give you a list of the five users to pick
from. There will be no password required. When you click on a user, you go into the main view, which displays the list of
projects. When you click on a project, you open the Kanban board for that project. You're going to see the columns.
You'll be able to drag and drop cards back and forth between different columns. You will see any cards that are
assigned to you, the currently logged in user, in a different color from all the other ones, so you can quickly
see yours. You can edit any comments that you make, but you can't edit comments that other people made. You can
delete any comments that you made, but you can't delete comments anybody else made.
```

After this prompt is entered, you should see Claude Code kick off the planning and spec drafting process. Claude Code will also trigger some of the built-in scripts to set up the repository.

Once this step is completed, you should have a new branch created (e.g., `001-create-taskify`), as well as a new specification in the `specs/001-create-taskify` directory.

The produced specification should contain a set of user stories and functional requirements, as defined in the template.

### **STEP 3:** Have Claude Code validate the plan

With the plan in place, you should have Claude Code run through it to make sure that there are no missing pieces.

</details>

---

## 💾 Project Memory Bank (v0.2.0+)

RapidSpec includes an integrated project memory bank system to track decisions, patterns, and progress across development sessions.

### What is a Memory Bank?

A memory bank is a collection of 6 markdown files (stored in `.rapidspec/memory/`) that maintains project-level context:

- **productContext.md** - Project overview, architecture, tech stack
- **activeContext.md** - Current work, objectives, blockers, next steps
- **systemPatterns.md** - Coding patterns, architectural patterns, anti-patterns to avoid
- **decisionLog.md** - Technical decisions with rationale and implications
- **progress.md** - Work tracking, completed features, planned work
- **constitution.md** - Project governance and principles

### Initialize Memory Bank

Create a memory bank for your project:

```bash
/rapidspec.constitution
```

This automatically:
- Analyzes your codebase structure
- Detects your tech stack
- Reviews git history for past decisions
- Initializes memory bank files with context

### Track Work and Decisions

During development, the memory bank auto-tracks:

**Automatically (no flags):**
- Work committed with `/rapidspec.commit`
- Features archived with `/rapidspec.archive`

**Optionally (with flags):**
```bash
# Log proposal decisions and research
/rapidspec.proposal --update-memory "Feature name"

# Track implementation progress
/rapidspec.apply change-id --track-progress

# Log review findings and patterns
/rapidspec.review change-id --log-findings

# Manual updates anytime
/rapidspec.umb "Decision made: chose JWT for authentication"
```

### Benefits

✅ **Knowledge Retention** - Decisions and patterns persist across sessions
✅ **Team Onboarding** - New members understand project context
✅ **Decision History** - Why were decisions made? Review the decision log
✅ **Pattern Documentation** - Consistent coding and architectural patterns
✅ **Work Tracking** - Complete history of features, bug fixes, and technical improvements

### Learn More

For comprehensive documentation:
- **Integration details**: See `MEMORY_BANK_INTEGRATION.md`
- **User guide**: See `docs/memory-bank.md`
- **AI agent instructions**: See `AGENTS.md` (Memory Bank Integration section)

---

## 🔍 Troubleshooting

### Git Credential Manager on Linux

If you're having issues with Git authentication on Linux, you can install Git Credential Manager:

```bash
#!/usr/bin/env bash
set -e
echo "Downloading Git Credential Manager v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "Installing Git Credential Manager..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "Configuring Git to use GCM..."
git config --global credential.helper manager
echo "Cleaning up..."
rm gcm-linux_amd64.2.6.1.deb
```

## 👥 Maintainers

- Den Delimarsky ([@localden](https://github.com/localden))
- John Lam ([@jflam](https://github.com/jflam))

## 💬 Support

For support, please open a [GitHub issue](https://github.com/benzntech/rapidspec-kit/issues/new). We welcome bug reports, feature requests, and questions about using Spec-Driven Development.

## 🙏 Acknowledgements

This project is heavily influenced by and based on the work and research of [John Lam](https://github.com/jflam).

## 📄 License

This project is licensed under the terms of the MIT open source license. Please refer to the [LICENSE](./LICENSE) file for the full terms.
