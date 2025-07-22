# Personal‑Finance‑Mobile

**Author:** Karunia Syukur Baeha

A cross‑platform mobile app built with Flutter for daily personal finance tracking (income, expenses, categories) backed by a Node.js/Express API with MySQL.

---

## Features

- **Dashboard**  
  - Shows total income, total expenses, and balance  
  - Lists 5 most recent transactions with a “View All Transactions” button  

- **Transactions**  
  - Create, edit, delete entries  
  - Filter by type (All / Income / Expense) and by date  

- **Categories**  ~
  - Create, edit, delete categories  

---


## Getting Started

### 1. Clone the repositories

```bash
git clone https://github.com/KaruniaSyukurBaeha/personal-finance-mobile.git
```

### 2. Setup 
```bash
cd ../personal-finance-mobile
flutter pub get
```

### 3. In lib/core/dio_client.dart, update the base URL if your backend runs on a different host or port
```bash
dio.options.baseUrl = "http://your-url:5000/";    
```

### 4. Run the app on an emulator or device
```bash
flutter run 
```