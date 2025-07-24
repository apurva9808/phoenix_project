# 📚 BookClub – A Phoenix Web App

BookClub is a web application built using [Elixir](https://elixir-lang.org/) and the [Phoenix Framework](https://www.phoenixframework.org/). It allows users to manage books, reviews, and personalized reading lists — a perfect platform for book lovers and community-driven reading!

---

## 🚀 Features

- 📖 Add, update, and manage book listings
- 🗂️ Organize books into custom reading lists
- 💬 Write and read reviews
- 👥 User authentication and account settings
- 🔍 LiveView for real-time updates and interactions
- 🌐 Clean and responsive UI built on Phoenix templates

---

## ⚙️ Tech Stack

- **Backend:** Elixir, Phoenix
- **Frontend:** Phoenix LiveView, HEEx templates
- **Database:** PostgreSQL (Ecto)
- **Auth:** Phoenix Auth generators
- **Dev Tools:** Mix, IEx, Phoenix Generators

---

## 🧑‍💻 Getting Started

### Prerequisites

- Elixir ~> 1.15
- Erlang/OTP ~> 26
- PostgreSQL installed and running

### Setup

```bash
git clone https://github.com/apurva9808/phoenix_project.git
cd phoenix_project
mix deps.get
mix ecto.setup
npm install --prefix assets
mix phx.server
