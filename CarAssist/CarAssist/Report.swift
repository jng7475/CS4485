//
//  Report.swift
//  CarAssist
//
//  Created by Khang Nguyen on 4/11/24.
//

import Foundation
import SwiftData

//@Model
final class Report: Codable, Identifiable {
    var id: UUID
    var reportType: String
    var licensePlate: String
    var time: Date
    
    init(reportType: String, licensePlate: String, time: Date) {
        self.id = UUID()
        self.reportType = reportType
        self.licensePlate = licensePlate.uppercased().replacingOccurrences(of: " ", with: "")
        self.time = time
    }
    
    func createPayLoad() -> [String: Any] {
        var key: String = ""
        if licensePlate == "JHN4687" {
            key = "cYhuWr-Dw03ilb8IE2voSn:APA91bG9xPp8MTv3DqwnDC2eYuVsxUH4xyC_NmpgUw20qa66CmfC1LeUu7UukV9ZnwExlEA6j9hZJtnELdwO8VxZbjthSmd9o6HcCBH5kon_xzWL0OGEahHa9nzUYhh8sgn6Y-a9rI6Y"
        } else if licensePlate == "KGK1423" {
            key = ""
        }
//        print("DEBUGG: GOT KEY: \(key)")
        let notifPayload: [String: Any] = [
            "to": key,
            "notification": [
                "title": "Problem Reported About Your Car",
                "body": "A driver reported your car with: \(reportType)",
                "badge": 1,
                "sound": "default"]]
        return notifPayload
    }
}
