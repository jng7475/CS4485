//
//  CarInfo.swift
//  CarAssist
//
//  Created by Khang Nguyen on 2/21/24.
//

import Foundation

class CarInfo: ObservableObject {
    static var shared = CarInfo(license: "JHN4687", carName: "Toyota Camry 2012")
//    static var shared = CarInfo(license: "KGK1423", carName: "Toyota Corolla 2014")
    
    init(license: String, carName: String) {
        self.license = license
        self.carName = carName
    }
    
    @Published var license: String
    @Published var carName: String
    
    
    func switchToKhang() {
        license = "JHN4687"
        carName = "Toyota Camry 2012"
    }
    
    func switchToHuy() {
        license = "KGK1423"
        carName = "Toyota Corolla 2014"
    }
    
    var pathToData: String {
        if self.isKhang() {
            return "reports_JHN4687"
        } else if self.isHuy() {
            return "reports_KGK1423"
        }
        return "reports_\(license)"
    }
    
    func isKhang() -> Bool {
        return license == "JHN4687"
    }
    
    func isHuy() -> Bool {
        return license == "KGK1423"
    }
    
    var imageName: String {
        if self.isHuy() {
            return "corolla_front"
        } else {
            return "camry_front"
        }
    }
}
