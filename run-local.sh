#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/your-username/modern-tabasco.git"
APP_DIR="modern-tabasco"

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
  if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js >=18 (recommended >=20)"
    exit 1
  fi

  NODE_VERSION=$(node -v | sed 's/v//')
  REQUIRED="18.0.0"
  if [ "$(printf '%s\n' "$REQUIRED" "$NODE_VERSION" | sort -V | head -n1)" != "$REQUIRED" ]; then
    echo "❌ Node.js version $NODE_VERSION is too old. Please install Node.js >=18"
    exit 1
  fi
  echo "✅ Node.js $NODE_VERSION detected"
}

check_python
check_node

# ---------------- CLONE REPO ----------------
echo "🚀 Cloning modern-tabasco..."
if [ -d "$APP_DIR" ]; then
  echo "⚠️  Directory $APP_DIR already exists. Skipping clone."
else
  git clone --recurse-submodules "$REPO_URL"
fi

cd "$APP_DIR"

echo "🔄 Updating submodules..."
git submodule update --init --recursive

# ---------------- BACKEND ----------------
echo "📦 Setting up backend..."
cd backend
if command -v uv &> /dev/null; then
  echo "✅ uv found — installing with uv..."
  make install
else
  echo "⚠️ uv not found. Falling back to venv + pip..."
  python3 -m venv .venv
  source .venv/bin/activate
  pip install -U pip
  pip install -r requirements.txt || pip install .
fi

echo "▶️ Starting FastAPI backend..."
make dev &
BACKEND_PID=$!
cd ..

# ---------------- FRONTEND ----------------
echo "📦 Setting up frontend..."
cd frontend
if ! command -v pnpm &> /dev/null; then
  echo "⚠️ pnpm not found. Installing globally via npm..."
  npm install -g pnpm
fi
pnpm install

echo "▶️ Starting Next.js frontend..."
pnpm dev &
FRONTEND_PID=$!
cd ..

# ---------------- INFO ----------------
echo ""
echo "✅ modern-tabasco is now running!"
echo "   Backend → http://localhost:8000"
echo "   Frontend → http://localhost:3000"
echo ""
echo "🛑 Press Ctrl+C to stop both servers."
echo ""

# Wait for both
wait $BACKEND_PID $FRONTEND_PID
