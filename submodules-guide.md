# Submodule Guide

This repository uses Git submodules to manage the backend and frontend as separate projects inside one umbrella repo.

## 📂 Structure

tabasco-app/
├── backend/ → https://github.com/vickvey/tabasco-fastapi
├── frontend/ → https://github.com/vickvey/tabasco-frontend

## 🚀 Cloning the repo (with submodules)

When you clone this repo, you also need to pull the submodules:

```bash
git clone https://github.com/vickvey/tabasco-app.git
cd tabasco-app
git submodule update --init --recursive
```

💻 Working with submodules

1. Make changes in a submodule

For example, in backend:

```bash
cd backend
```

## make changes

```bash
git add .
git commit -m "Fix API route"
git push origin main
```

2. Update the umbrella repo pointer

After pushing inside the submodule, update the main repo so it points to the new commit:

```bash
cd ..
git add backend
git commit -m "Update backend submodule pointer"
git push origin main
```

(Same process for frontend/.)

## 🔄 Updating submodules after pulling

If someone pulls changes in the umbrella repo, they also need to update the submodules:

```bash
git pull origin main
git submodule update --init --recursive
```

## 🛑 Common pitfalls

- Always commit and push inside the submodule before updating the umbrella repo.

- Always git push origin main (not just git push) inside submodules.

- If the umbrella repo shows “modified” for backend/ or frontend/ after submodule changes, that means you need to update the submodule pointer.
