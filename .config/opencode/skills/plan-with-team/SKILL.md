---
name: plan-with-team
description: Analyze user requirements and create a detailed implementation plan with team orchestration, saving it as a spec document for the team-lead agent to execute.
---

# Plan With Team

Create a detailed implementation plan based on the user's requirements. Analyze the request, think through the implementation approach, and save a comprehensive specification document to `.agent/specs/<project-number>-<project-name-in-kebab-case>/unimplemented/<plan-number-prefix>-<name-of-plan-in-kebab-case>/plan.md`.

## Instructions

- If the user has not yet described what they want to build, ask them before proceeding.
- If the user does not tell you the project number and project name, ask them so you know what to name the directory.
- **PLANNING ONLY**: Do NOT build, write code, or deploy agents. Your only output is a plan document.
- Carefully analyze the user's requirements
- Determine the task type (chore|feature|refactor|fix|enhancement) and complexity (simple|medium|complex)
- Think deeply about the best approach
- Explore the codebase to understand existing patterns and architecture
- Generate a descriptive, kebab-case directory name based on the main topic
- Prefix the plan directory with the next number looking at both implemented and unimplemented plans
- Save the plan to `.agent/specs/<project-number>-<project-name-in-kebab-case>/unimplemented/<plan-number-prefix>-<name-of-plan-in-kebab-case>/plan.md`
- The plan lives inside a named directory so related files (notes, seed data, references) can be stored alongside it

## Plan Format

Use this EXACT format:

```markdown
# Plan: <plan number> - <task name>

## Task Description
<describe the task in detail>

## Objective
<clearly state what will be accomplished>

## Problem Statement
<define the specific problem or opportunity>

## Solution Approach
<describe the proposed solution>

## Relevant Files
<list files relevant to the task with explanations>

### New Files (if needed)
<list new files to be created>

## Team Orchestration

> **Worktree Isolation**: The team-lead creates an isolated git worktree for this spec using `~/.config/opencode/scripts/worktree-create.sh`. All builders work inside this worktree. After final validation, changes are merged back via `~/.config/opencode/scripts/worktree-merge.sh`.

The team-lead agent will orchestrate execution using these team members:

### Team Members

- **Builder**
  - Name: <unique name, e.g., "api-builder">
  - Role: <specific focus>
  - Agent: builder

- **Validator**
  - Name: <unique name, e.g., "api-validator">
  - Role: Verify implementation meets criteria
  - Agent: validator

- **Documenter**
  - Name: <unique name, e.g., "feature-documenter">
  - Role: Generate documentation for completed work
  - Agent: documenter

## Step by Step Tasks

### 1. <First Task Name>
- **Task ID**: <kebab-case-id>
- **Depends On**: none
- **Assigned To**: <team member name>
- **Agent**: builder
- **Actions**:
  - <specific action>
  - <specific action>
- **Acceptance Criteria**:
  - <criterion>

### 2. <Second Task Name>
- **Task ID**: <kebab-case-id>
- **Depends On**: <previous task ID>
- **Assigned To**: <team member name>
- **Agent**: builder
- **Actions**:
  - <specific action>
- **Acceptance Criteria**:
  - <criterion>

### N-1. Final Validation
- **Task ID**: validate-all
- **Depends On**: <all previous task IDs>
- **Assigned To**: validator
- **Agent**: validator
- **Checks**:
  - Run all validation commands
  - Verify acceptance criteria met

### N. Documentation
- **Task ID**: generate-docs
- **Depends On**: validate-all
- **Assigned To**: documenter
- **Agent**: documenter
- **Actions**:
  - Read the plan file and implementation files
  - Generate documentation in `app_docs/`

## Acceptance Criteria
<list specific, measurable criteria for task completion>

## Validation Commands
<list specific commands to validate the work>
- Example: `npm test` - Run test suite
- Example: `npm run lint` - Check code style

## Notes
<optional additional context or considerations>
```

## Report

After creating the plan:

```
✅ Implementation Plan Created

File: .agent/specs/<project-number>-<project-name-in-kebab-case>/unimplemented/<plan-number-prefix>-<name-of-plan-in-kebab-case>/plan.md
Topic: <brief description>

Key Components:
- <component 1>
- <component 2>

Team Members:
- <member>: <role>

Tasks:
1. <task> → <assigned to>
2. <task> → <assigned to>

To execute this plan:
1. Switch to team-lead agent: /agent swap → team-lead
2. Say: "Execute the plan in .agent/specs/<project-number>-<project-name-in-kebab-case>/unimplemented/<plan-number-prefix>-<name-of-plan-in-kebab-case>/plan.md"
```
