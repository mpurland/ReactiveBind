import UIKit
import ReactiveCocoa
import Result

extension UIView {
    public var rac_alpha: MutableProperty<CGFloat> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.AlphaProperty, { self.alpha = $0 }, { self.alpha  })
    }
    
    public var rac_hidden: MutableProperty<Bool> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.HiddenProperty, { self.hidden = $0 }, { self.hidden  })
    }
    
    public var rac_backgroundColor: MutableProperty<UIColor?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.BackgroundColorProperty, { self.backgroundColor = $0 }, { self.backgroundColor  })
    }
}

extension UIBarItem {
    public var rac_enabled: MutableProperty<Bool> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.EnabledProperty, { self.enabled = $0 }, { self.enabled  })
    }
}

extension UIButton {
    public var rac_normalTitle: MutableProperty<String?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.NormalTitleProperty, { self.setTitle($0, forState: .Normal) }, { self.titleForState(.Normal) })
    }
    
    public var rac_highlightedTitle: MutableProperty<String?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.HighlightedTitleProperty, { self.setTitle($0, forState: .Highlighted) }, { self.titleForState(.Highlighted) })
    }

    public var rac_selectedTitle: MutableProperty<String?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.SelectedTitleProperty, { self.setTitle($0, forState: .Selected) }, { self.titleForState(.Selected) })
    }

    public var rac_disabledTitle: MutableProperty<String?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.DisabledTitleProperty, { self.setTitle($0, forState: .Disabled) }, { self.titleForState(.Disabled) })
    }
}

extension UIControl {
    public var rac_enabled: MutableProperty<Bool> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.EnabledProperty, { self.enabled = $0 }, { self.enabled  })
    }
    
    public var rac_highlighted: MutableProperty<Bool> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.HighlightedProperty, { self.highlighted = $0 }, { self.highlighted  })
    }
    
    public var rac_selected: MutableProperty<Bool> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.SelectedProperty, { self.selected = $0 }, { self.selected  })
    }
}

extension UILabel {
    public var rac_text: MutableProperty<String?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.TextProperty, { self.text = $0 }, { self.text  })
    }
    
    public var rac_attributedText: MutableProperty<NSAttributedString?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.AttributedTextProperty, { self.attributedText = $0 }, { self.attributedText  })
    }

    public var rac_textColor: MutableProperty<UIColor?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.TextColorProperty, { self.textColor = $0 }, { self.textColor })
    }
}

extension UITextField {
    public var rac_text: MutableProperty<String> {
        return lazyAssociatedProperty(self, &ReactiveBindAssocationKeys.TextProperty) {
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
    
    public var rac_attributedText: MutableProperty<NSAttributedString?> {
        return lazyAssociatedProperty(self, &ReactiveBindAssocationKeys.AttributedTextProperty) {
            self.rac_signalForControlEvents(UIControlEvents.EditingChanged).toSignalProducer().startWithNext { _ in
                let value = self.attributedText
                self.rac_attributedText.value = value
            }
            
            let property = MutableProperty<NSAttributedString?>(self.attributedText)
            
            property.producer.startWithNext { newValue in
                self.attributedText = newValue
            }
            
            return property
        }
    }
    
    public var rac_textColor: MutableProperty<UIColor?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.TextColorProperty, { self.textColor = $0 }, { self.textColor })
    }

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
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.ImageProperty, { self.image = $0 }, { self.image })
    }
}

extension UITableViewCell {
    public var rac_highlighted: MutableProperty<Bool> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.HighlightedProperty, { self.highlighted = $0 }, { self.highlighted })
    }
    
    public var rac_selected: MutableProperty<Bool> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.SelectedProperty, { self.selected = $0 }, { self.selected })
    }
}

extension UICollectionViewCell {
    public var rac_highlighted: MutableProperty<Bool> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.HighlightedProperty, { self.highlighted = $0 }, { self.highlighted })
    }
    
    public var rac_selected: MutableProperty<Bool> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.SelectedProperty, { self.selected = $0 }, { self.selected })
    }
}

extension UIViewController {
    public var rac_title: MutableProperty<String?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.TitleProperty, { self.title = $0 }, { self.title })
    }
    
    public var rac_titleView: MutableProperty<UIView?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.TitleViewProperty, { self.navigationItem.titleView = $0 }, { self.navigationItem.titleView })
    }
    
    public var rac_leftBarButtonItem: MutableProperty<UIBarButtonItem?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.LeftBarButtonItemProperty, { self.navigationItem.leftBarButtonItem = $0 }, { self.navigationItem.leftBarButtonItem })
    }
    
    public var rac_leftBarButtonItems: MutableProperty<[UIBarButtonItem]?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.LeftBarButtonItemsProperty, { self.navigationItem.leftBarButtonItems = $0 }, { self.navigationItem.leftBarButtonItems })
    }
    
    public var rac_rightBarButtonItem: MutableProperty<UIBarButtonItem?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.RightBarButtonItemProperty, { self.navigationItem.rightBarButtonItem = $0 }, { self.navigationItem.rightBarButtonItem })
    }
    
    public var rac_rightBarButtonItems: MutableProperty<[UIBarButtonItem]?> {
        return lazyMutableProperty(self, &ReactiveBindAssocationKeys.RightBarButtonItemsProperty, { self.navigationItem.rightBarButtonItems = $0 }, { self.navigationItem.rightBarButtonItems })
    }
}