import Foundation
import ReactiveCocoa

#if DEBUG
    internal func assertMainThread() {
        assert(NSThread.isMainThread(), "Must be main thread.")
    }
    
    internal func assertBackgroundThread() {
        assert(!NSThread.isMainThread(), "Must be background thread.")
    }
#else
    internal func assertMainThread() {}
    internal func assertBackgroundThread() {}
#endif

public enum ReactiveBindAssocationKey: String {
    case Hidden
    case Alpha
    case BackgroundColor
    case Text
    case NormalTitle
    case HighlightedTitle
    case SelectedTitle
    case DisabledTitle
    case AttributedText
    case TextColor
    case Enabled
    case Highlighted
    case Selected
    case Image
    case Title
    case TitleView
    case LeftBarButtonItem
    case LeftBarButtonItems
    case RightBarButtonItem
    case RightBarButtonItems
}

public struct ReactiveBindAssocationKeys {
    static var HiddenProperty = ReactiveBindAssocationKey.Hidden.rawValue
    static var AlphaProperty = ReactiveBindAssocationKey.Alpha.rawValue
    static var BackgroundColorProperty = ReactiveBindAssocationKey.BackgroundColor.rawValue
    static var TextProperty = ReactiveBindAssocationKey.Text.rawValue
    static var NormalTitleProperty = ReactiveBindAssocationKey.NormalTitle.rawValue
    static var HighlightedTitleProperty = ReactiveBindAssocationKey.HighlightedTitle.rawValue
    static var SelectedTitleProperty = ReactiveBindAssocationKey.SelectedTitle.rawValue
    static var DisabledTitleProperty = ReactiveBindAssocationKey.DisabledTitle.rawValue
    static var AttributedTextProperty = ReactiveBindAssocationKey.AttributedText.rawValue
    static var TextColorProperty = ReactiveBindAssocationKey.TextColor.rawValue
    static var EnabledProperty = ReactiveBindAssocationKey.Enabled.rawValue
    static var HighlightedProperty = ReactiveBindAssocationKey.Highlighted.rawValue
    static var SelectedProperty = ReactiveBindAssocationKey.Selected.rawValue
    static var ImageProperty = ReactiveBindAssocationKey.Image.rawValue
    static var TitleProperty = ReactiveBindAssocationKey.Title.rawValue
    static var TitleViewProperty = ReactiveBindAssocationKey.TitleView.rawValue
    static var LeftBarButtonItemProperty = ReactiveBindAssocationKey.LeftBarButtonItem.rawValue
    static var LeftBarButtonItemsProperty = ReactiveBindAssocationKey.LeftBarButtonItems.rawValue
    static var RightBarButtonItemProperty = ReactiveBindAssocationKey.RightBarButtonItem.rawValue
    static var RightBarButtonItemsProperty = ReactiveBindAssocationKey.RightBarButtonItems.rawValue
}

public func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, _ key: UnsafePointer<Void>, _ factory: ()->T) -> T {
    var associatedProperty = objc_getAssociatedObject(host, key) as? T
    
    if associatedProperty == nil {
        assertMainThread()
        associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    return associatedProperty!
}

public func lazyMutableProperty<T>(host: AnyObject, _ key: UnsafePointer<Void>, _ setter: T -> (), _ getter: () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key) {
        let property = MutableProperty<T>(getter())
        
        property.producer.startWithNext { newValue in
            assertMainThread()
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
            assertMainThread()
            setter(newValue)
        }
        
        return property
    }
}