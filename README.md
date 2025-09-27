# Modern TABASCO (BETA)

A modern tool for detecting **intra-domain textual ambiguities** using word sense disambiguation techniques.  
Built with **FastAPI (backend)** and **Next.js (frontend)** for a modular and modern developer experience.

---

## 🚀 About Modern TABASCO

Modern TABASCO is a **re-engineered version** of the original [TABASCO](https://github.com/a-moharil/tabasco) (2022) by **a-moharil** and collaborators.

The original project was implemented in **Flask + HTML/CSS** and tightly coupled with an academic paper.  
Modern TABASCO instead focuses on:

- ⚡ **FastAPI backend** for scalable APIs
- 🎨 **Next.js frontend** for a modern web interface
- 🔄 **Automated local setup** via `run-local.sh`
- 🧩 Clear modular structure using `frontend/` and `backend/` submodules
- 🖥 Runs entirely locally (no cloud costs) at **http://localhost:3000** (frontend) and **http://localhost:8000** (backend)

**Important:** This version is an engineering re-implementation. It does _not_ claim originality of the underlying research idea.

---

## 📖 Original Research Reference

The idea and original implementation of TABASCO were presented in:

> A. Moharil & Arpit Sharma, _“TABASCO: A transformer based contextualization toolkit”_, Science of Computer Programming, 2023.  
> DOI: [10.1016/j.scico.2023.102994](https://doi.org/10.1016/j.scico.2023.102994)
>
> If you use this software in academic or research work, please cite that paper.

---

## 🛠 Features

- Detect and analyze **contextual word sense ambiguities**
- Generate **summary** and **detailed** reports on ambiguous terms
- Identify **similar words per context** with sample sentences
- Built for **requirements engineering** and domain-specific text
- Lightweight, local-first — runs on your own machine

---

## 📦 Installation & Usage

Run the app locally with one command:

```bash
curl -fsSL https://raw.githubusercontent.com/vickvey/modern-tabasco/main/run-local.sh | bash
```

This will:

- Clone the repository (with submodules)
- Install backend & frontend dependencies
- Start both backend & frontend servers

Once running:

- 🌐 Frontend → [http://localhost:3000](http://localhost:3000)
- ⚙️ Backend → [http://localhost:8000](http://localhost:8000)

---

## 📖 Credits / Acknowledgements

- Original **TABASCO v1.1** (2022) by [a-moharil](https://github.com/a-moharil), under the MIT License.
- Modern TABASCO (2025) is a re-engineered version by **Vivek Kumar**, built with FastAPI + Next.js, extending the original idea.

---

## 📜 License

This project is distributed under the **MIT License**, with attribution to both authors.
See the [LICENSE](./LICENSE) file for full terms.
