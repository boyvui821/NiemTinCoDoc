//
//  AppDelegate.swift
//  NiemTinCoDoc
//
//  Created by Nguyen Hieu Trung on 4/9/18.
//  Copyright © 2018 NHTSOFT. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleMobileAds
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate   {

    var window: UIWindow?
    
    //Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound]);
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "testNotification"{
            print("Handle notification");
        }
        completionHandler();
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self;
        
        UNUserNotificationCenter.current().requestAuthorization(options: .alert) { (granted, error) in
            print("Granted: \(granted)");
            
        }
        //ID Test ADMOB
        //GADMobileAds.configure(withApplicationID: "ca-app-pub-3940256099942544/4411468910");
        
        //ID ADS ADMOB
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3167518105754283~8813093826");
        
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func ScheduleNotification(){
        print("--------------scheduleNotification-----------------")
        let notificationContent = UNMutableNotificationContent();
        notificationContent.title = "Hãy cảm tạ Chúa vì một buổi sớm mai";
        notificationContent.body = "Và bắt đầu một ngày mới với một đức tin thật vững vàng";
        notificationContent.sound = UNNotificationSound.default();
        
        var component = DateComponents();
        component.hour = 6;
        component.minute = 30;
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true);
        
        let request = UNNotificationRequest(identifier: "testNotification", content: notificationContent, trigger: trigger);
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil);
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp();
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

