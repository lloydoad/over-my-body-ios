//
//  DeadlineNotifications.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 11/30/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

public enum TimeToDeadline: Int {
    case five = 5
    case ten = 10
    case fifteen = 15
}

public struct DeadlineNotifications {
    
    public static func getComment(remainingTime: TimeToDeadline) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Over My Dead Body Reminder"
        content.body = "\(remainingTime.rawValue) minutes till check-in deadline"
        content.sound = UNNotificationSound.default
        return content
    }
    
    public static func getTrigger(timeToDeadline: TimeToDeadline, deadline: Date) -> UNCalendarNotificationTrigger {
        let secondsBefore = -1 * 60 * timeToDeadline.rawValue
        let date = Date(timeInterval: TimeInterval(secondsBefore), since: deadline)
        print(date)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        return UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
    }
    
    public static func scheduleNotification(timeToDeadline: TimeToDeadline, deadline: Date) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let identifier = "\(timeToDeadline)"
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: getComment(remainingTime: timeToDeadline),
            trigger: getTrigger(timeToDeadline: timeToDeadline, deadline: deadline)
        )
        
        appDelegate.notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            print("Set notification for \(timeToDeadline)")
        }
    }
    
    public static func scheduleNotificationsFor(_ deadline: Date) {
        scheduleNotification(timeToDeadline: .five, deadline: deadline)
        scheduleNotification(timeToDeadline: .ten, deadline: deadline)
        scheduleNotification(timeToDeadline: .fifteen, deadline: deadline)
    }
}
