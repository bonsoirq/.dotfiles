#!/usr/bin/env fish
echo "--- BLACK: "
poetry run black . 
echo "--- ISORT: "
poetry run isort .
echo "--- FLAKE: "
poetry run flake8 .
echo "--- MYPY: "
poetry run mypy .