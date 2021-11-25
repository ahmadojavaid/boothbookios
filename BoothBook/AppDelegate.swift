//
//  AppDelegate.swift
//  BoothBook
//
//  Created by abbas on 22/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let locationManager = CLLocationManager()
    let notificationCenter = UNUserNotificationCenter.current()

    static var shared:AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupUX()
        
        getLocation()
        //let deadLine = DispatchTime.now() + 60 * 11
        //DispatchQueue.global(qos: .background).asyncAfter(deadline: deadLine) {
        //}
        //DispatchQueue.main.asyncAfter(deadline: deadLine) { }
        
        application.setMinimumBackgroundFetchInterval(10)
//        self.simpleAddNotification(hour: 15, minute: 46, identifier: "Hello", title: "1", body: "This is body")
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        notificationCenter.getNotificationSettings { (settings) in
          if settings.authorizationStatus != .authorized {
            // Notifications not allowed
          }
        }
        
        //let date = Date(timeIntervalSinceNow: 3600)
        //let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        return true
    }
    
   func scheduleNotification(notificationType: String) {
       
       let content = UNMutableNotificationContent() // Содержимое уведомления
       
       content.title = notificationType
       content.body = "This is example how to create " + "\(notificationType) Notifications"
       content.sound = UNNotificationSound.default
       content.badge = 1
   }
    public func simpleAddNotification(hour: Int, minute: Int, identifier: String, title: String, body: String) {
        // Initialize User Notification Center Object
        let center = UNUserNotificationCenter.current()

        // The content of the Notification
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        // The selected time to notify the user
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = hour
        dateComponents.minute = minute

        // The time/repeat trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // Initializing the Notification Request object to add to the Notification Center
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Adding the notification to the center
        center.add(request) { (error) in
            if (error) != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    /* Back Ground Fetch Method
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //DispatchQueue.global(qos: .background).async {
        //self.locationManage
        //}
        //updateLocation(completion: { (status) in
        //    if status {
        //        completionHandler(.newData)
        //    } else {
        //        completionHandler(.failed)
        //    }
        //    print("Fecth Completed \(Date().toString("hh:mm:ss"))")
        //})
        
    }
    */
    func setupUX() {
        //UIApplication.shared.isStatusBarHidden = false
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        var rootController:UIViewController!
        
        //if UserDefaults.standard.bool(forKey: "isLogedin") {
            rootController = TabBarViewController()
        //} else {
        //    rootController = LogInViewController(nibName: "LogInViewController", bundle: .main)
        //}
        
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
        IQKeyboardManager.sharedManager().enable = true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }
    
    var backgroundTaskID:UIBackgroundTaskIdentifier!
    func sendDataToServer( data : NSData ) {
        //backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "MyTask") {
        //    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        //print("BackGround Processing in side Queue")
        //self.textBackGroundProcessing()
        //UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
        //self.backgroundTaskID = UIBackgroundTaskInvalid
        //    }
        //}
        
        // Perform the task on a background queue.
        DispatchQueue.global().async {
            // Request the task assertion and save the ID.
            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask (withName: "Finish Network Tasks") {
                // End the task if time expires.
                print("BackgroundTaskID Going to be ended")
                //self.locationManager.startUpdatingLocation()
                self.getLocation()
                UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
            self.textBackGroundProcessing()
            // Send the data synchronously.
            //self.sendAppDataToServer( data: data)
            
            // End the task assertion.
            //UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
            //self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        /*
        //sendDataToServer(data: NSData())
        if application.backgroundRefreshStatus == .available {
            print("backgroundRefreshStatus is available")
        } else {
            print("backgroundRefreshStatus is not available")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            self.locationManager.stopUpdatingLocation()
        }
        */
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "BoothBook")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
// supporting methods
extension AppDelegate {
    func moveToLoginController() {
        //let rootController = SBWalkthroughController(nibName: "SBWalkthroughController", bundle: nil)
        //let loginController = SBLoginController(nibName: "SBLoginController", bundle: nil)
        //let navigationController = Utilities.shared.navigationController(withRootController: rootController)
        //navigationController.viewControllers = [rootController, loginController]
        //window?.setRootViewController(navigationController, animationType: .fadeIn)
        //window?.makeKeyAndVisible()
    }
}


extension AppDelegate:CLLocationManagerDelegate {
    func getLocation(){
        let authStatus = CLLocationManager.authorizationStatus()
        switch authStatus {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        case .denied:
            if let url = URL(string: "App-prefs:root=LOCATION_SERVICES") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            /* if let bundleId = Bundle.main.bundleIdentifier,
             let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
             } */
        case .notDetermined:
            break
        case .restricted:
            if let bundleId = Bundle.main.bundleIdentifier,
                let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        @unknown default:
            print("Unknown Status")
        }
        
        locationManager.requestAlwaysAuthorization()
        //locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            //locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            //locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            //locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //let dist = LocationMath.distance(lat1: currentLocation.latitude, lon1: currentLocation.longitude, lat2: locNew.latitude, lon2: locNew.longitude) * 1000
        Location.current.update(lat: locValue.latitude, long: locValue.longitude)
        Location.current.debugDescription()
        
        // Update Location Info on Server
        self.updateLocation { (isSuccess) in
            print("\(isSuccess ? "Success":"Failed") Server Location Update")
        }
    }
    func textBackGroundProcessing(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            print("\(UIApplication.shared.backgroundTimeRemaining):: ")
            self?.textBackGroundProcessing()
        }
    }
    
    func updateLocation(completion: ((Bool)->Void)? = nil) {
        guard let user = User.current else {
            completion?(false)
            return
        }
        let manager = BaseManager()
        let key = user.client_key ?? ""
        let secret = user.client_secret ?? ""
        let uid = user.uid ?? ""
        let endPoint = "api/v1/create/location?key=\(key)&secret=\(secret)&latitude=\(Location.current.latitude)&longitude=\(Location.current.longitude)&created=\(Int(Date().timeIntervalSince1970))&uid=\(uid)"
        manager.getRequest(endPoint, parms: nil, header: nil) { (status, data) in
            print(String(data: data ?? Data(), encoding: .utf8) ?? "")
            completion?(status.isSuccess)
        }
    
    }
    
}
