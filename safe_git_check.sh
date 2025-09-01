#!/bin/bash

echo "🔍 Checking main repo status..."
git status

echo "🔍 Checking frontend submodule..."
cd frontend && git status && cd ..

echo "🔍 Checking backend submodule..."
cd backend && git status && cd ..

echo "✅ All good if all are on 'main' and clean!"
