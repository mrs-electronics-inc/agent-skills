# List available recipes
default:
    @just --list

# Install dependencies
deps:
    echo "No dependencies to install..."

# Set up development environment (install dependencies and pre-commit hooks)
setup: deps
    pre-commit install

# Format the markdown files
format:
    prettier --write "**/*.md"
