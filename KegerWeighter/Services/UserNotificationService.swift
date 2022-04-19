//
//  UserNotificationService.swift
//  KegerWeighter
//
//  Created by Joe Toeniskoetter on 1/2/22.
//

import Foundation
import UserNotifications

class UserNotificationService{
    private let notificationsCenter = UNUserNotificationCenter.current()
    
    func notificationEnabled() -> Bool{
        var result:Bool = false
        notificationsCenter.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                result = true;
            } else if settings.authorizationStatus == .denied {
                result = false
            } else if settings.authorizationStatus == .authorized {
                result = true;
            }
        })
        return result
    }
}
