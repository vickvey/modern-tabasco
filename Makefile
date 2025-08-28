.PHONY: dev backend frontend stop clean

# Run backend and frontend together
dev:
	@echo "🚀 Starting backend (FastAPI) and frontend (Next.js)..."
	(cd backend && uvicorn app.main:app --reload --port 8000) &
	(cd frontend && npm run dev) &
	wait

# Run only backend
backend:
	@echo "🚀 Starting backend..."
	(cd backend && uvicorn app.main:app --reload --port 8000)

# Run only frontend
frontend:
	@echo "🚀 Starting frontend..."
	(cd frontend && pnpm i && pnpm dev)

# Stop all background servers (Linux/macOS)
stop:
	@echo "🛑 Stopping running servers..."
	@pkill -f "uvicorn" || true
	@pkill -f "pnpm dev" || true

# Clean caches & build artifacts
clean:
	@echo "🧹 Cleaning up..."
	(cd backend && find . -type d -name "__pycache__" -exec rm -rf {} +) || true
	(cd frontend && rm -rf .next node_modules) || true
