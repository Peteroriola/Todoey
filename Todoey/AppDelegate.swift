//
//  AppDelegate.swift
//  Todoey
//
//  Created by Peter Oriola on 06/12/2018.
//  Copyright © 2018 Peter Oriola. All rights reserved.
//

import UIKit

import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        
        
        do {
            _ = try Realm()
           
            }
        catch {
            print("Error initialising new realm \(error)")
        }
        
        
        return true
    }


    
  
   


}

