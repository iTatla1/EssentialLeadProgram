import Foundation

//MARK:- Helping Documentation

/*
 
 Reference for singelton
 https://academy.essentialdeveloper.com/courses/447455/lectures/8528509
 
 A Singelton is a class that has only one instance and it can provides only a single access point to it. It could be extended/subclasses as per book.
 
 A singelton with small s is a convenience where you do have a shared instance but you can also create new instances as per your new configuration but you do not modify the orignol shared instance. Class example is URLSession.shared instance immutable accessor by URLSession class though you can make you own URLSession instances as well with your own configration.
 
 GLOBAL MUTABLE STATE: When your shared instnce is also mutable.
 
 ----------------------------------------------------------------------------
 
 Inheritance allows subclassing {Provide a way to override class beahaviour}
 P.S. with final keyword you prohibits subclassing
 
 With extensions you add new behaviour to you classes but does not override the originol behaviour
 
 ----------------------------------------------------------------------------
 
 */




//Your modules depend on a concrete class. We should follow dependency inversion where concrete class should depend on abstraction

//MARK:- Shared instance Bad approach

//------------ Code Here --------------- //

//class ApiClient {
//    static let instane = ApiClient()
//
//    private init() {}
//
//    func login(completion: (loggedInUser) -> Void){}
//    func feed(completion: (Feed) -> Void){}
//}
//
//class MockClient: ApiClient {
//
//}
//
//extension ApiClient{
////    override func login(){}
//}

//------------ Code Here --------------- //

/*
 
 We are trading of convenience with what we really need. We need only
 1) a function.
 
 But with following implementation we are
 1) KNOWING THE TYPE
 2) FINDINING CONCRETE INSTANCE
 3) THEN CALLING FUNCTION
 
 */


// -------------- CODE HERE ---------------- //

//struct loggedInUser{}
//class loginVM {
//    let client = ApiClient.instane
//
//    func loginTapped(){
//        client.login { (user) in
//        }
//    }
//}
//
//struct Feed{}
//class FeedVM {
//
//    let client = ApiClient.instane
//    func fetchFeed(){
//        client.feed { (feed) in
//        }
//    }
//}


// -------------- CODE HERE ---------------- //


//MARK:- Modular Approach

// NOTIC API CLIENT (CONCRETE CLASS) IS STILL SHARED

// API MODULE

// -------------- CODE HERE ---------------- //
//class ApiClient {
//    static let instane = ApiClient()
//
//
//    private init() {}
//
//    // Generic Execute Method
//    func excecute(_ url: URLRequest, completion: (Data) -> Void){}
//
//
//}
//
//
//
//
//
//// LOGIN MODULE
//extension ApiClient{
//    func login(completion: (loggedInUser) -> Void){}
//}
//struct loggedInUser{}
//class loginVM {
//    let client = ApiClient.instane
//
//    func loginTapped(){
//        client.login { (user) in
//        }
//    }
//}
//
//// FEED MODULE
//extension ApiClient{
//    func feed(completion: (Feed) -> Void){}
//}
//struct Feed{}
//class FeedVM {
//
//    let client = ApiClient.instane
//    func fetchFeed(){
//        client.feed { (feed) in
//        }
//    }
//}

// -------------- CODE HERE ---------------- //



//MARK:- Dependeny Inversion

/*
 
 Make protocols for login and feed dpendenices and make api client concrete class implement those as Feature needs something make concrete class provide that need.
 
 AS LOGIN FEATURE I NEED LOGIN BEHAVIOUR
 AS FEED FEATURE I NEED FEED BEHAVIOUR
 
 */
 

//With Protocols our modules wont be changed as we need consistent requiremnets and those requirements will be implemented by the CONCRETE Implementation of classes

//class ApiClient {
//    static let instane = ApiClient()
//    private init() {}
//
//    // Generic Execute Method
//    func excecute(_ url: URLRequest, completion: (Data) -> Void){}
//}
//
//
//// LOGIN MODULE
//extension ApiClient: ProvidesLogin{
//    func login(completion: (loggedInUser) -> Void){}
//}
//
//protocol ProvidesLogin{
//    func login(completion: (loggedInUser) -> Void)
//}
//struct loggedInUser{}
//
//class loginVM {
//    var provider: ProvidesLogin!
//
//    func loginTapped(){
//        provider.login { (user) in
//
//        }
//    }
//}
//
//// FEED MODULE
//extension ApiClient: ProvidesFeed{
//    func feed(completion: (Feed) -> Void){}
//}
//
//protocol ProvidesFeed{
//    func feed(completion: (Feed) -> Void)
//}
//struct Feed{}
//class FeedVM {
//
//    var provider: ProvidesFeed!
//    func fetchFeed(){
//        provider.feed { (feed) in
//        }
//    }
//}

// -------------- CODE HERE ---------------- //


//MARK:- Only depend on function

// Main Module
extension ApiClient{
    func feed(completion: (Feed) -> Void){}
}
extension ApiClient{
    func login(completion: (loggedInUser) -> Void){}
}
class ApiClient {
    static let instane = ApiClient()
    private init() {}
    
    // Generic Execute Method
    func excecute(_ url: URLRequest, completion: (Data) -> Void){}
}


// LOGIN MODULE
struct loggedInUser{}

class loginVM {
    var login: (((loggedInUser) -> Void) -> Void)?
    
    func loginTapped(){
        login?{user in
            
        }
    }
}

// FEED MODULE
struct Feed{}
class FeedVM {
    var feed: (((Feed) -> Void) -> Void)?
    func fetchFeed(){
        feed?{ feed in
            
        }
    }
}
