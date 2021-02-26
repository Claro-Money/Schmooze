# Schmooze

A network debugging and visualisation tool for iOS and ipadOS

<table>
    <tr>
        <td><img src="https://github.com/Claro-Money/Schmooze/blob/master/Screenshots/list.png?raw=true" alt="List of requests" /></td>
        <td><img src="https://github.com/Claro-Money/Schmooze//blob/master/Screenshots/get.png?raw=true" alt="GET request" /></td>
    </tr>
    <tr>
        <td><img src="https://github.com/Claro-Money/Schmooze//blob/master/Screenshots/error.png?raw=true" alt="Error request" /></td>
        <td><img src="https://github.com/Claro-Money/Schmooze//blob/master/Screenshots/delete.png?raw=true" alt="DELETE request" /></td>
    </tr>
</table>

## Installation

#### Swift Package Mananger (SPM):

```swift
.package(name:"AdminPanel", url: "https://github.com/Claro-Money/Schmooze/.git", from: "1.0.0")
```

## Use


#### Register user interface

Trigger with default gesture recogniser. 3 taps with 3 fingers on a device, 3 taps with 2 fingers (holding option key) on simulator. 

```swift
import Schmooze

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        SchmoozeViewController.register(with: window!)
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

}
```

Trigger with a custom recognizer

```swift
let recognizer = ... // Custom gesture recognizer
SchmoozeViewController.register(with: window!, gestureRecognizer: recognizer)
```

#### Register requests

You have to manually register requests in your networking (probably) class. Your setup could look as follows:

```swift
var req = URLRequest(url: URL(string: "https://www.raywenderlich.com/robots.txt")!)
req.httpMethod = "GET"

let trackerRequest = Tracker.default.register(request: req)

let task: URLSessionDataTask = URLSession.shared.dataTask(with: req) { (data, response, error) in
    Tracker.default.handle(data: data, response: response, error: error, for: trackerRequest)
}
task.resume()
```

#### Custom Trackers

You can keep multiple trackers for multiple jobs around your app. A default `Tracker` class is used by default. Tracker transforms all requests and responses into an internal `Request` and `Response` objects and stores them in memory. You can display custom <b>SchmoozeViewController</b> screens for different trackers. 

## Author

<b>Ondrej Rafaj</b> - Twitter & Github on <a href="https://twitter.com/rafiki270">@rafiki270</a>

## License

MIT
