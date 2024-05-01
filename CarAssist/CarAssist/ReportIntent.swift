//
//  ReportIntent.swift
//  CarAssist
//
//  Created by Khang Nguyen on 4/11/24.
//

import Foundation
import AppIntents
import SwiftData
import FirebaseFirestore
import Combine

struct ReportIntent: AppIntent {
    static var title: LocalizedStringResource = "Report a problem"
    
    @Parameter(title: "License",
               description: "License plate of the vehicle",
               inputOptions: String.IntentInputOptions(autocorrect: false),
               requestValueDialog: IntentDialog("What is the license plate of the vehicle?"))
    var license: String
    
    
    @Parameter(title: "Report", description: "Type of report", requestValueDialog: IntentDialog("What problem are you reporting?"))
    var report: String
    
    func perform() async throws -> some IntentResult {
//        let container = try ModelContainer(for: Report.self)
//        let context = await container.mainContext
//        context.insert(Report(reportType: report, licensePlate: license))
        let report = Report(reportType: report, licensePlate: license, time: Date.now)
        let manager = await NotificationsManager()
        let store = Firestore.firestore()
        await manager.sendPushNotification(payloadDict: report.createPayLoad())
        _ =  try store.collection("reports_\(license)").addDocument(from: report)
        
        return .result()
    }
}
