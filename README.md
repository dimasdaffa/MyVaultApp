# MyVaultApp

## What is this project?
**MyVaultApp** is a native iOS application designed to help users manage and overcome financial impulsivity. Built upon the principles of the Decision Impulsive Layering Framework, the app acts as a psychological buffer between the urge to buy and the actual purchase. 

Whenever you feel the sudden urge to buy a product, you add it to your "Vault". Instead of allowing an immediate checkout, the app enforces a strict **48-hour cooling-down period (lock)**. During this time, the item is locked, giving your emotions time to settle and preventing buyer's remorse. 

Once the timer finishes, you are prompted to review your initial thoughts through a guided journaling and validation process. By answering a series of emotional and financial questions, MyVaultApp calculates your impulsivity score and helps you make a rational, well-thought-out final decision: to proceed with the purchase or to save your money.

## Tech Stack
- **Language:** Swift
- **UI Framework:** SwiftUI (utilizing modern features like `TimelineView` for highly optimized, localized rendering)
- **Architecture:** MVVM (Model-View-ViewModel)
- **Local Storage:** SwiftData (utilizing type-safe Enums and Codable)
- **Reactive Programming:** Combine (for Timer management and state observation)
