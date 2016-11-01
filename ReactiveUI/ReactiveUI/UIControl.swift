//
//  UIControl.swift
//  ReactiveControl
//
//  Created by Zhixuan Lai on 1/8/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

public extension UIControl {
    
    convenience init(action: @escaping (UIControl) -> (), forControlEvents events: UIControlEvents) {
        self.init()
        addAction(action, forControlEvents: events)
    }
    
    convenience init(forControlEvents events: UIControlEvents, action: @escaping (UIControl) -> ()) {
        self.init()
        addAction(action, forControlEvents: events)
    }
    
    func addAction(_ action: @escaping (UIControl) -> (), forControlEvents events: UIControlEvents) {
        removeAction(forControlEvents: events)

        let proxyTarget = RUIControlProxyTarget(action: action)
        proxyTargets[keyForEvents(events)] = proxyTarget
        addTarget(proxyTarget, action: RUIControlProxyTarget.actionSelector(), for: events)
    }

    func forControlEvents(events: UIControlEvents, addAction action: @escaping (UIControl) -> ()) {
        addAction(action, forControlEvents: events)
    }
    
    func removeAction(forControlEvents events: UIControlEvents) {
        if let proxyTarget = proxyTargets[keyForEvents(events)] {
            removeTarget(proxyTarget, action: RUIControlProxyTarget.actionSelector(), for: events)
            proxyTargets.removeValue(forKey: keyForEvents(events))
        }
    }
    
    func actionForControlEvent(events: UIControlEvents) -> ((UIControl) -> ())? {
        return proxyTargets[keyForEvents(events)]?.action
    }
    
    var actions: [(UIControl) -> ()] {
        return [RUIControlProxyTarget](proxyTargets.values).map({$0.action})
    }
    
}

internal extension UIControl {
    
    typealias RUIControlProxyTargets = [String: RUIControlProxyTarget]
    
    class RUIControlProxyTarget : RUIProxyTarget {
        var action: (UIControl) -> ()
        
        init(action: @escaping (UIControl) -> ()) {
            self.action = action
        }
        
        func performAction(_ control: UIControl) {
            action(control)
        }
    }
    
    func keyForEvents(_ events: UIControlEvents) -> String {
        return "UIControlEvents: \(events.rawValue)"
    }

    var proxyTargets: RUIControlProxyTargets {
        get {
            if let targets = objc_getAssociatedObject(self, &RUIProxyTargetsKey) as? RUIControlProxyTargets {
                return targets
            } else {
                return setProxyTargets(RUIControlProxyTargets())
            }
        }
        set {
            setProxyTargets(newValue)
        }
    }
    
    private func setProxyTargets(_ newValue: RUIControlProxyTargets) -> RUIControlProxyTargets {
        objc_setAssociatedObject(self, &RUIProxyTargetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return newValue
    }
    
}
