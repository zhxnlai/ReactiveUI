//
//  UIBarItem.swift
//  ReactiveControl
//
//  Created by Zhixuan Lai on 1/8/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    
    func addAction(action: UIBarButtonItem -> ()) {
        removeAction()
        
        proxyTarget = RUIBarButtonItemProxyTarget(action)
        target = proxyTarget
        self.action = RUIBarButtonItemProxyTarget.actionSelector()
    }
    
    func removeAction() {
        self.target = nil
        self.action = nil
    }
    
}

internal extension UIBarButtonItem {
    
    typealias RUIBarButtonItemProxyTargets = [String: RUIBarButtonItemProxyTarget]
    
    class RUIBarButtonItemProxyTarget: RUIProxyTarget {
        var action: UIBarButtonItem -> ()
        
        init(action: UIBarButtonItem -> ()) {
            self.action = action
        }
        
        func performAction(control: UIBarButtonItem) {
            action(control)
        }
    }
    
    var proxyTarget: RUIBarButtonItemProxyTarget {
        get {
            if let targets = objc_getAssociatedObject(self, &RUIProxyTargetsKey) as? RUIBarButtonItemProxyTarget {
                return targets
            } else {
                return setProxyTargets(RUIBarButtonItemProxyTarget({_ in}))
            }
        }
        set {
            setProxyTargets(newValue)
        }
    }
    
    private func setProxyTargets(newValue: RUIBarButtonItemProxyTarget) -> RUIBarButtonItemProxyTarget {
        objc_setAssociatedObject(self, &RUIProxyTargetsKey, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC));
        return newValue
    }
    
}