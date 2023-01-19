//
//  AppDelegate.swift
//  YouMethod
//
//  Created by Dillon Kermani on 1/19/23.
//
import UIKit
import UserNotifications

class AppDelegate: NSObject, ObservableObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Action id: \(response.actionIdentifier)")
        NotificationCenter.default.post(name: NSNotification.Name("Detail"), object: nil)
    }
    
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("opened notification from closed app")
        NotificationCenter.default.post(name: NSNotification.Name("Detail"), object: nil)

    }


}







