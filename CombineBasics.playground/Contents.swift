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

