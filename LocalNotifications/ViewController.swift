//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Rohith Reddy Gurram on 6/22/23.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNotifications()
    }
    
    func configureNotifications() {
//        Step 1: Request for authorization
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchNotification()
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { authorized, error in
                    if authorized {
                        self.dispatchNotification()
                    }
                }
            default:
                return
            }
        }
    }

    func dispatchNotification() {
//        Step 2: Create UNMutableNotificationContent instance and give the title and body values
        let content  = UNMutableNotificationContent()
        content.title = "Yo, wassup!"
        content.body = "How's it going?"
        content.subtitle = "How you been man!!"
        content.sound = .defaultCritical
        
//        var dateComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current)
//        dateComponents.hour = 16
//        dateComponents.minute = 46
        let date = Date().addingTimeInterval(5)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let repeatsDaily = true
        let identifier = "my-local-notification"
        
//        Step 3: Create UNCalendarNotificationTrigger instance with dateComponents
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeatsDaily)
        
//        Step 4: Create UNNotificationRequest with an identifier, content and trigger
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
//        Step 5: Register the request through notificationCenter.add(request)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
}

