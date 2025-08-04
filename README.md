# shartflix
Shartflix is a Netflix-inspired mobile replica app developed by NodeLabs using Flutter. It allows users to explore movies and series with a beautiful and modern UI. The app is open and free for everyone to use.


## 🚀 Kurulum | Getting Started

### 🇹🇷 Gereksinimler  
- Flutter 3.x.x  
- Dart 3.x.x  
- Android Studio veya VS Code

### 🇺🇸 Requirements  
- Flutter 3.x.x  
- Dart 3.x.x  
- Android Studio or VS Code

---

### ⚠️ Önemli | Important

**🇹🇷 Bu proje gerçek bir API ile çalışmaktadır.**  
Uygulamanın düzgün çalışabilmesi için kök dizine `.env` adında bir dosya oluşturmalı ve içerisine [TMDB](https://www.themoviedb.org/) API anahtarınızı şu formatta yapıştırmalısınız:
Aksi takdirde uygulama API bağlantı hatası verir ve içerik yüklenemez.

**🇺🇸 This project works with a real API.**  
To run the app properly, create a `.env` file in the root directory and paste your [TMDB](https://www.themoviedb.org/) API key in the following format:
Otherwise, the app will fail to fetch content and produce API-related errors.

### 🔧 Kurulum Adımları | Installation

```bash
git clone https://github.com/kullaniciadi/shartflix.git
cd shartflix
flutter pub get
flutter run

---
