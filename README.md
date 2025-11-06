# Segmentify iOS SDK
Segmentify  SDK for sending events and rendering recommendations for iOS based devices

> **Supports iOS 13 and higher devices.**

> **Current Version 1.4.1**

## Installation and Usage
You can directly use Swift Package Manager to add and use Segmentify in your project. 
To learn more about how to integrate Segmentify iOS SDK to your application, please check [Integration Guide](https://www.segmentify.com/dev/integration_ios/).

## Installation - Legacy

You can install Segmentify iOS SDK to your application by using [Pod Module](https://cocoapods.org/?q=segmentify).

Please add following line to your Podfile:

```ruby
pod "Segmentify"
```

## Usage - Legacy

To learn more about how to integrate Segmentify iOS SDK to your application, please check [Integration Guide](https://www.segmentify.com/dev/integration_ios/).

For other integrations you can check [Master Integration](https://www.segmentify.com/dev/) guide too.

Inside your Xcode project's root folder run the following commands.
 
- Run ```pod init``` to create an empty pod file
- Run ```pod install``` to add Cocoapods to your project
- Run open ```YourProject.xcworkspace``` to your new Xcode project's workspace.

## License

Segmentify iOS SDK is available under the BSD-2 license.
Please check LICENSE file to learn more about details.




## Push Permission Updates 1.4.2

1.4.2 updates includes auto userId for pushNotification request. It means if you are standalone push user you do NOT require to assign user id to `SegmentifyManager.sharedManager().sendNotification(segmentifyObject: obj)` anymore.

Good Luck!


