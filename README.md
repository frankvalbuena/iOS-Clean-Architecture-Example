# iOS-Clean-Architecture-Example
An iOS app designed using [Clean Architecture](https://github.com/mp911de/CleanArchitecture "Clean Architecture") and [MVVM](https://www.objc.io/issues/13-architecture/mvvm). 

## Description of The App
This is an AppStore Example app, which fetches the data using the service https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json, the data is stored locally on the app providing offline support. The app processes the data by categories with a UI that mimics the real app. This is an universal app showing the apps on a Grid for the iPad and on a list for the iPhone.

## Architecture

The code is divided in 3 layers, Core, ViewModel and View. The Core is structured following the main premises of [Clean Architecture](https://github.com/mp911de/CleanArchitecture "Clean Architecture"). The app follows the [dependency inversion principle](https://en.wikipedia.org/wiki/Dependency_inversion_principle) using the protocol oriented approach that Swift has on its foundations. The app has unit test for each layer.

### Core
On this layer belongs all the classes which main concern is handling the data and the high level rules of the app.

#### - Entities
On this group belongs the AppSyncData protocol which represents the data to be consumed by the app. 

#### - Services
Services represents external agents like the web service used for getting the data and the repository in which data is stored, grouped and fetched. All the interfaces on this group are protocols, this allows mock objects to conform these protocols and being used for testing purposes on higher layers (like use cases and view models).

#### - Use Cases
The code in this layer contains application specific business rules. Each use case is represented by a protocol, the internal implementation is separated from the interface. Having a protocol per Use Case enforces the [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single_responsibility_principle), facilitates unit testing and improves traceability. The use cases are accessed via the UseCaseLocator class which is a [Service Locator](https://en.wikipedia.org/wiki/Service_locator_pattern) providing a centralized place to resolve and inject the use cases dependencies. The objects on this group relies on the entities and the services via protocols (to preserve dependency inversion principle) and returns the data using [DTOs](https://en.wikipedia.org/wiki/Data_transfer_object) to avoid exposing the entity layer and to model the data in a convenient way to be consumed by the App.

## ViewModel
The objects in this layer have the responsibilities described in the [MVVM](https://www.objc.io/issues/13-architecture/mvvm) architectural pattern. The ViewModels relies on the UseCases to get the data and model in a convenient way to be shown in the UI.

## View

The objects on this layer are the UIViewControllers and the UIViews used to present the data to the user. The view controller binds the data from the ViewModels to the UI objects, for tracking changes simple closure are used. This project doesn't include any binding framework to keep this as simple as posible and avoid coupling the layers with any reactive code.

## License
MIT License
