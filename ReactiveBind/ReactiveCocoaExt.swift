import Foundation
import ReactiveCocoa

/// A shortcut for SignalProducer<A, B>.empty
public func emptyProducer<Value, Error>() -> SignalProducer<Value, Error> {
    return SignalProducer<Value, Error>.empty
}

extension SignalProducerType {
    /// Supresss the error from the signal producer. This is not recommended.
    public func suppressError() -> SignalProducer<Value, NoError> {
        return flatMapError { _ in SignalProducer<Value, NoError>.empty }
    }
}