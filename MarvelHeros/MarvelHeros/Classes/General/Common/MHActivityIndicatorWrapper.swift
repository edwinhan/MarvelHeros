//
//  MHActivityIndicatorWrapper.swift
//  MarvelHeros
//
//  Created by edwin on 2018/2/14.
//  Copyright © 2018年 Edwin. All rights reserved.
//

import UIKit

class MHActivityIndicatorWrapper: NSObject {
    var activityIndicator:UIActivityIndicatorView?
    var activityContainerView:UIView?
    var activityBGView:UIView?
    class var sharedInstance:MHActivityIndicatorWrapper {
        
        struct Singleton {
            static let instance = MHActivityIndicatorWrapper()
            
        }
        return Singleton.instance
    }
    
    func startActivityIndicator(vc:UIViewController)
    {
        //init activity view
        if (self.activityBGView == nil) {
            self.activityBGView = UIView(frame: vc.view.bounds)
            
            self.activityBGView?.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
            
            self.activityContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            self.activityContainerView!.center = CGPoint(x: self.activityBGView!.center.x, y: self.activityBGView!.center.y - 40)
            
            self.activityBGView!.addSubview(self.activityContainerView!)
            self.activityContainerView!.layer.cornerRadius = 12;
            self.activityContainerView!.backgroundColor = UIColor.darkGray
            
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            
            self.activityContainerView!.addSubview( self.activityIndicator!)
            self.activityIndicator!.center = CGPoint(x: self.activityContainerView!.frame.size.width/2, y: self.activityContainerView!.frame.size.height/2)
        }
        
       vc.view.addSubview(self.activityBGView!)
        self.activityIndicator!.startAnimating()
        
        
        
    }
    
    func stopActivityIndicator(vc:UIViewController)-> Void
    {
        if (self.activityBGView != nil) {
            
            
            if self.activityBGView!.superview != nil {
                self.activityBGView!.removeFromSuperview()
            }
        }
    }
}
