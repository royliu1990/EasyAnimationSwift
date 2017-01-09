//
//  EASCKAFactor.swift
//  MegaBoxDemo
//
//  Created by royliu1990 on 2016/12/29.
//  Copyright © 2016年 royliu1990. All rights reserved.
//

import UIKit

typealias ckparam = (type:String,values:[Any],beginTime:Double,keyTimes:[Double],timingFunctions:[CAMediaTimingFunction],duration:Double ,autoreverses:Bool,repeatCount:Int)

 class EASParam:NSObject {
    var type:String
    var values:[Any]
    var beginTime:Double = 0
    var keyTimes:[Double]
    var timingFunctions:[CAMediaTimingFunction]?
    var duration:Double = 0.2
    var autoreverses:Bool = false
    var repeatCount:Int = 0
    
    init(type:String,values:[Any]) {
        self.type = type
        self.values = values
        
        let timeunit = 1.0/Double(self.values.count - 1)
        
        self.keyTimes = [Double]()
        
        self.keyTimes.append(0)
        
        if(self.values.count == 0)
        {
            
            return
        }
        for i in 1 ..< self.values.count
        {
            self.keyTimes.append(timeunit + self.keyTimes[i-1])
        }
        
        self.timingFunctions = Array(repeating:CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut),count:values.count+1)
    }
    
}


class EASCKAFactor: NSObject {
    
    class func keyFrameAnimation(type:String,values:[Any]) -> CAKeyframeAnimation {
        let param = EASParam(type:type,values:values)
        
        return keyFrameAnimation(params: param)
    }
    
//    class func dampingShakeHorizontal(center:CGPoint,width:CGFloat,amplitude:Double = 0.2,damp:Double = 0.2)
//    {
//        
//        let damp = EASKeyValues.dampingCal(amplitude, damp)
//        
//        
//        print(damp)
//
//    }

    private class func keyFrameAnimation(params:EASParam) -> CAKeyframeAnimation
    {
        let ani = CAKeyframeAnimation(keyPath: params.type)
        ani.values = params.values
        ani.beginTime = params.beginTime
        ani.keyTimes = params.keyTimes as [NSNumber]?
        ani.duration = params.duration
        ani.autoreverses = params.autoreverses
        ani.repeatCount = Float(params.repeatCount)
        ani.isRemovedOnCompletion = false
        ani.timingFunctions = params.timingFunctions
        ani.fillMode = kCAFillModeForwards
        
        return ani
    }
}
