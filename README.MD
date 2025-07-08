# SwiftUI MVI Architecture Examples

🏗️ **Complete implementations of Model-View-Intent pattern in SwiftUI with practical examples**

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://developer.apple.com/ios/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0+-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![Xcode](https://img.shields.io/badge/Xcode-15.0+-blue.svg)](https://developer.apple.com/xcode/)

## 📖 Overview

This repository contains production-ready implementations of the Model-View-Intent (MVI) architecture pattern in SwiftUI. MVI provides unidirectional data flow, predictable state management, and excellent testability for complex SwiftUI applications.

### What's Included

- **Counter App** - Simple example demonstrating MVI basics
- **Todo App** - Full-featured implementation with persistence, filtering, and editing
- **Reusable MVI Components** - Store protocols, binding patterns, and utilities
- **Best Practices** - Error handling, optimistic updates, and SwiftUI integration

## 🚀 Features

### Counter App
- ✅ Basic MVI pattern demonstration
- ✅ Synchronous and asynchronous state updates
- ✅ Clear intent-based actions
- ✅ Simple state management

### Todo App
- ✅ Complete CRUD operations
- ✅ Real-time filtering (All, Active, Completed)
- ✅ Inline editing with optimistic updates
- ✅ AppStorage persistence
- ✅ Empty states and loading indicators
- ✅ Swipe actions for edit/delete

## 🏗️ Architecture Overview

```
┌─────────────┐    Intent    ┌─────────────┐    New State    ┌─────────────┐
│             │─────────────▶│             │────────────────▶│             │
│    View     │              │    Store    │                 │    Model    │
│             │◀─────────────│             │◀────────────────│             │
└─────────────┘   UI Update  └─────────────┘   State Change  └─────────────┘
```

### Key Components

- **Model** - Immutable state representation
- **View** - SwiftUI views that display state and send intents
- **Intent** - Enum defining all possible user actions
- **Store** - Processes intents and manages state transitions

## 🛠️ Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/SwiftUI-MVI-Architecture.git
cd SwiftUI-MVI-Architecture
```

2. **Open in Xcode**
```bash
open SwiftUI-MVI-Architecture.xcodeproj
```

3. **Run the examples**
   - Select your target device/simulator
   - Choose between `Counter` or `Todo` schemes
   - Press `Cmd+R` to run

## 📱 Usage Examples

### Basic MVI Store

```swift
@MainActor
final class CounterStore: MVIStore {
    @Published private(set) var state = CounterState()
    
    func send(_ intent: CounterIntent) {
        switch intent {
        case .increment:
            state = state.copy(count: state.count + 1)
        case .decrement:
            state = state.copy(count: state.count - 1)
        case .reset:
            state = CounterState()
        }
    }
}
```

### SwiftUI Integration

```swift
struct CounterView: View {
    @StateObject private var store = CounterStore()
    
    var body: some View {
        VStack {
            Text("\(store.state.count)")
                .font(.largeTitle)
            
            HStack {
                Button("-") { store.send(.decrement) }
                Button("+") { store.send(.increment) }
                Button("Reset") { store.send(.reset) }
            }
        }
    }
}
```

### Clean SwiftUI Bindings

```swift
// In your store
var textBinding: Binding<String> {
    Binding(
        get: { self.state.text },
        set: { self.send(.updateText($0)) }
    )
}

// In your view
TextField("Enter text", text: store.textBinding)
```

## 🧪 Testing

The MVI pattern makes testing straightforward:

```swift
func testIncrement() {
    let store = CounterStore()
    
    store.send(.increment)
    
    XCTAssertEqual(store.state.count, 1)
}
```

## 📂 Project Structure

```
SwiftUI-MVI-Architecture/
├── Counter/
│   ├── CounterState.swift
│   ├── CounterIntent.swift
│   ├── CounterStore.swift
│   ├── CounterView.swift
│   └── MVIStore.swift
└── Todo/
    ├── Todo.swift
    ├── TodoState.swift
    ├── TodoIntent.swift
    ├── TodoStore.swift
    ├── TodoService.swift
    ├── TodoListView.swift
    └── TodoRowView.swift

```

## 🎯 When to Use MVI

**✅ Use MVI when:**
- Complex state management with multiple data sources
- Team collaboration with explicit contracts
- Predictable state transitions are critical
- Comprehensive testing is required
- Real-time updates and complex workflows

**❌ Consider alternatives when:**
- Simple CRUD operations
- Rapid prototyping
- Small team or solo development
- Straightforward data flows

## 🔧 Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- SwiftUI 4.0+

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Guidelines

1. Follow existing code style and patterns
2. Add tests for new features
3. Update documentation as needed
4. Ensure all examples compile and run

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by Redux and other unidirectional data flow patterns
- Built with SwiftUI and modern Swift concurrency
- Thanks to the iOS development community for feedback and contributions

---

**Made with ❤️ by [Karan Pal](https://github.com/palkaran)**

*If this helped you, please give it a ⭐️*
