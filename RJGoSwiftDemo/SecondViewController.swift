//
//  SecondViewController.swift
//  RJGoSwiftDemo
//
//  Created by claptrap on 6/3/21.
//

import UIKit

class SecondViewController: UIViewController,
                            UICollectionViewDataSource,
                            UICollectionViewDelegate,
                            UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userDefaults = UserDefaults.standard
    var companyManager = CompanyManager()
    
    let reuseIdentifier = "Cell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        companyManager.companyModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if let dataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CustomCVCell {
            dataCell.configure(logoFileName: companyManager.companyModels[indexPath.item].companyLogoFileName, mapFileName: companyManager.companyModels[indexPath.item].companyMapFileName, name: companyManager.companyModels[indexPath.item].companyName, address: companyManager.companyModels[indexPath.item].companyStreetAddress, phoneNumber: companyManager.companyModels[indexPath.item].companyPhoneNumber, qrLink: companyManager.companyModels[indexPath.item].qrLink)
            cell = dataCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lib = BROTHERSDK()
        var IsOpen = 0
        #if true
        //*** BLUETOOTH - open bluetooth port
        IsOpen = lib.openportMFI("com.issc.datapath")
        #else
        IsOpen = lib.openport("192.168.0.143") // open wifi port
        #endif
        if(IsOpen == 1)
        {
            lib.sendCommand("DIRECTION 0\r\n")
            lib.sendCommand("SIZE 57 mm, 180 mm\r\n")
            lib.sendCommand("SPEED 4\r\n")
            lib.sendCommand("DENSITY 10\r\n")
            lib.sendCommand("SENSOR 0\r\n")
            lib.sendCommand("GAP 0 mm, 0 mm\r\n")
            lib.clearbuffer()
            lib.printerfont("20", y: "120", fontName: "3", rotation: "0", magnificationRateX: "1", magnificationRateY: "1", content: "=======================================\"\r\n")
            
            // COMPANY LOGO
            var absolutePath = companyManager.companyModels[indexPath.item].companyLogoUrl?.path
            lib.downloadpcx(absolutePath, asName: companyManager.companyModels[indexPath.item].companyLogoFileName)
            lib.sendCommand(companyManager.companyModels[indexPath.item].companyLogo)
            // COMPANY NAME
            lib.sendCommand(placeName(companyManager.companyModels[indexPath.item].companyName))
            // COMPANY ADDRESS
            lib.sendCommand(placeAddress(companyManager.companyModels[indexPath.item].companyStreetAddress))
            // COMPANY PHONE NUMBER
            lib.windowsfont(80, y: 520, height: 24, rotation: 0, style: 0, withUnderline: 0, fontName: "Arial-ItalicMT", content: "TEL \(companyManager.companyModels[indexPath.item].companyPhoneNumber)")
            // =================================
            lib.printerfont("20", y: "550", fontName: "1", rotation: "0", magnificationRateX: "1", magnificationRateY: "1", content: "=======================================\"\r\n")
            // DID YOU KNOW? - ARRAY
            lib.windowsfont(20, y: 570, height: 24, rotation: 0, style: 0, withUnderline: 0, fontName: "Arial-ItalicMT", content: "Did You Know?")
            lib.sendCommand("BLOCK 20,600,350,170,\"0\",0,8,8,5,2,\"\(companyManager.companyModels[indexPath.item].petTips[Int.random(in: 0..<companyManager.companyModels[indexPath.item].petTips.count)])\"\r\n")
            // FIRST TIME VISITOR?
            lib.windowsfont(20, y: 720, height: 24, rotation: 0, style: 0, withUnderline: 0, fontName: "Arial-ItalicMT", content: "First Time Visitor?")
            // MINI MAP
            absolutePath = companyManager.companyModels[indexPath.item].companyMapUrl?.path
            lib.downloadpcx(absolutePath, asName: companyManager.companyModels[indexPath.item].companyMapFileName)
            lib.sendCommand(companyManager.companyModels[indexPath.item].companyMap)
            // QR CODE
            lib.sendCommand(placeQrLink(companyManager.companyModels[indexPath.item].qrLink))
            // SCAN FOR PET
            lib.printerfont("20", y: "1300", fontName: "3", rotation: "0", magnificationRateX: "1", magnificationRateY: "1", content: "SCAN FOR PET OF THE DAY\"\r\n")
            // =================================
            lib.printerfont("20", y: "1330", fontName: "3", rotation: "0", magnificationRateX: "1", magnificationRateY: "1", content: "================================\"\r\n")
            // FAREWELL
            lib.sendCommand("BLOCK 20,1360,350,170,\"0\",0,8,8,5,2,\"Thank you for visiting. We hope to see you again!\"\r\n")
            lib.printlabel("1", copies: "1")
            lib.closeport(0) // close printer port
        }
    }
    

    @IBAction func printBtnPressed(_ sender: Any) {
    }
    
    // MARK: - Helper Functions
    func placeLogo(_ companyLogoFileName: String) -> String {
        return "PUTPCX 80,190,\"" + companyLogoFileName + "\"\r\n"
    }

    func placeMap(_ companyMapFileName: String) -> String {
        return "PUTPCX 80,760,\"" + companyMapFileName + "\"\r\n"
    }

    func placeName(_ companyName: String) -> String {
        return "TEXT 5,460,\"2\",0,2,2,\"" + companyName + "\"\r\n"
    }

    func placeQrLink(_ qrLink: String) -> String {
        return "QRCODE 100,1100, L, 6, M, 0, M2, \"B0049" + qrLink + "\"\r\n"
    }

    func placeAddress(_ address: String) -> String {
        return "BLOCK 20,500,350,40,\"0\",0,8,8,5,2,\"" + address + "\"\r\n"
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UIViewController,
           let firstVC = vc as? ViewController {
            firstVC.userDefaults = userDefaults
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.reloadData()
        do {
             companyManager = try userDefaults.getObj(forKey: "SavedItems", castTo: CompanyManager.self)
        } catch {
            print(error.localizedDescription)
        }
        self.view.layoutIfNeeded()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 5.0 // between each col
        layout.minimumInteritemSpacing = 2.0 // between each row
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 280, height: 200)
       
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
      
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.layer.borderColor = UIColor.black.cgColor
        
      //  collectionView.layer.borderWidth = 5
        collectionView.layer.cornerRadius = 7
        // Do any additional setup after loading the view.
    }
    

}
