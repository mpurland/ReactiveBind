import UIKit
import ReactiveCocoa

extension UIView {
    public var rac_alpha: MutableProperty<CGFloat> {
        return lazyMutableProperty(self, &BindingAssociationKeys.AlphaProperty, { self.alpha = $0 }, { self.alpha  })
    }
    
    public var rac_hidden: MutableProperty<Bool> {
        return lazyMutableProperty(self, &BindingAssociationKeys.HiddenProperty, { self.hidden = $0 }, { self.hidden  })
    }
}

extension UIBarItem {
    public var rac_enabled: MutableProperty<Bool> {
        return lazyMutableProperty(self, &BindingAssociationKeys.EnabledProperty, { self.enabled = $0 }, { self.enabled  })
    }
}

extension UIControl {
    public var rac_enabled: MutableProperty<Bool> {
        return lazyMutableProperty(self, &BindingAssociationKeys.EnabledProperty, { self.enabled = $0 }, { self.enabled  })
    }
    public var rac_highlighted: MutableProperty<Bool> {
        return lazyMutableProperty(self, &BindingAssociationKeys.HighlightedProperty, { self.highlighted = $0 }, { self.highlighted  })
    }
    public var rac_selected: MutableProperty<Bool> {
        return lazyMutableProperty(self, &BindingAssociationKeys.SelectedProperty, { self.selected = $0 }, { self.selected  })
    }
}

extension UILabel {
    public var rac_text: MutableProperty<String?> {
        return lazyMutableProperty(self, &BindingAssociationKeys.TextProperty, { self.text = $0 }, { self.text  })
    }
    
    public var rac_attributedText: MutableProperty<NSAttributedString?> {
        return lazyMutableProperty(self, &BindingAssociationKeys.AttributedTextProperty, { self.attributedText = $0 }, { self.attributedText  })
    }
}

extension UITextField {
    public var rac_text: MutableProperty<String> {
        return lazyAssociatedProperty(self, &BindingAssociationKeys.TextProperty) {
            self.rac_signalForControlEvents(UIControlEvents.EditingChanged).toSignalProducer().startWithNext { _ in
                let value = self.text ?? ""
                self.rac_text.value = value
            }
            
            let property = MutableProperty<String>(self.text ?? "")
            
            property.producer.startWithNext { newValue in
                self.text = newValue
            }
            
            return property
        }
    }
}

extension UITextField {
    /// A property that represents the active status of whether the text field is being edited (active) or not being edited (not active)
    public var rac_active: SignalProducer<Bool, NoError> {
        let property = MutableProperty<Bool>(false)
        
        rac_signalForControlEvents(UIControlEvents.EditingDidBegin).toSignalProducer().startWithNext { _ in
            print("text field: \(self) active")
            property.value = true
        }
        
        rac_signalForControlEvents(UIControlEvents.EditingDidEnd).toSignalProducer().startWithNext { _ in
            print("text field: \(self) inactive")
            property.value = false
        }
        
        return property.producer.skip(1).skipRepeats()
    }
}

extension UIImageView {
    public var rac_image: MutableProperty<UIImage?> {
        return lazyMutableProperty(self, &BindingAssociationKeys.ImageProperty, { self.image = $0 }, { self.image })
    }
}