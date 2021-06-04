//
//  CompanyModel.swift
//  RJGoSwiftDemo
//
//  Created by claptrap on 6/3/21.
//

import Foundation


struct CompanyModel: Decodable, Encodable {
    
    var companyName = "", qrLink = "", companyLogo = "", companyLogoFileName = "", companyMapFileName = "", companyMap = "", companyPhoneNumber = "", companyStreetAddress = ""
    var companyLogoUrl = URL(string: ""), companyMapUrl = URL(string: "")
    let petTips = ["Adopting a pet is like having a 24/7 personal nurse.",
                   "Adopting a pet helps you to become friendlier and more approachable. A common interest brings people together.",
                   "Adopting a pet can help kids learn responsibility by teaching them to care for their pet.",
                   "Adopting a pet can bring so much love and joy into your home.",
                   "Adopting a pet can help with depression by getting your mind off your own issues."
    ]
    
    
    init(companyName: String, companyStreetAddress: String, companyPhoneNumber: String,
         qrLink: String, companyLogo: String, companyLogoFileName: String,
         companyMapFileName: String, companyMap: String, companyLogoUrl: URL, companyMapUrl: URL) {
        self.companyName = companyName
        self.qrLink = qrLink
        self.companyLogo = companyLogo
        self.companyLogoFileName = companyLogoFileName
        self.companyMapFileName = companyMapFileName
        self.companyMap = companyMap
        self.companyPhoneNumber = companyPhoneNumber
        self.companyStreetAddress = companyStreetAddress
        self.companyLogoUrl = companyLogoUrl
        self.companyMapUrl = companyMapUrl
    }
    
    init() {
        
    }
    
    
    
}
