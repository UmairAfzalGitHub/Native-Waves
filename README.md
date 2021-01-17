
![Platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![Languages](https://img.shields.io/badge/Language-Swift-orange.svg)

Native Waves Video Streaming Application.

## Demo
<img src="https://media.giphy.com/media/OjYQvoOicZS3StriCK/giphy.gif" width="250" height="500" />

## Features

- [x] Weclome Screen
- [x] Video Screen
- [x] AVPlayer
- [x] Play/Pause/Seek Controls
- [x] 10 second Forward/Backwards Control
- [x] Live Data Controls
- [x] Toggle Menu Controls
- [x] OverLay Screen
- [x] Reachability For Internet Connection
- [x] Unit Tests
- [x] No 3rd Party Libraries

## Requirements

- iOS 13.0+
- Xcode 12+
- Swift 5+

## Design Pattern: Model-View-ViewModel Coordinator (MVVM - C)
is a structural design pattern that separates objects into three distinct groups:
- #### Model 
  - hold application data. They're usually structs or simple classes.
- #### View
  - display visual elements and controls on the screen. They're typically subclasses of UIView.
- #### ViewModel
  - transform model information into values that can be displayed on a view. They're usually classes, so they can be passed around as references.
- ### Coordinator
  - The idea of the Coordinator pattern is to create a separate entity a Coordinator which is responsible for the app's flow. The Coordinator encapsulates a part of the app. The Coordinator knows nothing of its parent Coordinator , but it can start its child Coordinator. Navigation is not a viewController's responsibilty and coordinator makes it more easier to manage. 
  
## Dependencies

 None 😎

## Installation

### Clone Or Download Repository

- Assuming you have downloaded the project in Downloads folder. Open the folder named Live-Streaming and double click Live-Streaming.xcodeproj. Build the project using cmd+B key as a good practice. Hit cmd+R to run the project on desired simulator selected.

### IMPROVEMENTS:

- Network Layer should adopt new swift 5 Result type.
- UI tests.

### NOTE:

- As you can see in the codable models in the project the cases that covers codingKeys should have been plural entites in json response from backend e.g the key contestant in the matchInfo object should have been contestants as its representing an arrray of objects.
}
