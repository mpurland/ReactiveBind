import Foundation
import ReactiveCocoa

public typealias StringValidatorAction = Action<String, Bool, NoError>

/// Create a validator action from a validator function
public func validatorAction(validator: String -> Bool) -> StringValidatorAction {
    return StringValidatorAction({ (string) -> SignalProducer<Bool, NoError> in
        let valid = validator(string)
        return SignalProducer(value: valid)
    })
}

/// Property validator
public protocol PropertyValidator {
    typealias Value
    
    func rac_valid(validator: Value -> Bool) -> SignalProducer<Bool, NoError>
}

public protocol ValidatablePropertyType: PropertyType, PropertyValidator {
}

/// A property type that is validatable from PropertyValidator
extension ValidatablePropertyType {
    /// A signal producer that reacts to the text field text changes and uses the given validator and returns if the text is valid.
    public func rac_valid(validator: Value -> Bool) -> SignalProducer<Bool, NoError> {
        return producer.map(validator)
    }
}

/// ReactiveCocoa validatable properties
extension ConstantProperty: ValidatablePropertyType {}
extension MutableProperty: ValidatablePropertyType {}
extension DynamicProperty: ValidatablePropertyType {}

/// Validator extensions for UITextField
extension UITextField {
    /// A signal producer that reacts to the text field text changes and uses the given validator and returns if the text is valid.
    public func rac_valid(validator: String -> Bool) -> SignalProducer<Bool, NoError> {
        return rac_text.producer.map(validator)
    }
    
    /// A signal producer that reacts to the text field text changes and uses the given validator action and returns if the text is valid.
    public func rac_valid(validatorAction: Action<String, Bool, NoError>) -> SignalProducer<Bool, NoError> {
        return rac_text.producer.flatMap(FlattenStrategy.Latest) { validatorAction.apply($0).suppressError() }
    }
}