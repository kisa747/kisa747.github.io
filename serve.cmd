@echo off
title %0

rem start http://127.0.0.1:8000

uv sync -U
uv run zensical serve -o
