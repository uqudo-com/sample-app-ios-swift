//
//  AppDelegate.swift
//  Sample-Swift
//
//  Created by NooN on 19/9/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var accessToken: String?
    private var myAccessToken = MyAccessToken()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.initUqudoBuilder()
        self.requestAccesToken()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func requestAccesToken() {
        self.myAccessToken.requestAccessToken { (accessToken: String? , error: Error?) in
            self.accessToken = accessToken;
        }
    }

    func initUqudoBuilder() {
        print("SDK version :\(UQBuilderController.getSDKVersion())")
        let tracer = MyTracer()
        _ = UQBuilderController.init(tracer: tracer)
    }

}

