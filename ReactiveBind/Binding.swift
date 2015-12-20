import Foundation
import ReactiveCocoa

public enum ReactiveBindAssocationKey: String {
    case Hidden
    case Alpha
    case BackgroundColor
    case Text
    case AttributedText
    case Enabled
    case Highlighted
    case Selected
    case Image
}

public struct ReactiveBindAssocationKeys {
    static var HiddenProperty = ReactiveBindAssocationKey.Hidden.rawValue
    static var AlphaProperty = ReactiveBindAssocationKey.Alpha.rawValue
    static var BackgroundColorProperty = ReactiveBindAssocationKey.BackgroundColor.rawValue
    static var TextProperty = ReactiveBindAssocationKey.Text.rawValue
    static var AttributedTextProperty = ReactiveBindAssocationKey.AttributedText.rawValue
    static var EnabledProperty = ReactiveBindAssocationKey.Enabled.rawValue
    static var HighlightedProperty = ReactiveBindAssocationKey.Highlighted.rawValue
    static var SelectedProperty = ReactiveBindAssocationKey.Selected.rawValue
    static var ImageProperty = ReactiveBindAssocationKey.Image.rawValue
}

public func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, _ key: UnsafePointer<Void>, _ factory: ()->T) -> T {
    var associatedProperty = objc_getAssociatedObject(host, key) as? T
    
    if associatedProperty == nil {
        associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    return associatedProperty!
}

public func lazyMutableProperty<T>(host: AnyObject, _ key: UnsafePointer<Void>, _ setter: T -> (), _ getter: () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key) {
        let property = MutableProperty<T>(getter())
        
        property.producer.startWithNext { newValue in
            setter(newValue)
        }
        
        return property
    }
}

public func lazyMutablePropertyDefaultValue<T>(host: AnyObject, _ key: UnsafePointer<Void>, _ defaultValue: () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key) {
        let property = MutableProperty<T>(defaultValue())
        return property
    }
}

public func lazyMutablePropertyOptional<T>(host: AnyObject, _ key: UnsafePointer<Void>, _ setter: T? -> (), _ getter: () -> T?) -> MutableProperty<T?> {
    return lazyAssociatedProperty(host, key) {
        let property = MutableProperty<T?>(getter())
        
        property.producer.startWithNext { newValue in
            setter(newValue)
        }
        
        return property
    }
}