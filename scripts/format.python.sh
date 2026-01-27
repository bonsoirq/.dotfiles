#!/usr/bin/env fish
echo "--- BLACK: "
poetry run black src/
echo "--- ISORT: "
poetry run isort src/
echo "--- FLAKE: "
poetry run flake8 src/
echo "--- MYPY: "
poetry run mypy src/