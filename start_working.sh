#!/bin/bash

echo "🔄 Updating submodules recursively..."
git submodule update --init --recursive

echo ""
echo "🔍 Checking and fixing submodule HEADs..."

fix_detached_head() {
  local submodule_dir=$1
  echo "👉 Checking $submodule_dir..."

  cd "$submodule_dir" || { echo "❌ Failed to enter $submodule_dir"; exit 1; }

  current_branch=$(git symbolic-ref --short -q HEAD)

  if [ -z "$current_branch" ]; then
    echo "⚠️  Detached HEAD detected. Trying to check out 'main'..."
    git fetch origin main
    git checkout main && git pull || echo "❌ Could not checkout 'main' in $submodule_dir"
  else
    echo "✅ On branch '$current_branch'"
  fi

  cd - > /dev/null
  echo ""
}

fix_detached_head "frontend"
fix_detached_head "backend"

echo "🔍 Checking main repo status..."
git status
echo ""

echo "🔍 Checking frontend submodule..."
cd frontend && git status && cd ..
echo ""

echo "🔍 Checking backend submodule..."
cd backend && git status && cd ..
echo ""

echo "✅ Ready to work! All submodules should be on 'main' and clean."
