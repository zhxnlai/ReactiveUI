# Reactive UI
A lightweight replacement for target action with closures, modified from [Scream.swift](https://github.com/tangplin/Scream.swift).

Why?
---

In UIKit, [Target-Action](https://developer.apple.com/library/ios/documentation/General/Conceptual/CocoaEncyclopedia/Target-Action/Target-Action.html) has been the default way to handle control events until the arrival of iOS 8 where [UIAlertController](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIAlertController_class/) introduces closure handler in [UIAlertAction](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIAlertAction_Class/index.html#//apple_ref/swift/cl/UIAlertAction).

Closure handlers, in many cases, are more concise and readable than Target-Action. ReactiveUI follows this approach, wrapping existing Target-Action APIs
~~~swift
// UIControl
func addTarget(_ target: AnyObject?, action action: Selector, forControlEvents controlEvents: UIControlEvents)

// UIGestureRecognizer
init(target target: AnyObject, action action: Selector)
~~~
in closures
~~~swift
// UIControl
func addAction(action: UIControl -> (), forControlEvents events: UIControlEvents)

// UIGestureRecognizer
init(action: UIGestureRecognizer -> ()) {
~~~

With ReactiveUI, control events handling is now much simpler:
~~~swift
var button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
button.setTitle("Title", forState: .Normal)
button.addAction({_ in println("TouchDown")}, forControlEvents: .TouchDown)
button.addAction({_ in println("TouchUpInside")}, forControlEvents: .TouchUpInside)
button.addAction({_ in println("TouchDragOutside")}, forControlEvents: .TouchDragOutside)
~~~

Usage
---
Checkout the [demo app](https://github.com/zhxnlai/ReactiveUI/tree/master/ReactiveUIDemo) for an example.

ReactiveUI currently supports UIControl, UIBarButtonItem and UIGestureRecognizer.

###UIControl
~~~swift
func addAction(action: UIControl -> (), forControlEvents events: UIControlEvents)
func removeAction(events: UIControlEvents)
var actions: [UIControl -> ()]
~~~
###UIBarButtonItem
~~~swift
func addAction(action: UIBarButtonItem -> ())
func removeAction()
~~~
###UIGestureRecognizer
~~~swift
func addAction(action: UIGestureRecognizer -> ())
func removeAction()
~~~

License
---
ReactiveUI is available under MIT license. See the LICENSE file for more info.
