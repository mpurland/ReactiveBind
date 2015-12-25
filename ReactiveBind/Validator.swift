import Foundation
import ReactiveCocoa

/// Property validator
protocol PropertyValidator {
    typealias Value
    func rac_valid(validator: Value -> Bool) -> SignalProducer<Bool, NoError>
}

protocol ValidatablePropertyType: PropertyType, PropertyValidator {
}

/// A property type that is validatable from PropertyValidator
extension ValidatablePropertyType {
    /// A signal producer that reacts to the text field text changes and uses the given validator and returns if the text is valid.
    func rac_valid(validator: Value -> Bool) -> SignalProducer<Bool, NoError> {
        return producer.map { validator($0) }
    }
}

/// ReactiveCocoa validatable properties
extension ConstantProperty: ValidatablePropertyType {}
extension MutableProperty: ValidatablePropertyType {}
extension DynamicProperty: ValidatablePropertyType {}