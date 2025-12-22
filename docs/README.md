# Documentation

This folder contains the documentation source files for RapidRapidSpec-Kit, a comprehensive fork of RapidSpec-Kit with 100% RapidSpec automation parity, built using [DocFX](https://dotnet.github.io/docfx/).

## RapidRapidSpec-Kit Features

The complete 9-phase automation workflow is fully documented:

1. **Specification** - Define requirements with `/rapidspec.specify`

2. **Research** - Conduct tech research with `/rapidspec.research`

3. **Verification** - Verify existing code with `/rapidspec.verify`

4. **Options** - Generate implementation approaches with `/rapidspec.options`

5. **Planning** - Create technical plans with `/rapidspec.plan`

6. **Application** - Apply code with checkpoints using `/rapidspec.apply`

7. **Review** - Multi-agent quality review with `/rapidspec.review`

8. **Commits** - Auto-generate commits with `/rapidspec.commit`

9. **Archive** - Archive completed work with `/rapidspec.archive`

## Building Locally

To build the documentation locally:

1. Install DocFX:

   ```bash

   dotnet tool install -g docfx
   ```text

2. Build the documentation:

   ```bash

   cd docs
   docfx docfx.json --serve
   ```text

3. Open your browser to `http://localhost:8080` to view the documentation.

## Structure

- `docfx.json` - DocFX configuration file

- `index.md` - Main documentation homepage

- `toc.yml` - Table of contents configuration

- `installation.md` - Installation guide

- `quickstart.md` - Quick start guide with 9-phase workflow

- `upgrade.md` - Upgrade and migration guide

- `local-development.md` - Local development guide

- `_site/` - Generated documentation output (ignored by git)

## Deployment

Documentation is automatically built and deployed when changes are pushed to the `main` branch. Visit the [RapidRapidSpec-Kit repository](https://github.com/benzntech/rapidspec-kit) for the latest documentation.
