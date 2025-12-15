# Swipe Card Pager (Tinder-Style) – Flutter

A lightweight, customizable **Tinder-style swipe card pager** built with pure
Flutter.  
Supports **left / right swipe gestures**, stacked cards, smooth animations,
and **controller-based programmatic swipes**.

Ideal for **dating apps, product browsing, onboarding flows**, and any
card-based UI.

---

## ✨ Features

👉 Tinder-style swipe interaction  
👈 Swipe cards left or right  
🃏 Card stack with scaling & vertical offset  
🎯 Swipe threshold control  
🎮 Programmatic swipe using controller  
⚡ Smooth animations using `AnimationController`  
🧩 Fully customizable card UI via `itemBuilder`  
❌ No third-party dependencies  

---

## ✨ Preview




https://github.com/user-attachments/assets/4c2ca255-405f-425f-9365-0a453f9907f5


---
## ✨ Installation
Add this to your package's pubspec.yaml file:
```
dependencies:
  swipe_card_pager:
    path: ../swipe_card_pager
```
▶️ From GitHub
```
dependencies:
  swipe_card_pager:
    git:
      url: https://github.com/yourusername/swipe_card_pager.git
```
Then Run:
```
flutter pub get
```
## 📁 Folder Structure
```
advanced_button_pack/
│
├── lib/
│   └── advanced_button_pack.dart
│
├── example/
│   └── main.dart
│
└── README.md
  ```
## 🚀 Usage (Demo App)

Below is a complete demo screen showcasing all buttons included in
**Advanced Button Pack**.

```
import 'package:flutter/material.dart';
import 'tinder_card_pager.dart';

class SwipeDemo extends StatelessWidget {
  SwipeDemo({super.key});

  final controller = TinderCardPagerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Swipe Card Demo')),
      body: Center(
        child: SizedBox(
          height: 400,
          child: TinderCardPager(
            itemCount: 5,
            controller: controller,
            onSwipe: (index, direction) {
              print('Swiped card $index → $direction');
            },
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Card $index',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: controller.swipeLeft,
            child: const Icon(Icons.close),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: controller.swipeRight,
            child: const Icon(Icons.favorite),
          ),
        ],
      ),
    );
  }
}
```
##🎮 Programmatic Control
```
final controller = TinderCardPagerController();

controller.swipeLeft();
controller.swipeRight();
```
## 📜 License
MIT License
```
Copyright (c) 2025 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.
