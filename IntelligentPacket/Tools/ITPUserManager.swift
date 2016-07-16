//
//  ITPUserManager.swift
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/19.
//  Copyright © 2016年 detu. All rights reserved.
//

//
import UIKit

class ITPUserManager: NSObject {
    
    
    // MARK: Current User Name
    var userName : String! {
        get {
            let key = NSUserDefaults.standardUserDefaults().objectForKey(ITPacketIsLogin)
            return key as? String
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey:ITPacketIsLogin)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    // MARK: Single Once 单例
    static let ShareInstanceOne = ITPUserManager();
    private override init(){} // 外界不能再初始化。
    
}
