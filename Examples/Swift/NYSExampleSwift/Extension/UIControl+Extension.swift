//
//  UIControl+Extension.swift
//  NYSAppSwift
//
//  Created by Nico http://github.com/niyongsheng
//  Copyright © 2023 NYS. ALL rights reserved.
//

import UIKit
import ObjectiveC.runtime

private var blockKey: Int = 0

private class UIControlBlockTarget {
    var block: ((Any) -> Void)?
    var events: UIControl.Event
    
    init(block: @escaping (Any) -> Void, events: UIControl.Event) {
        self.block = block
        self.events = events
    }
    
    @objc func invoke(_ sender: Any) {
        block?(sender)
    }
}

extension UIControl {
    private var allBlockTargets: [UIControlBlockTarget] {
        get {
            return objc_getAssociatedObject(self, &blockKey) as? [UIControlBlockTarget] ?? []
        }
        set {
            objc_setAssociatedObject(self, &blockKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func removeAllTargets() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .allEvents)?.forEach { action in
                removeTarget(target, action: NSSelectorFromString(action), for: .allEvents)
            }
        }
        allBlockTargets.removeAll()
    }
    
    func setTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        guard let target = target, controlEvents != [] else { return }
        allTargets.forEach { currentTarget in
            actions(forTarget: currentTarget, forControlEvent: controlEvents)?.forEach { currentAction in
                removeTarget(currentTarget, action: NSSelectorFromString(currentAction), for: controlEvents)
            }
        }
        addTarget(target, action: action, for: controlEvents)
    }
    
    func addBlock(for controlEvents: UIControl.Event, block: @escaping (Any) -> Void) {
        guard controlEvents != [] else { return }
        let target = UIControlBlockTarget(block: block, events: controlEvents)
        addTarget(target, action: #selector(UIControlBlockTarget.invoke(_:)), for: controlEvents)
        allBlockTargets.append(target)
    }
    
    func setBlock(for controlEvents: UIControl.Event, block: @escaping (Any) -> Void) {
        removeAllBlocks(for: .allEvents)
        addBlock(for: controlEvents, block: block)
    }
    
    internal func removeAllBlocks(for controlEvents: UIControl.Event) {
        guard controlEvents != [] else { return }
        allBlockTargets = allBlockTargets.filter { target in
            removeTarget(target, action: #selector(UIControlBlockTarget.invoke(_:)), for: target.events)
            return !controlEvents.contains(target.events)
        }
    }
    
}
