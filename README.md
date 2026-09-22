# mizania_proj

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 🇩🇿 Mizania — ميزانية

### Smart Personal Finance Management for the Algerian Market

**Mizania (ميزانية)** is a full-stack personal finance application designed to help users manage their expenses, budgets, and financial habits in a simple and intuitive way.

The project combines a **Flutter cross-platform application**, **Supabase** for authentication and data management, and a **FastAPI machine-learning API** for spending prediction.

> 💡 The name **Mizania (ميزانية)** comes from the Arabic word for **budget**.

---

## 🚀 About the Project

Managing personal finances can be difficult when financial information is scattered across different places.

Mizania aims to provide users with a centralized platform where they can:

* 💸 Track their daily expenses
* 📊 Visualize their spending
* 🎯 Manage their budgets
* 📅 Monitor monthly financial activity
* 💰 Work with Algerian Dinar (DZD)
* 📄 Export financial information
* 🤖 Get a prediction of their next month's spending
* 🔐 Securely manage their account and personal data

The application was developed with the **Algerian market** in mind, making personal finance management more accessible and adapted to local users.

---

# ✨ Main Features

## 💸 Expense Management

Users can record and manage their personal expenses.

Features include:

* Add expenses
* Categorize expenses
* Track spending history
* Monitor monthly spending
* View financial activity over time
* Support for DZD

---

## 🎯 Budget Management

Mizania allows users to create and monitor budgets.

Users can:

* Set spending limits
* Monitor their budget usage
* Compare actual spending with planned budgets
* Identify categories where spending is increasing

---

## 📊 Statistics & Data Visualization

Financial data is presented through visual statistics and charts.

Users can analyze:

* Monthly expenses
* Spending by category
* Spending trends
* Budget usage
* Overall financial activity

This makes financial information easier to understand at a glance.

---

## 🤖 AI-Based Spending Prediction

One of Mizania's main features is a **machine-learning-based spending prediction system**.

The application uses the user's previous spending information to estimate their spending for the following month.

The prediction system is implemented using:

* 🐍 Python
* ⚡ FastAPI
* 🤖 Machine Learning
* 📦 Joblib

The trained model is stored as:

```text
model.pkl
```

The Flutter application sends the previous month's spending to the FastAPI backend:

```text
Flutter
   │
   │ POST /predict
   ▼
FastAPI
   │
   ▼
Machine Learning Model
   │
   ▼
Predicted Next Month Spending
```

### Example request

```json
{
  "last_month_total": 45000
}
```

### Example response

```json
{
  "prediction_available": true,
  "predicted_next_month": 47250.50,
  "message": null
}
```

If there is not enough spending history, Mizania does not invent a prediction.

For example:

```json
{
  "prediction_available": false,
  "predicted_next_month": null,
  "message": "Not enough spending history"
}
```

---

# 🗄️ Supabase

Mizania uses **Supabase** as an important part of its backend infrastructure.

Supabase provides:

* 🔐 Authentication
* 🗃️ PostgreSQL database
* 👤 User-related data
* 💾 Financial data storage

The Flutter application communicates directly with Supabase for the application's data and authentication features.

The FastAPI service is used separately for the machine-learning prediction functionality.

---

# 🏗️ System Architecture

The application follows a full-stack architecture:

```text
                         MIZANIA
                            │
                            ▼
                  ┌───────────────────┐
                  │   Flutter App     │
                  │                   │
                  │ UI / Expenses     │
                  │ Budgets / Charts  │
                  │ PDF / User Data   │
                  └─────────┬─────────┘
                            │
                ┌───────────┴───────────┐
                │                       │
                ▼                       ▼
      ┌──────────────────┐    ┌──────────────────┐
      │     Supabase     │    │     FastAPI      │
      │                  │    │                  │
      │ Authentication   │    │    /predict      │
      │ PostgreSQL       │    │    /health       │
      │ Database         │    │                  │
      └──────────────────┘    └────────┬─────────┘
                                       │
                                       ▼
                              ┌──────────────────┐
                              │ Machine Learning │
                              │      Model       │
                              │                  │
                              │    model.pkl     │
                              └──────────────────┘
```

---

# 🛠️ Technology Stack

## Frontend

* **Flutter**
* **Dart**

## Backend

* **Python**
* **FastAPI**
* **Pydantic**
* **Uvicorn**

## Database & Authentication

* **Supabase**
* **PostgreSQL**
* **Supabase Auth**

## Machine Learning

* **Python**
* **Joblib**
* Trained ML model

## Deployment

* **Render** — FastAPI backend deployment
* **GitHub** — Source code and version control

---

# 🌐 FastAPI Backend

The FastAPI service is deployed on Render and provides the machine-learning API.

### API

```text
https://mizania-proj.onrender.com
```

## Health Check

### `GET /health`

Used to verify that the API is running.

Response:

```json
{
  "status": "ok"
}
```

---

## Prediction

### `POST /predict`

Predicts next month's spending using the trained machine-learning model.

### Request

```json
{
  "last_month_total": 45000
}
```

### Response

```json
{
  "prediction_available": true,
  "predicted_next_month": 47250.50,
  "message": null
}
```

---

# 🌐 CORS

Because the Flutter Web application and FastAPI backend can run on different origins, the FastAPI application includes CORS middleware.

The backend uses:

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

This allows the Flutter Web application to communicate with the prediction API.

For a production environment, the allowed origins can be restricted to the official frontend domain.

---

# 📱 Cross-Platform Application

Mizania is developed using Flutter, allowing the application to target multiple platforms.

The project can be adapted for:

* 📱 Android
* 🍎 iOS
* 🌐 Web
* 💻 Desktop platforms supported by Flutter

---

# 📄 PDF Export

Mizania provides functionality for exporting financial information into PDF format.

This allows users to keep a more permanent copy of their financial information and reports.

---

# 🌙 User Experience

The application focuses on providing a simple and accessible financial experience.

The interface includes:

* Clean financial dashboards
* Expense categorization
* Visual statistics
* Budget monitoring
* Dark mode
* Responsive Flutter UI
* Multi-currency support

---

# 💱 Currency Support

Mizania was designed with the Algerian context in mind.

The application supports the **Algerian Dinar (DZD)** and can accommodate additional currencies depending on the application's configuration.

---

# 🔐 Security

User authentication and financial data are handled through Supabase.

Important credentials and secrets should **never be committed to the GitHub repository**.

For example, private API keys, service-role keys, and other sensitive credentials should be stored securely using environment variables or the appropriate deployment configuration.

---

# 📂 Project Structure

A simplified version of the project structure is:

```text
Mizania/
│
├── lib/
│   ├── screens/
│   ├── widgets/
│   ├── services/
│   ├── models/
│   └── ...
│
├── backend/
│   ├── main.py
│   ├── model.pkl
│   └── requirements.txt
│
├── assets/
│   └── ...
│
├── pubspec.yaml
├── README.md
└── ...
```

> The exact structure may vary depending on the final organization of the repository.

---

# ⚙️ Installation & Setup

## Prerequisites

Make sure you have installed:

* Flutter SDK
* Dart SDK
* Python 3.x
* Git

You also need:

* A Supabase project
* The required Supabase configuration
* The trained `model.pkl` file for the prediction API

---

## 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
```

Then:

```bash
cd YOUR_REPOSITORY
```

---

# 📱 Flutter Setup

Install Flutter dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

For Flutter Web:

```bash
flutter run -d chrome
```

---

# 🐍 FastAPI Setup

Navigate to the backend:

```bash
cd backend
```

Create a virtual environment.

### Windows

```bash
python -m venv venv
venv\Scripts\activate
```

### macOS / Linux

```bash
python3 -m venv venv
source venv/bin/activate
```

Install the dependencies:

```bash
pip install -r requirements.txt
```

Start the API:

```bash
uvicorn main:app --reload
```

The local API will normally be available at:

```text
http://127.0.0.1:8000
```

---

# 🧪 API Testing

Once the backend is running, test:

```text
GET http://127.0.0.1:8000/health
```

Expected result:

```json
{
  "status": "ok"
}
```

Then test:

```text
POST http://127.0.0.1:8000/predict
```

with:

```json
{
  "last_month_total": 45000
}
```

---

# 🏆 Protomarket

Mizania was also developed and presented as part of our participation in **Protomarket**.

This experience allowed us to work on Mizania not only as a technical project, but also as a product-oriented solution addressing a real-world problem: **personal financial management**.

Through the project, we worked on:

* 💡 Identifying a real user need
* 🧠 Designing a practical solution
* 🎨 Developing the user experience
* 💻 Building a complete full-stack application
* 🤖 Integrating machine learning
* 🗄️ Managing application data
* 🚀 Deploying the backend
* 📊 Presenting the product and its value

Participating in Protomarket gave us an opportunity to develop Mizania from an initial idea into a functional prototype combining **technology, product thinking, and financial management**.

---

# 🎓 Academic Project

Mizania was developed by students from **ESI Alger** as a full-stack software project.

The project allowed us to apply concepts from several areas of computer science and software engineering:

* Mobile and web development
* Cross-platform development
* Database management
* Authentication
* REST API development
* Machine learning
* Data visualization
* Cloud deployment
* Software architecture
* Product development

---

# 👥 Team

### Mizania Team

Mizania was developed by two ESI Alger students.

| Member          | Role                       |
| --------------- | -------------------------- |
| **Meriem**      | Machine Learning / Backend |
| **[Your Name]** | Flutter / Frontend         |

> Replace `[Your Name]` with your name before publishing the README.

---

# 🔮 Future Improvements

Possible future improvements include:

* More advanced machine-learning models
* Improved prediction accuracy
* Personalized financial insights
* Recurring expenses
* Smart budget alerts
* More detailed financial reports
* Advanced data visualization
* More currency support
* Improved offline functionality
* Notifications and reminders
* Additional financial-management tools

---

# 📌 Project Highlights

| Area             | Technology            |
| ---------------- | --------------------- |
| Frontend         | Flutter / Dart        |
| Authentication   | Supabase Auth         |
| Database         | PostgreSQL / Supabase |
| Backend API      | FastAPI / Python      |
| Machine Learning | Python / Joblib       |
| Model            | `model.pkl`           |
| Deployment       | Render                |
| Version Control  | Git / GitHub          |
| Target Market    | 🇩🇿 Algeria          |
| Product Event    | Protomarket           |

---

# ❤️ Why Mizania?

Mizania was created around a simple idea:

> **Personal finance should be easier to understand and manage.**

By combining a user-friendly Flutter application, Supabase's backend infrastructure, and machine-learning-based spending prediction, Mizania aims to give users a clearer view of their financial habits and help them plan ahead.

---

# 📄 License

This project was developed for educational and project purposes.

If the project is released as open source, an appropriate open-source license can be added to the repository.

---

# ⭐ Mizania

### ميزانيتك، بطريقة أذكى.

**Track your spending. Manage your budget. Understand your finances.**

🇩🇿 **Built for the Algerian context.**

**Built with Flutter 💙 • Supabase ⚡ • FastAPI 🐍 • Machine Learning 🤖**

