import Foundation
import ReactiveCocoa
import Result

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

/// Bind an optional of MutablePropertyType to a Signal.
public func <~ <P: MutablePropertyType>(property: P?, signal: Signal<P.Value, NoError>) -> Disposable? {
    if let property = property {
        let disposable: Disposable = property <~ signal
        return disposable
    }
    
    return nil
}

/// Bind an optional of MutablePropertyType to a SignalProducer.
public func <~ <P: MutablePropertyType>(property: P?, signal: SignalProducer<P.Value, NoError>) -> Disposable? {
    if let property = property {
        let disposable: Disposable = property <~ signal
        return disposable
    }
    
    return nil
}