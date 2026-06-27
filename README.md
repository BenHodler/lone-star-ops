<img width="624" height="524" alt="lone-star-ops-logo" src="https://github.com/user-attachments/assets/95ddab50-6790-4884-b919-fcc2def7ca2f" />

**A self-hosted homelab deployment kit for local-first AI, networking, and automation.**

Built and maintained by Lone Star Operations in Texas.  
No subscriptions. No cloud dependency. Your hardware, your data.

---

## What Is This?

Lone Star Ops (LSO) is a personal homelab stack focused on:

- **Local AI** — run your own language models with no usage limits
- **Private networking** — Tailscale mesh, Nginx Proxy Manager, split DNS
- **Self-hosted workspace** — Odysseus for chat, research, documents, image tools
- **Portability** — clone, fill in your `.env`, and bootstrap on any machine

This repo is the deployment kit. It's opinionated toward privacy-first,
low-cost, and maintainable-by-one-person setups.

---

## Stack

| Layer | Tool | Purpose |
|---|---|---|
| AI Workspace | [Odysseus](https://github.com/pewdiepie-archdaemon/odysseus) | Chat, agents, research, docs, image gallery |
| Model Runner | [Ollama](https://ollama.com) | Local LLM serving |
| Cloud Fallback | [Ollama Cloud](https://ollama.com) | Same account, same models — just cloud-side |
| Private Network | [Tailscale](https://tailscale.com) | Zero-config mesh VPN |
| Reverse Proxy | Nginx Proxy Manager | HTTPS, subdomain routing |

---

## Two Modes, One Account

LSO uses **Ollama for everything** — local or cloud. No second service, no second account.

| Mode | When to use | Endpoint |
|---|---|---|
| **Local** | 16GB+ RAM, hardware available | `http://host.docker.internal:11434` |
| **Cloud** | Low-spec machine or quick start | `https://api.ollama.com/v1` |

Switching between them is a single URL swap in Odysseus settings.  
Same models. Same names. Same Ollama account.

---

## Requirements

**Minimum (Ollama cloud fallback):**
- Any machine that can run Docker
- 8GB RAM
- Internet connection
- Free Ollama account + API key

**Recommended (full local AI):**
- 16GB RAM (32GB preferred)
- 20GB+ free disk
- Docker Desktop
- Ollama installed locally

---

## Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/YOUR_USERNAME/lone-star-ops.git
cd lone-star-ops
```

### 2. Set up your environment

```bash
cp odysseus/.env.example odysseus/.env
nano odysseus/.env   # fill in your values
```

At minimum set `ADMIN_EMAIL` and `ADMIN_PASSWORD`.

**Local Ollama:** leave `OLLAMA_BASE_URL` as-is.  
**Ollama Cloud:** change `OLLAMA_BASE_URL` to `https://api.ollama.com/v1` and add your `OLLAMA_API_KEY`.

Get your Ollama API key at [ollama.com](https://ollama.com) → Account → API Keys.

### 3. Install Ollama (local mode only — skip if using cloud)

Download from [ollama.com](https://ollama.com), then pull models:

```bash
bash ollama/pull-models.sh
```

Set Ollama to listen on all interfaces:

**Windows:** Add system environment variable `OLLAMA_HOST = 0.0.0.0`, restart Ollama.  
**Linux:** `sudo systemctl edit ollama` → add `Environment="OLLAMA_HOST=0.0.0.0"` → restart.

### 4. Run bootstrap

```bash
bash scripts/bootstrap.sh
```

Checks dependencies, pulls models (local mode), and starts Odysseus.

### 5. Open Odysseus

```
http://localhost:7000
```

Log in with your `.env` credentials. Check Docker logs for the initial admin password if needed:

```bash
docker compose -f odysseus/docker-compose.yml logs odysseus
```

---

## Connecting Odysseus to Ollama

In Odysseus → Settings → Model Endpoints → Add:

**Local:**
- Type: `Ollama`
- URL: `http://host.docker.internal:11434`

**Cloud:**
- Type: `OpenAI-compatible`
- URL: `https://api.ollama.com/v1`
- API Key: your Ollama cloud key

You can add both and switch per-chat. Cloud as fallback, local as default.

---

## Recommended Models

| Model | Use | Size |
|---|---|---|
| `llama3.2` | General chat and reasoning | ~2GB |
| `llava` | Image understanding and analysis | ~4.7GB |
| `mistral` | Writing, scripts, summarization | ~4GB |

Pull any model locally:
```bash
ollama pull modelname
```

Browse all models at [ollama.com/library](https://ollama.com/library).  
All models available locally are also available on Ollama Cloud — no difference in naming.

---

## Tailscale (Remote Access + Node Sharing)

Install on any machine you want in the mesh:

```bash
bash tailscale/tailscale-setup.sh   # Linux
# Windows/Mac: https://tailscale.com/download
```

**Remote access to Odysseus:**  
`http://[tailscale-ip]:7000` from any device on your tailnet.

**Share a node with another Tailscale user:**  
Admin panel → Machines → three-dot menu → Share → enter their email.  
Good for shared compute — one machine serves AI to multiple tailnets.

---

## Directory Structure

```
lone-star-ops/
├── odysseus/
│   ├── .env.example        ← copy to .env, fill in values
│   └── docker-compose.yml
├── ollama/
│   ├── .env.example
│   └── pull-models.sh      ← pulls standard model stack
├── tailscale/
│   └── tailscale-setup.sh
├── scripts/
│   └── bootstrap.sh        ← run this first on a new machine
├── .gitignore
└── README.md
```

---

## Security Notes

- `.env` files are gitignored — never commit real keys or passwords
- Keep Tailscale auth keys out of the repo
- Don't expose Ollama port (11434) publicly — Tailscale only
- Odysseus auth is enabled by default — don't disable it
- Use Nginx Proxy Manager + a real domain for HTTPS if exposing any service

---

## Feedback

This is a personal homelab kit shared for reference.  
If you're a friend testing this, open an issue or shoot me a message directly.  
Pull requests welcome if you find something broken or have a cleaner approach.

---

*Lone Star Ops — built in San Antonio, runs everywhere.*
