//
//  ViewController.swift
//  MegaBoxDemo
//
//  Created by royliu1990 on 2016/12/19.
//  Copyright © 2016年 royliu1990. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import AudioToolbox

class  ViewController:UIViewController,CAAnimationDelegate {

    let control = UIButton()
    let panel = UIView()
    
    var xs = [UIButton]()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        
        control.frame = CGRect(origin:CGPoint(x:150,y:150),size:CGSize(width:100,height:30))
        
        view.addSubview(control)
     
        control.backgroundColor = .white
        
        control.setTitleColor(.gray, for: UIControlState.normal)
        
        control.setTitle("click me!", for: UIControlState.normal)

        panel.frame = CGRect(origin:CGPoint(x:0,y:200),size:CGSize(width:300,height:300))
        
        view.addSubview(panel)
 
      
        
        let animation = EASCKAFactor.keyFrameAnimation(type: "position", values: [CGPoint(x:150,y:350),CGPoint(x:200,y:500)])

        animation.duration = CFTimeInterval(20)
        
        
        let animation2 = EASCKAFactor.keyFrameAnimation(type: "transform.rotation", values: [0.0,7.0])
        
        animation2.duration = CFTimeInterval(10)
        
        animation2.autoreverses = true
        
        
        let animation3 = EASCKAFactor.keyFrameAnimation(type: "transform.scale", values: [1.0,2.0,1.0])
        
        animation3.duration = CFTimeInterval(10)
        
        animation3.autoreverses = true
        
        let animation4 = EASCKAFactor.keyFrameAnimation(type: "backgroundColor", values: [UIColor.clear.cgColor,UIColor.green.cgColor,UIColor.clear.cgColor,UIColor.red.cgColor,UIColor.clear.cgColor])
        
        animation4.duration = CFTimeInterval(10)
        
        animation4.autoreverses = true
        
        panel.layer.allowsEdgeAntialiasing = true
        

        panel.register(animation: [animation,animation2,animation3,animation4], forKey: "move")
        
        animation.duration = CFTimeInterval(0.5)
        
        let nuEASer = 100
        
        let values = EASKeyValues.fanShaped(center: CGPoint(x:panel.frame.size.width/2,y:panel.frame.size.height/2), startRadius: 20, endRadius: 100, startAngle: 0.5, endAngle: 40, density: nuEASer, fractalRates: [0,1.2,0.9,1.0])
        
        var begin = 0.0

        for i in 0 ..< nuEASer
        {
            
            let x = UIButton()
            
            x.backgroundColor = .clear
            
            xs.append(x)
            
            weak var weakX = x
            
            x.rx.tap.subscribe{
                
                _ in
                DispatchQueue.main.async {
                
                    weakX?.removeAnimation(forKey: "color")
                    weakX?.removeAnimation(forKey: "tcolor")
                    weakX?.layer.backgroundColor = UIColor.white.cgColor

                }
                
            }.addDisposableTo(disposeBag)
            
           
            
            x.frame = CGRect(origin: CGPoint(x:panel.frame.size.width/2,y:panel.frame.size.height/2), size: CGSize(width: 6, height: 6))
            
//            x.syncFrame = false
            
            x.layer.cornerRadius = 3
            
            
            
            x.clipsToBounds = true
            
            let tcolor = EASCKAFactor.keyFrameAnimation(type: "backgroundColor", values:[])
            if(i % 2 == 1)
            {
                
                x.register(animation: EASCKAFactor.keyFrameAnimation(type: "backgroundColor", values: [UIColor.red.cgColor,UIColor.green.cgColor]), forKey: "color")
                
                 tcolor.values =  [UIColor.clear.cgColor,UIColor.darkGray.cgColor,UIColor.red.cgColor]
                tcolor.duration = 0.5
                
                
                
            }
            else
            {
                
                
                x.register(animation: EASCKAFactor.keyFrameAnimation(type: "backgroundColor", values: [UIColor.green.cgColor,UIColor.red.cgColor]), forKey: "color")
                
                tcolor.values =  [UIColor.clear.cgColor,UIColor.darkGray.cgColor,UIColor.green.cgColor]
                               tcolor.duration = 0.5
                
            }
            
            panel.addSubview(x)
            
            let anima = animation.copy()
            
            (anima as! CAKeyframeAnimation).keyTimes = [0,0.8,0.9,1.0]
            
            (anima as! CAKeyframeAnimation).values = values[i]
            x.tag = i
            
            
            
            weak var weakSelf = self
            
            
            x.register(animation: tcolor, forKey: "tcolor", relativeBeginTime: 0.2.multiplied(by: Double(i)),animated:{
                DispatchQueue.main.async {
                    weakX?.animate(key: "color")
                }
            })
            
            x.register(animation: [(anima as! CAKeyframeAnimation)],forKey:"haha",relativeBeginTime:0.2.multiplied(by: Double(i))
                ,animated:{
                
                if(weakSelf == nil)
                {
                    return
                }
                
//                if(i == 99)
//                {
//                    for i in 0 ..< weakSelf!.xs.count
//                    {
//                   
//                       weak var vi = weakSelf!.xs[i]
//                        
//                        
//                        DispatchQueue.main.async {
//                            if(vi == nil)
//                            {
//                                return
//                            }
//                            vi!.reverse(key: "haha", totalDuration: 20.3)
//                        }
//
//                    }
//                }
                
            }
                ,reversed:{
                    
                    if(weakSelf == nil)
                    {
                        return
                    }
                    
                     DispatchQueue.main.async {
                    x.reverse(key: "color")
                    }
//                    if(i == 0)
//                    {
//                        for i in 0 ..< weakSelf!.xs.count
//                        {
//  
//                            weak var vi = weakSelf!.xs[i]
//                            
//                            
//                            DispatchQueue.main.async {
//                                if(vi == nil)
//                                {
//                                    return
//                                }
//                                vi!.animate(key: "haha")
//                            }
//
//                            
//                        }
//                    }
                    
            }
            )

            begin = begin.advanced(by: 0.2)

        }

        let totalDuration = begin.advanced(by:0.3)
        
        weak var weakSelf = self
        
        weak var WeakControl = control
        
        control.rx.tap.subscribe{
            _ in
            
            if(weakSelf == nil || WeakControl == nil)
            {
                return
            }
            
            
            
            
            WeakControl!.isSelected = !WeakControl!.isSelected
            
            
            
            weakSelf!.panel.animate(key: "move")
            
            
            if(WeakControl!.isSelected)
            {
                WeakControl!.setTitle("reverse", for: UIControlState.normal)
                
                for i in 0 ..< weakSelf!.xs.count
                {

                            weak var vi = weakSelf!.xs[i]
                            
                    
                            DispatchQueue.main.async {

                    
                                vi?.animate(key:"haha")
                                vi?.animate(key: "tcolor")
                            }

                }
            }
            else
            {
                
                WeakControl!.setTitle("animate", for: UIControlState.normal)
                
                self.panel.reverse(key: "move")
                
                for i in 0 ..< weakSelf!.xs.count
                {
                    

                    weak var vi = weakSelf!.xs[i]
                    
                    
                    DispatchQueue.main.async {
                    
                        vi?.reverse(key:"tcolor",totalDuration: totalDuration)
                        vi?.reverse(key:"haha",totalDuration: totalDuration)

                    }
                }
                
            }
            
            
        }.addDisposableTo(disposeBag)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        xs.forEach{
            $0.removeAllAnimations()
        }

        
    }
}
