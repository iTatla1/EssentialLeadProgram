
/*
 Simple color box represents a class its color could represent its module.
 Inhertiance (Strongly dependent) Filled triangle straight line from subclass to
 original class. If protocol add angular <> Barackets around class name. If a
 concrete class implements protocol semi filled line from class to protocol.
 */


import UIKit


protocol FeedLoader{
    func loadFeed(completion: @escaping ((String) -> Void))
}
class FeedVC: UIViewController {
    
    /*
     Scenerio if internet fetch fom remote else fetch from loacal cache
     Following is the bad approach
     */
    
    //MARK:- BAD DEPENDECY ON CONCRETE CLASSES
    //
    //    var remoteLader: RemoteFeed!
    //    var localLoader: LocalFeed!
    //
    //    convenience init(remote: RemoteFeed, local: LocalFeed){
    //        self.init()
    //        remoteLader = remote
    //        localLoader = local
    //    }
    
    //
    //    Better approach is to encapsulate this implementaion in another concrete class that follows feedloader protocol
    
    var loader: FeedLoader!
    
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    //    MARK:- Closures instead of Protocols
    //    var loader: (((String) -> Void) -> Void)!
    //    convenience init(loader: @escaping ((String) -> Void) -> Void) {
    //        self.init()
    //        loadFeed = loader
    //    }
    
    //    override func viewDidLoad() {
    //
    //        loadFeed{ feed in
    //
    //        }
    //    }
    
    override func viewDidLoad() {
        
        loader.loadFeed{ feed in
            
        }
    }
}


// Concrete classes fetching Feed Loader
class RemoteFeed: FeedLoader{
    func loadFeed(completion: @escaping ((String) -> Void)) {
    }
}

class LocalFeed: FeedLoader{
    func loadFeed(completion: @escaping ((String) -> Void)) {
    }
}


struct Reachability{
    static let isNetworkAvailable = false
}

class fetchRemoteFeedWithLocalFallback: FeedLoader{
    
    var remote: RemoteFeed!
    var local: LocalFeed!
    
    init(rFeed: RemoteFeed, lFeed: LocalFeed) {
        remote = rFeed
        local = lFeed
    }
    
    func loadFeed(completion: @escaping ((String) -> Void)) {
        let loader = Reachability.isNetworkAvailable ? remote.loadFeed : local.loadFeed
        loader(completion)
    }
    
    
}


// MARK:- With Closure

//import UIKit
//struct Reachability {
//    static let networkAvailable = false
//}
//
//typealias FeedLoader = (@escaping([String]) -> Void) -> Void
//
//class FeedViewController: UIViewController {
//
//    var loader: FeedLoader!
//
//    convenience init(loader: @escaping FeedLoader) {
//        self.init()
//        self.loader = loader
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loader { loadedItems in
//            // update UI
//        }
//    }
//}
//
//class RemoteFeedLoader {
//
//    func load(completion: @escaping ([String]) -> Void) {
//        // do something
//    }
//}
//
//class LocalFeedLoader {
//
//    func load(completion: @escaping ([String]) -> Void) {
//        // do something
//    }
//}
//
//class RemoteWithLocalFallbackFeedLoader {
//
//    var remoteFeedLoader: RemoteFeedLoader!
//    var localFeedLoader: LocalFeedLoader!
//
//    init(remoteFeedLoader: RemoteFeedLoader, localFeedLoader: LocalFeedLoader) {
//        self.remoteFeedLoader = remoteFeedLoader
//        self.localFeedLoader = localFeedLoader
//    }
//
//    func load(completion: @escaping ([String]) -> Void) {
//        let load = Reachability.networkAvailable ? remoteFeedLoader.load : localFeedLoader.load
//        load(completion)
//    }
//}
//
//let loader = RemoteWithLocalFallbackFeedLoader(remoteFeedLoader: RemoteFeedLoader(), localFeedLoader: LocalFeedLoader()).load
//
//let vc = FeedViewController(loader: loader)


/*

Hi Ricardo!

We believe your question will be answered as you progress in the course.

For now, let's illustrate Dependency Inversion with closures with a simple example.

Imagine you have two concrete components: `FeedViewController` and `APIClient`.

```
// Feed module
class FeedViewController {
  let client: APIClient
}

// API module
class APIClient {}

// Main module (Composition)
FeedViewController(client: APIClient())
```

In this case, the `FeedViewController` depends on the `APIClient`, but the `APIClient` does not depend on the `FeedViewController`.

FeedViewController → APIClient

or

Feed module → API module


As you already know, if you want to invert that dependency (e.g., to be able to load a feed from multiple sources, not just the API), you can use a protocol:

```
// Feed module
struct Feed {}

protocol FeedLoader {
  func load() -> Feed
}

class FeedViewController {
  let loader: FeedLoader
}

// API module
class APIClient: FeedLoader {
  func load() -> Feed {
    ...
  }
}

// Main module (Composition)
FeedViewController(loader: APIClient())
```

| FeedViewController → FeedLoader | ← APIClient

or

Feed module ← API module

We inverted the dependency.

You can achieve the same with a closure. In fact, every protocol with only one method can be easily replaced with a closure.

```
// Feed module
struct Feed {}

typealias FeedLoader = () -> Feed

class FeedViewController {
  let load: FeedLoader
}

// API module
class APIClient {
  func load() -> Feed {
    ...
  }
}

// Main module (Composition)
FeedViewController(loader: APIClient().load)
```

| FeedViewController → FeedLoader (closure) | ← APIClient

or

Feed module ← API module

In the closure solution, the interface is not a protocol, but the function type signature that must match `() -> Feed`.

The `APIClient` implements a function matching that type signature, so it can be used by the `FeedViewController`. And since we're using Dependency Injection in the Composition Root (Main), the Dependency Inversion is still valid.

Does it make sense now?

 */
