import Foundation
import Combine


/*
 Publishers
 everything in Combine is a Publisher or something that operates on or subscribes to values emitted by a Publisher.
 Arrays, Strings or Dictionaries can be converted to Publishers in Combine.
 */

let arrayPubisher = [1,2,3,4,5,6].publisher

/*
 You subscribe to publishers by calling
 sink(receiveValue: (value -> Void))
 The passed block will receive all values emitted by that publisher.
 */

_ = arrayPubisher.sink(receiveValue: { value in
    print(value)
})
print("************************")
/*
 Publishers can emit zero or more values over their lifetimes.
 Besides the basic values your Publisher also emits special values represented by the Subscribers.Completion enum.
 
 .finished will be emitted if the subscription is finished
 .failure(_) will be emitted if something went wrong
 The associated value for the failure case can be a custom Object, an Error or a special Never object that indicates that the Publisher won’t fail.
 */

let fibonacciPublisher = [0,1,1,2,3,5,8].publisher

_ = fibonacciPublisher.sink(receiveCompletion: { completion in
    switch(completion) {
    case .finished:
        print("finished")
    case.failure(let never):
        print(never)
    }
}, receiveValue: { value in
    print(value)
})

print("************************")

//If you want to cancel a subscription you can do that by calling cancel on it.

let numberPublisher = [1,3,4,4,2,4,5,4,3].publisher

let subscriber = numberPublisher.sink { value in
    print(value)
}
subscriber.cancel()

print("************************")


/*
 A subject is aspecial form of publisher, you can subscribe and add dynamically add elements to it.
 PassthroughSubject -> If you subscribe to it you will get all the events that will happen after you subscribed.
 CurrentValueSubject -> will give any subscriber the most recent element and everything that is emitted by that sequence after the subscription happened.
 */


// PassthroughSubject


let weatherPublisher = PassthroughSubject<Int, Never>()

let weatherSubcriber = weatherPublisher
    .filter { $0 > 25 }
    .sink { value in
        print("Its hot with temperature of \(value) degrees")
    }


weatherPublisher.send(24)
weatherPublisher.send(27)
weatherPublisher.send(28)
weatherPublisher.send(23)
weatherPublisher.send(20)
weatherPublisher.send(30)
weatherPublisher.send(34)
weatherPublisher.send(21)
weatherPublisher.send(29)
weatherPublisher.send(35)
weatherPublisher.send(15)

// adavanced example of passThrough Subject

struct ChatRoom {
    enum Error: Swift.Error {
        case shittyConnection
    }
    
    let subject = PassthroughSubject<String, Error>()
    
    func simulateMessage() {
        subject.send("Hello")
    }
    
    func simulateError() {
        subject.send(completion: .failure(.shittyConnection))
    }
    
    func closeRoom() {
        subject.send("Bye! chat room closed")
        subject.send(completion: .finished)
    }
}

let chatRoomSubscriber = ChatRoom()
chatRoomSubscriber.subject
    .sink { completion in
        switch(completion) {
        case .finished:
            print("finished")
        case .failure(let error):
            print("error \(error)")
        }
    } receiveValue: { message in
        print("message received: \(message)")
    }

// Happy flow (uncomment and run)
//chatRoomSubscriber.simulateMessage()
//chatRoomSubscriber.closeRoom()

// Error flow (comment while running happyflow)
chatRoomSubscriber.simulateMessage()
chatRoomSubscriber.simulateError()

print("**************************")

//CurrentValueSubject


