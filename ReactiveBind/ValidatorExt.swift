import UIKit
import ReactiveCocoa
    
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