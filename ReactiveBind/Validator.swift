import ReactiveCocoa
import Result

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
    associatedtype Value
    
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
