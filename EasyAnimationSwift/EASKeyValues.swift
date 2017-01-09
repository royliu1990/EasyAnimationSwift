//
//  EASKeyValues.swift
//  MegaBoxDemo
//
//  Created by royliu1990 on 2016/12/28.
//  Copyright © 2016年 royliu1990. All rights reserved.
//


import UIKit


class EASKeyValues:NSObject
{
    
    
    public let popvalue = (type:"transform.scale",values:[1,0.8,1.1,1.0],beginTime:1,duration:0.2,autoreverses:false,repeatCount:0)
    
    
    
    class func dampingCal(_ _A:Double,_ D:Double) ->(values:[Double],keyTimes:[Double])
    {
        
        var A = _A
        
        var x = [Double]()
        
        var t = [Double]()
        
        var i = -1
        
        var s:Double = 0.0
        
        x.append(1.0)
        
        t.append(0)
        
        x.append(1.0.advanced(by:A.multiplied(by: Double(i))))
        
        t.append(Double(A))
        
        s+=Double(A)
        
        A = A*(1-D)
        
        while(A>D/10)
        {
            i = -i
            
            x.append(1.0.advanced(by:A.multiplied(by: Double(i))))
            
            t.append(t.last! + A + A/(1-D))
            
            s += A + A/(1-D)
            
            A = A*(1-D)

            
        }
        
        x.append(1.0)
        
        s += A/(1-D)
        
        t.append(s)
        
        t = t.map{return $0/s}
        
        return (x,t)
        
    }

    
    class func fanShaped(center:CGPoint,startRadius:Double,endRadius:Double,startAngle:Double,endAngle:Double,density:Int,fractalRates:[Double]) -> [[CGPoint]]{
        
        let deltaAngle = (endAngle - startAngle).divided(by: Double(density - 1))
        
        let deltaRadius = (endRadius - startRadius).divided(by: Double(density - 1))
        
        var shape = [[CGPoint]]()
        
        for i in 0 ..< density
        {
            let point = center.polarPosition(angle: CGFloat(startAngle.advanced(by: deltaAngle.multiplied(by: Double(i)))), radius: CGFloat(startRadius.advanced(by: deltaRadius.multiplied(by: Double(i)))))
            
            var values = [CGPoint]()
            
            
            
            for j in 0 ..< fractalRates.count
            {
                values.append(point.pointScale(origin: center, scale: CGFloat(fractalRates[j])))
            }
            
            shape.append(values)
        }
        
        return shape
    }
    
    
}
