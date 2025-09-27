#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/your-username/modern-tabasco.git"
APP_DIR="modern-tabasco"
FRONTEND_PORT=3000
BACKEND_PORT=8000

# ---------------- UTILS ----------------
check_port() {
  local port=$1
  if lsof -i :"$port" &> /dev/null; then
    echo "❌ Port $port is already in use. Please free it before running this script."
    exit 1
  fi
}

# ---------------- VERSION CHECKS ----------------
check_python() {
  if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 not found. Please install Python >=3.12"
    exit 1
  fi
  PY_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
  REQUIRED="3.12"
  if [ "$(printf '%s\n' "$REQUIRED" "$PY_VERSION" | sort -V | head -n1)" != "$REQUIRED" ]; then
    echo "❌ Python version $PY_VERSION is too old. Please install Python >=3.12"
    exit 1
  fi
  echo "✅ Python $PY_VERSION detected"
}

check_node() {
  local REQUIRED="18.0.0"
  if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v | sed 's/v//')
    if [ "$(printf '%s\n' "$REQUIRED" "$NODE_VERSION" | sort -V | head -n1)" = "$REQUIRED" ]; then
      echo "✅ Node.js $NODE_VERSION detected"
      return 0
    else
      echo "⚠️ Node.js version $NODE_VERSION is too old (<$REQUIRED). Installing via nvm..."
    fi
  else
    echo "⚠️ Node.js not found. Installing via nvm..."
  fi
  # Install NVM if missing
  if [ ! -d "$HOME/.nvm" ]; then
    echo "📥 Installing nvm..."
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  fi
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm use --lts
  NODE_VERSION=$(node -v | sed 's/v//')
  echo "✅ Node.js $NODE_VERSION installed via nvm"
}

check_pnpm() {
  if ! command -v pnpm &> /dev/null; then
    echo "⚠️ pnpm not found. Enabling via corepack..."
    corepack enable
    corepack prepare pnpm@latest --activate
  fi
  echo "✅ pnpm $(pnpm --version) ready"
}

# ---------------- RUN CHECKS ----------------
check_python
check_node
check_pnpm
check_port $BACKEND_PORT
check_port $FRONTEND_PORT

# ---------------- CLONE REPO ----------------
echo "🚀 Cloning modern-tabasco..."
if [ -d "$APP_DIR" ]; then
  echo "⚠️ Directory $APP_DIR already exists. Skipping clone."
else
  git clone --recurse-submodules "$REPO_URL"
fi
cd "$APP_DIR"
git submodule update --init --recursive

# ---------------- BACKEND ----------------
echo "📦 Setting up backend..."
cd backend
if command -v uv &> /dev/null; then
  echo "✅ uv found — installing with uv..."
  make install
else
  echo "⚠️ uv not found. Installing uv with pip..."
  python3 -m pip install --user --upgrade uv
  export PATH="$HOME/.local/bin:$PATH"
  if command -v uv &> /dev/null; then
    echo "✅ uv installed successfully"
    make install
  else
    echo "❌ Failed to install uv. Falling back to venv + pip..."
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -U pip
    pip install -r requirements.txt || pip install .
  fi
fi
echo "▶️ Starting FastAPI backend..."
make dev &
BACKEND_PID=$!
cd ..

# ---------------- FRONTEND ----------------
echo "📦 Setting up frontend..."
cd frontend
pnpm install
echo "▶️ Starting Next.js frontend..."
pnpm dev &
FRONTEND_PID=$!
cd ..

# ---------------- INFO ----------------
echo ""
echo "✅ modern-tabasco is now running!"
echo "   Backend → http://localhost:$BACKEND_PORT"
echo "   Frontend → http://localhost:$FRONTEND_PORT"
echo ""
echo "🛑 Press Ctrl+C to stop both servers."
echo ""

wait $BACKEND_PID $FRONTEND_PID
