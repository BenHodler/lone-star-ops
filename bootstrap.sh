#!/bin/bash
# lone-star-ops: bootstrap.sh
# Master setup script — runs the full LSO stack in order
# Run this on a fresh machine after cloning the repo

set -e

echo ""
echo "=========================================="
echo "  LONE STAR OPS — Bootstrap"
echo "=========================================="
echo ""

# ── 1. Check Docker ──────────────────────────
echo "[1/5] Checking Docker..."
if ! command -v docker &> /dev/null; then
  echo "  Docker not found. Install Docker Desktop first:"
  echo "  https://www.docker.com/products/docker-desktop"
  exit 1
fi
echo "  Docker OK — $(docker --version)"

# ── 2. Check Ollama ──────────────────────────
echo "[2/5] Checking Ollama..."
if ! command -v ollama &> /dev/null; then
  echo "  Ollama not found. Install from https://ollama.com then re-run."
  exit 1
fi
echo "  Ollama OK — $(ollama --version)"

# ── 3. Pull models ───────────────────────────
echo "[3/5] Pulling Ollama models..."
bash ollama/pull-models.sh

# ── 4. Set Ollama host ───────────────────────
echo "[4/5] Setting OLLAMA_HOST..."
export OLLAMA_HOST=0.0.0.0
echo "  Set for this session. Add to your shell profile to persist:"
echo "  export OLLAMA_HOST=0.0.0.0"

# ── 5. Start Odysseus ────────────────────────
echo "[5/5] Starting Odysseus..."
if [ ! -f odysseus/.env ]; then
  cp odysseus/.env.example odysseus/.env
  echo ""
  echo "  !! .env created from example."
  echo "  !! Open odysseus/.env and fill in your values, then re-run."
  exit 0
fi

cd odysseus
docker compose up -d --build
cd ..

echo ""
echo "=========================================="
echo "  LSO stack is up."
echo "  Odysseus → http://localhost:7000"
echo "  Check logs: docker compose -f odysseus/docker-compose.yml logs odysseus"
echo "=========================================="
echo ""
