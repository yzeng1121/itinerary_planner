//
//  TripManager.swift
//  itinerary_app
//
//  Created by yuxin on 8/7/25.
//
import Foundation
import UIKit

class TripManager: ObservableObject {
    static let shared = TripManager()
    
    private init() {
        loadTrips()
    }
    
    private(set) var trips: [Trip] = [] {
        didSet {
            saveTrips()
        }
    }
    
    // MARK: - Trip Management
    func addTrip(_ trip: Trip) {
        trips.append(trip)
    }
    
    func deleteTrip(at index: Int) {
        guard index < trips.count else { return }
        trips.remove(at: index)
    }
    
    func updateTrip(at index: Int, with trip: Trip) {
        guard index < trips.count else { return }
        trips[index] = trip
    }
    
    func getTrip(by id: UUID) -> Trip? {
        return trips.first { $0.id == id }
    }
    
    func getTripIndex(by id: UUID) -> Int? {
        return trips.firstIndex { $0.id == id }
    }
    
    // MARK: - Activity Management
    func addActivity(to tripId: UUID, activity: Activity) {
        guard let index = getTripIndex(by: tripId) else { return }
        trips[index].addActivity(activity)
    }
    
    func deleteActivity(from tripId: UUID, at activityIndex: Int) {
        guard let index = getTripIndex(by: tripId) else { return }
        trips[index].removeActivity(at: activityIndex)
    }
    
    func updateActivity(in tripId: UUID, at activityIndex: Int, with activity: Activity) {
        guard let index = getTripIndex(by: tripId) else { return }
        trips[index].updateActivity(at: activityIndex, with: activity)
    }
    
    // MARK: - Persistence
    private func saveTrips() {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: "SavedTrips")
        }
    }
    
    private func loadTrips() {
        if let data = UserDefaults.standard.data(forKey: "SavedTrips"),
           let decoded = try? JSONDecoder().decode([Trip].self, from: data) {
            trips = decoded
        }
    }
}
