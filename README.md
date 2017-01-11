# EasyAnimationSwift
Encapsulation of CAAnimation in swift, extending UIView to easily store CAAnimation and play later, or reverse separately.It can also synchronize the UIView's frame to the layer's frame when the animation did finished.

#### Installation

 CocoaPods supported  
* pod 'EasyAnimationSwift',    '~> 0.0.1'

#### Usage:

* register:  *someView.register(animation:CAKeyframeAnimation,forkey:String,...)  
someView.register(animation:[CAKeyframeAnimation],forkey:String,...)*

* play:  
*someView.animate(key:String)  
someView.reverse(key:String,totalDuration:Double = 0)* **notice: totalDuration is important to reverse multiple views' animation as a whole,plz read the demo for more details.**

* remove  
someView.remove(key:String)




##### Demo GIF

![image](https://github.com/royliu1990/EasyAnimationSwift/blob/master/GIF/EasyAnimationSwiftDemoGIF.gif)
