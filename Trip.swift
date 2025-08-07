//
//  Trip.swift
//  itinerary_app
//
//  Created by yuxin on 8/7/25.
//
import Foundation
import UIKit

struct Trip: Codable {
    let id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var activities: [Activity]
    
    init(title: String, startDate: Date, endDate: Date) {
        self.id = UUID()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.activities = []
    }
    
    mutating func addActivity(_ activity: Activity) {
        activities.append(activity)
        activities.sort { $0.time < $1.time }
    }
    
    mutating func removeActivity(at index: Int) {
        guard index < activities.count else { return }
        activities.remove(at: index)
    }
    
    mutating func updateActivity(at index: Int, with activity: Activity) {
        guard index < activities.count else { return }
        activities[index] = activity
        activities.sort { $0.time < $1.time }
    }
}

struct Activity: Codable {
    let id: UUID
    var time: Date
    var title: String
    var location: String
    var type: ActivityType
    var duration: String?
    
    init(time: Date, title: String, location: String, type: ActivityType, duration: String? = nil) {
        self.id = UUID()
        self.time = time
        self.title = title
        self.location = location
        self.type = type
        self.duration = duration
    }
}

enum ActivityType: String, CaseIterable, Codable {
    case transport = "transport"
    case accommodation = "accommodation"
    case activity = "activity"
    case food = "food"
    case other = "other"
    
    var icon: String {
        switch self {
        case .transport:
            return "airplane"
        case .accommodation:
            return "bed.double"
        case .activity:
            return "star"
        case .food:
            return "fork.knife"
        case .other:
            return "mappin.and.ellipse"
        }
    }
    
    var color: String {
        switch self {
        case .transport:
            return "orange"
        case .accommodation:
            return "blue"
        case .activity:
            return "green"
        case .food:
            return "red"
        case .other:
            return "gray"
        }
    }
}
