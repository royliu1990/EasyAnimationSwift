//
//  EASUtils.swift
//  MegaBoxDemo
//
//  Created by royliu1990 on 2016/12/24.
//  Copyright © 2016年 royliu1990. All rights reserved.
//

import UIKit




func DEGREES_TO_RADIUS(degrees:Double) -> Double{
    return degrees / 180.0 * M_PI
}

func  RADIUS_TO_DEGRESS(radius:Double) -> Double{
    return radius * 180.0 /  M_PI
}

extension CGPoint
{
    func polarPosition(angle:CGFloat,radius:CGFloat) -> CGPoint {
        return CGPoint(x:self.x+radius*cos(angle),y:self.y+radius*sin(angle))
    }
    
    func pointScale(origin:CGPoint,scale:CGFloat) -> CGPoint {
        return CGPoint(x:(self.x - origin.x)*scale+origin.x,y:(self.y - origin.y)*scale+origin.y)
    }
    
    func plus(_ point:CGPoint) -> CGPoint  {
        return CGPoint(x:self.x + point.x,y:self.y + point.y)
    }
    
    func minus(_ point:CGPoint) -> CGPoint  {
        return CGPoint(x:self.x - point.x,y:self.y - point.y)
    }
    
    func plus(_ t:(x:Float,y:Float)) -> CGPoint  {
        return CGPoint(x:self.x + CGFloat(t.x),y:self.y + CGFloat(t.y))
    }
    
    func minus(_ t:(x:Float,y:Float)) -> CGPoint  {
        return CGPoint(x:self.x - CGFloat(t.x),y:self.y - CGFloat(t.y))
    }
}









