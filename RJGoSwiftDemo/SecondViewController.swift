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
    
    var userDefaults = UserDefaults()
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
