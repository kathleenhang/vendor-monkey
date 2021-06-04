//
//  CustomCVCell.swift
//  RJGoSwiftDemo
//
//  Created by claptrap on 6/3/21.
//

import UIKit

class CustomCVCell: UICollectionViewCell {
    
    
    @IBOutlet weak var logoLbl: UILabel!
    @IBOutlet weak var mapLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var qrLinkLbl: UILabel!
    
    
    
    
    
    func configure(logoFileName companyLogoFileName: String,
                   mapFileName companyMapFileName: String,
                   name companyName: String,
                   address companyAddress: String,
                   phoneNumber companyPhoneNumber: String,
                   qrLink companyQrLink: String) {
        
        logoLbl.text = companyLogoFileName
        mapLbl.text = companyMapFileName
        nameLbl.text = companyName
        addressLbl.text = companyAddress
        phoneNumberLbl.text = companyPhoneNumber
        qrLinkLbl.text = companyQrLink
        self.backgroundColor = .red
        self.layer.cornerRadius = 7
        
        logoLbl.textColor = .white
        mapLbl.textColor = .white
        nameLbl.textColor = .white
        addressLbl.textColor = .white
        phoneNumberLbl.textColor = .white
        qrLinkLbl.textColor = .white
        
        
        nameLbl.font = .boldSystemFont(ofSize: 25)
        
    }
    
    
}
