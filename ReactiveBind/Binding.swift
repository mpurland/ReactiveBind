import Foundation
import ReactiveCocoa

private enum BindingAssocationKey: String {
    case Hidden
    case Alpha
    case Text
    case AttributedText
    case Enabled
    case Highlighted
    case Selected
    case Image
}

struct BindingAssociationKeys {
    static var HiddenProperty = BindingAssocationKey.Hidden.rawValue
    static var AlphaProperty = BindingAssocationKey.Alpha.rawValue
    static var TextProperty = BindingAssocationKey.Text.rawValue
    static var AttributedTextProperty = BindingAssocationKey.AttributedText.rawValue
    static var EnabledProperty = BindingAssocationKey.Enabled.rawValue
    static var HighlightedProperty = BindingAssocationKey.Highlighted.rawValue
    static var SelectedProperty = BindingAssocationKey.Selected.rawValue
    static var ImageProperty = BindingAssocationKey.Image.rawValue
}

func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, _ key: UnsafePointer<Void>, _ factory: ()->T) -> T {
    var associatedProperty = objc_getAssociatedObject(host, key) as? T
    
    if associatedProperty == nil {
        associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    return associatedProperty!
}

func lazyMutableProperty<T>(host: AnyObject, _ key: UnsafePointer<Void>, _ setter: T -> (), _ getter: () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key) {
        let property = MutableProperty<T>(getter())
        property.producer.startWithNext { newValue in
            setter(newValue)
        }
        return property
    }
}

func lazyMutablePropertyDefaultValue<T>(host: AnyObject, _ key: UnsafePointer<Void>, _ defaultValue: () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key) {
        let property = MutableProperty<T>(defaultValue())
        return property
    }
}

func lazyMutablePropertyOptional<T>(host: AnyObject, _ key: UnsafePointer<Void>, _ setter: T? -> (), _ getter: () -> T?) -> MutableProperty<T?> {
    return lazyAssociatedProperty(host, key) {
        let property = MutableProperty<T?>(getter())
        property.producer.startWithNext { newValue in
            setter(newValue)
        }
        return property
    }
}