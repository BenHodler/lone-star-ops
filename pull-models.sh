#!/bin/bash
# lone-star-ops: pull-models.sh
# Pulls the standard LSO model stack via Ollama
# Edit this list to add/remove models before running

echo "[LSO] Pulling Ollama models..."

ollama pull llama3.2       # general chat, fast, ~2GB
ollama pull llava          # image understanding, ~4.7GB
ollama pull mistral        # writing/scripts, ~4GB

echo "[LSO] Done. Run 'ollama list' to verify."
