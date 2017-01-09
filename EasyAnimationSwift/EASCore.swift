//
//  EASCore.swift
//  MegaBoxDemo
//
//  Created by royliu1990 on 2016/12/29.
//  Copyright © 2016年 royliu1990. All rights reserved.
//

import UIKit


//接口
protocol EASAnimatable
{
    func register(animation:CAKeyframeAnimation,forKey:String,relativeBeginTime:Double,animated:@escaping ()->(),reversed:@escaping ()->())
    
    func register(animation:[CAKeyframeAnimation],forKey:String,relativeBeginTime:Double,reverse:Bool,repeatCount:Float,animated:@escaping ()->(),reversed:@escaping ()->())
    
    func animate(key:String)
    
    func reverse(key:String,totalDuration:Double)
    
    var noTransition:Bool { set get }
}


var RBT = ""

extension CAAnimation
{
    var relativeBeginTime:TimeInterval{
        
        get {
            
            if(objc_getAssociatedObject(self, &RBT) == nil){
                return 0
            }
            
            return ((objc_getAssociatedObject(self, &RBT) as? [Double])?.last)!
        }
        set  {
            
            var container = [Double]()
            
            
            container.append(newValue)
            
            objc_setAssociatedObject(self, &RBT, container, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            
        }
        
        
    }
    
    
}



 class registed{
    var animation:CAAnimation
    var reversion:CAAnimation
    var animated:[()->()]
    var reversed:[()->()]
    
    init(_ animation:CAAnimation,_ reversion:CAAnimation,_ animated: [()->()],_ reversed: [()->()]) {
            self.animation = animation
            self.reversion = reversion
            self.animated = animated
            self.reversed = reversed
        
    }
    
}



var EAS_ANIMATION = ""

var EAS_ANIMATION_R = ""

var EAS_BLOCK = ""

var EAS_BLOCK_R = ""

var EAS_POINT = ""

var EAS_SCALE_X = ""

var EAS_SCALE_Y = ""

var EAS_ROTATION = ""

var NO_TRANSITION = ""

var IS_REVERSING = ""

var SYNC_FRAME = ""

var ANI_IDS = ""



extension UIView:EASAnimatable,CAAnimationDelegate  {
    

   fileprivate var isReversing: Bool {
        get {
            
            if(objc_getAssociatedObject(self, &IS_REVERSING) == nil)
            {
                return false
            }
            return (objc_getAssociatedObject(self, &IS_REVERSING) as! Bool)
        }
        set {
            objc_setAssociatedObject(self, &IS_REVERSING, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    private var animationIds: Dictionary<String,UnsafeRawPointer> {
        get {
            
            if(objc_getAssociatedObject(self, &ANI_IDS) == nil)
            {
                let animationIds = Dictionary<String,UnsafeRawPointer>()
                
                objc_setAssociatedObject(self,  &ANI_IDS, animationIds, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                
                return animationIds
            }
            return (objc_getAssociatedObject(self, &ANI_IDS) as! Dictionary<String,UnsafeRawPointer>)
        }
        
        set{
            
                objc_setAssociatedObject(self,  &ANI_IDS, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            
        }
    
    }
    
    internal var noTransition: Bool {
        get {
            
            if(objc_getAssociatedObject(self, &NO_TRANSITION) == nil)
            {
                return false
            }
            
            return (objc_getAssociatedObject(self, &NO_TRANSITION) as! Bool)
        }
        set {
            objc_setAssociatedObject(self, &NO_TRANSITION, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    internal var syncFrame: Bool {
        get {
            
            if(objc_getAssociatedObject(self, &SYNC_FRAME) == nil)
            {
                return true
            }
            
            return (objc_getAssociatedObject(self, &SYNC_FRAME) as! Bool)
        }
        set {
            objc_setAssociatedObject(self, &SYNC_FRAME, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
        private  var EASPoint: CGPoint? {
            get {
                return (objc_getAssociatedObject(self, &EAS_POINT) as? [CGPoint])?.last
            }
            set  {
    
                var container = [CGPoint]()
                
                if(newValue == nil)
                {
                    return
                }
    
                container.append(newValue!)
    
                objc_setAssociatedObject(self, &EAS_POINT, container, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                
            }
        }
    
    
    private  var EASScaleY: Double {
        get {
            
            if(objc_getAssociatedObject(self, &EAS_SCALE_Y) == nil)
            {
                return 1.0
            }
            return (objc_getAssociatedObject(self, &EAS_SCALE_Y) as? [Double])!.last!
        }
        set  {
            
            var container = [Double]()
            
            container.append(newValue)
            
            objc_setAssociatedObject(self, &EAS_SCALE_Y, container, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            
        }
    }
    
    
    private  var EASScaleX: Double {
        get {
            
            if(objc_getAssociatedObject(self, &EAS_SCALE_X) == nil)
            {
                return 1.0
            }
            return (objc_getAssociatedObject(self, &EAS_SCALE_X) as? [Double])!.last!
        }
        set  {
            
            var container = [Double]()
            
            container.append(newValue)
            
            objc_setAssociatedObject(self, &EAS_SCALE_X, container, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            
        }
    }
    
    
    private  var EASRotation: Double {
        get {
            
            if(objc_getAssociatedObject(self, &EAS_ROTATION) == nil)
            {
                return 0.0
            }
            return (objc_getAssociatedObject(self, &EAS_ROTATION) as? [Double])!.last!
        }
        set  {
            
            var container = [Double]()
            
            container.append(newValue)
            
            objc_setAssociatedObject(self, &EAS_ROTATION, container, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            
        }
    }
    


    internal func reverse(key:String,totalDuration:Double = 0) {
        
        self.isReversing = true
        
        if( objc_getAssociatedObject(self, self.animationIds[key]) == nil)
        {
            return
        }
        
        let aniparams = objc_getAssociatedObject(self, self.animationIds[key]) as! registed
        
        let animation = aniparams.reversion.copy() as! CAAnimation
        
     
        objc_setAssociatedObject(self, &EAS_BLOCK, aniparams.reversed, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        animation.beginTime = 0
        
        if(totalDuration > 0)
        {
            let coff = (animation.autoreverses) ? 2.0: 1.0
            
            let til:Double = (aniparams.reversion.relativeBeginTime) + animation.duration.multiplied(by: Double(animation.repeatCount + 1).multiplied(by:coff))
            
            animation.beginTime = totalDuration - til + CACurrentMediaTime()

            
        }
        
       
        if(self.noTransition)
        {
            if(animation.isKind(of: CAAnimationGroup.classForCoder()))
            {
                let animation = animation as! CAAnimationGroup
                
                
                for ani:CAKeyframeAnimation in animation.animations! as! [CAKeyframeAnimation]
                {
                    
                    noAnimationPreProcess(animation:ani)
                }
                
                animation.duration = 0
                animation.repeatCount = 0
                animation.autoreverses = false
            }
            else
            {
                noAnimationPreProcess(animation: animation as! CAKeyframeAnimation)
            }
        }
        
        if(animation.isKind(of: CAAnimationGroup.classForCoder()))
        {
            
            
            let animation = animation as! CAAnimationGroup
            self.storeFinalFrame(animations:animation.animations as! [CAKeyframeAnimation] )
            
        }
        else
        {
            
        
            self.storeFinalFrame(animations: [animation as! CAKeyframeAnimation])
        }
        
   
        self.layer.add(animation, forKey: key)
    }
    
    
    func reversedAnimation(forKey:String) -> CAAnimation
    {
        let aniparams = objc_getAssociatedObject(self, self.animationIds[forKey]) as! registed
        
        
        objc_setAssociatedObject(self,&EAS_BLOCK,aniparams.animated,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        
        return aniparams.reversion
        
    }
    
    
    
    internal func register(animation: CAKeyframeAnimation,forKey:String,relativeBeginTime:Double = 0.0, animated: @escaping () -> () = {}, reversed: @escaping () -> () = {})
    {

        let animation = animation.copy() as! CAKeyframeAnimation
        
        animation.relativeBeginTime = relativeBeginTime

        animation.delegate = self
        
        let animationr = self.reverse(animation: animation)
        
        animationr.delegate = self
        
        animationr.relativeBeginTime = relativeBeginTime
        
  
        var container = [()->()]()
        
        container.append(animated)
        
   
        var containerr = [()->()]()
        
        containerr.append(reversed)

        
        self.animationIds[forKey] = UnsafeRawPointer(UnsafeMutablePointer<Int>.allocate(capacity: 1))
        
        objc_setAssociatedObject(self, self.animationIds[forKey], registed(animation,animationr,container,containerr), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    internal func register(animation:[CAKeyframeAnimation],forKey:String,relativeBeginTime:Double = 0.0,reverse:Bool = false,repeatCount:Float = 0,animated:@escaping ()->() = {}, reversed: @escaping () -> () = {})
    {
   
   
        let groupani = self.compose(animations: animation)
   
        groupani.relativeBeginTime = relativeBeginTime
   
        groupani.delegate = self
        

        let groupanir = self.reverse(animation: groupani)
        
        groupanir.delegate = self
        
        groupanir.relativeBeginTime = relativeBeginTime
    
        var container = [()->()]()
        
        container.append(animated)
        
   
        var containerr = [()->()]()
        
        containerr.append(reversed)
        
        self.animationIds[forKey] = UnsafeRawPointer(UnsafeMutablePointer<Int>.allocate(capacity: 1))
        
        objc_setAssociatedObject(self, self.animationIds[forKey], registed(groupani,groupanir,container,containerr), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    internal func animate(key:String)
    {
        

        if( objc_getAssociatedObject(self, self.animationIds[key]) == nil)
        {
            return
        }
        
        let aniparams = objc_getAssociatedObject(self, self.animationIds[key]) as! registed
        
        
        objc_setAssociatedObject(self,&EAS_BLOCK,aniparams.animated,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)

        
        let animation = aniparams.animation.copy() as! CAAnimation
        
      
        
        animation.beginTime = (aniparams.animation.relativeBeginTime) + CACurrentMediaTime()
        
      
        
        if(self.noTransition)
        {
            if(animation.isKind(of: CAAnimationGroup.classForCoder()))
            {
                let animation = animation as! CAAnimationGroup
       
  
                for ani:CAKeyframeAnimation in animation.animations! as! [CAKeyframeAnimation]
                {
                    
                    noAnimationPreProcess(animation:ani)
                }
                

                animation.duration = 0
                animation.repeatCount = 0
                animation.autoreverses = false
            }
            else
            {
                noAnimationPreProcess(animation: animation as! CAKeyframeAnimation)
            }
        }
        
        if(animation.isKind(of: CAAnimationGroup.classForCoder()))
        {
            let animation = animation as! CAAnimationGroup
            self.storeFinalFrame(animations:animation.animations as! [CAKeyframeAnimation] )
        }
        else
        {
            self.storeFinalFrame(animations: [animation as! CAKeyframeAnimation])
        }
        
        self.isReversing = false
        

        self.layer.add(animation, forKey: key)
        
    }
    
        private func noAnimationPreProcess(animation:CAKeyframeAnimation)
        {
            animation.values = [animation.values?.last! as Any]
            animation.keyTimes = [0]
            animation.duration = 0
            animation.repeatCount = 0
            animation.beginTime = 0
            
        }
    
    
    private func storeFinalFrame(animations:[CAKeyframeAnimation])
    {
       if(!self.syncFrame)
       {
        return
       }
        
        var pointpair:(til:Double,point:CGPoint) = (-1,self.center)
         var scalepairX:(til:Double,scale:Double) = (-1,1.0)
        var scalepairY:(til:Double,scale:Double) = (-1,1.0)
         var rotationpair:(til:Double,radius:Double) = (-1,0)
        
        for i in 0 ..< animations.count
        {
            let ani = animations[i]
            
            if(ani.autoreverses)
            {
                continue
            }
            
            let coff = ani.autoreverses ? 2.0: 1.0
            
            let til:Double = ani.beginTime + ani.duration.multiplied(by: Double(ani.repeatCount + 1).multiplied(by:coff))
            
            
            switch ani.keyPath! {
            case "position":
                
                if(til > pointpair.til)
                {
                    pointpair = (til,ani.values?.last as! CGPoint)
                }
                
            case "transform.scale":
                if(til > scalepairX.til)
                {
                    scalepairX = (til,ani.values?.last as! Double)
                }
                
                if(til > scalepairY.til)
                {
                    scalepairY = (til,ani.values?.last as! Double)
                }
            case "backgroundColor":
                continue
                
            case "transform.rotation":
                if(til > rotationpair.til)
                {
                    rotationpair = (til,ani.values?.last as! Double)
                }
                
            default:
                continue
            }
            
            self.EASPoint = pointpair.point
            
            if(self.isReversing)
            {
                continue
            }
            self.EASScaleX = scalepairX.scale
            self.EASScaleY = scalepairY.scale
            self.EASRotation = rotationpair.radius
            
        }
        
    }
    
    
    private func compose(animations:[CAKeyframeAnimation]) -> CAAnimationGroup
    {
        let groupani = CAAnimationGroup()
        
        var duration:Double = 0
        
        
        
                for i in 0 ..< animations.count
                {
                    let ani = animations[i]
                    
                    let coff = ani.autoreverses ? 2.0: 1.0
                    
                    let _duration:Double = ani.beginTime + ani.duration.multiplied(by: Double(ani.repeatCount + 1).multiplied(by:coff))
                    
                   
                    
                    if( duration < _duration )
                    {
                        duration = _duration
                    }
                }
        
                var animationsCopy = [CAKeyframeAnimation]()
        
                for i in 0 ..< animations.count
                {
                    animationsCopy.append(animations[i].copy() as! CAKeyframeAnimation)
                }
        
                groupani.animations = animationsCopy
        
                groupani.duration = CFTimeInterval(duration)
        
        
                groupani.fillMode = kCAFillModeForwards
                groupani.delegate = self
                groupani.isRemovedOnCompletion = false
        
                if(self.noTransition)
                {
                    groupani.beginTime = 0
                    groupani.repeatCount = 0
                    groupani.duration = CFTimeInterval(0)
                    groupani.autoreverses = false
                
                }
        
        
        

            return groupani
    }
    
    private func reversTimeline(keyTimes:[TimeInterval]) -> [TimeInterval]
    {
         var timeunits = [Double]()
         var reversedKeyTimes = [Double]()
        //时序转换为工序耗时
       
        
        
        
        for i in 1 ..< keyTimes.count
        {
            timeunits.append(keyTimes[i] - keyTimes[i-1])
        }
        
        //反转工序耗时
        timeunits = timeunits.reversed()
        
        
        
        //工序耗时转为时序
        reversedKeyTimes.append(0)
        
       
        
        for i in 0 ..< timeunits.count
        {
            reversedKeyTimes.append(timeunits[i] + reversedKeyTimes[i])
        }
    
        return reversedKeyTimes
    }
    
    
    private func reverse(animation:CAKeyframeAnimation) -> CAKeyframeAnimation
    {
        let reversed:CAKeyframeAnimation = animation.copy() as! CAKeyframeAnimation
        
        
        if(animation.autoreverses)
        {
            return animation
        }
        
        reversed.values = reversed.values?.reversed()
        
        reversed.keyTimes = self.reversTimeline(keyTimes: reversed.keyTimes! as [TimeInterval]) as [NSNumber]?
        
        reversed.timingFunctions = reversed.timingFunctions?.reversed()
        

        return reversed
        
       
    }
    
    private func reverse(animation:CAAnimationGroup) -> CAAnimationGroup
    {
        let reversed:CAAnimationGroup = animation.copy() as! CAAnimationGroup
        
        
        reversed.animations = reversed.animations!.reversed().map{
            return  $0.copy()
            } as! [CAKeyframeAnimation]
        
        
        
        for i in 0 ..< reversed.animations!.count{
            
            
            let animationu = reversed.animations![i] as! CAKeyframeAnimation
            
            reversed.animations![i] = self.reverse(animation:animationu)
            
            let ani = reversed.animations![i]
            
            let coff = ani.autoreverses ? 2.0: 1.0
            
            let _duration:Double = ani.beginTime + ani.duration.multiplied(by: Double(ani.repeatCount + 1).multiplied(by:coff))
            
            reversed.animations![i].beginTime = reversed.duration - _duration
        }
        
      
        
        return reversed
        
      
    }
    

    
    
    public func removeAnimation(forKey:String)
    {
        self.layer.removeAnimation(forKey: forKey)
    }
    
    public func removeAllAnimations()
    {
        self.layer.removeAllAnimations()
    }
    

    
    
    //动画代理
        public func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
        {
          
            var container = (objc_getAssociatedObject(self, &EAS_BLOCK) as? [()->()])
            
            
            let block = container?[0]
            
            if(!self.syncFrame || !flag)
            {
                return
            }
            
            
            if(self.EASPoint != nil)
            {
                
                weak var weakSelf = self
                
                if(weakSelf == nil)
                {
                    return
                }
                
                DispatchQueue.main.async {
                weakSelf!.center = (weakSelf!.EASPoint!)
                   
                    var scaleX = weakSelf!.EASScaleX
                    var scaleY = weakSelf!.EASScaleY
                    var rotation = weakSelf!.EASRotation
                    

                    if(weakSelf?.isReversing)!
                    {
                        scaleX = 1.0/scaleX
                        scaleY = 1.0/scaleY
                        rotation = -rotation
                    }
                    
                    weakSelf?.transform = (weakSelf?.transform.scaledBy(x: CGFloat(scaleX), y: CGFloat(scaleY)).rotated(by: CGFloat(rotation)))!

                    DispatchQueue.global().async {
                        block!()
                    }
                
                }
            }
            else
            {
                DispatchQueue.global().async {
                block!()
                    }
            }

        }
    
}
