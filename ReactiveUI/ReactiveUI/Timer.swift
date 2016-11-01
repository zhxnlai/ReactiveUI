//
//  Timer.swift
//  ReactiveUI
//
//  Created by Zhixuan Lai on 2/2/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

public extension Timer {
    // Big thanks to https://github.com/ashfurrow/Haste
    class func scheduledTimerWithTimeInterval(seconds: TimeInterval, action: @escaping (Timer) -> (), repeats: Bool) -> Timer {
        return scheduledTimer(timeInterval: seconds, target: self, selector: "_timerDidFire:", userInfo: RUITimerProxyTarget(action: action), repeats: repeats)
    }
}

internal extension Timer {
    
    class func _timerDidFire(timer: Timer) {
        if let proxyTarget = timer.userInfo as? RUITimerProxyTarget {
            proxyTarget.performAction(timer)
        }
    }
    
    typealias RUITimerProxyTargets = [String: RUITimerProxyTarget]
    
    class RUITimerProxyTarget : RUIProxyTarget {
        var action: (Timer) -> ()

        init(action: @escaping (Timer) -> ()) {
            self.action = action
        }

        func performAction(_ control: Timer) {
            action(control)
        }
    }
    
    var proxyTarget: RUITimerProxyTarget {
        get {
            if let targets = objc_getAssociatedObject(self, &RUIProxyTargetsKey) as? RUITimerProxyTarget {
                return targets
            } else {
                return setProxyTargets(RUITimerProxyTarget(action: {_ in}))
            }
        }
        set {
            setProxyTargets(newValue)
        }
    }
    
    private func setProxyTargets(_ newValue: RUITimerProxyTarget) -> RUITimerProxyTarget {
        objc_setAssociatedObject(self, &RUIProxyTargetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return newValue
    }
    
}
