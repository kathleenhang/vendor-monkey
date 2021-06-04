
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ViewController: UIViewController, UITextFieldDelegate, UIDocumentPickerDelegate {
    
    @IBOutlet weak var qrTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyStreetAddressTextfield: UITextField!
    @IBOutlet weak var companyPhoneNumberTextfield: UITextField!
    
    @IBOutlet weak var uploadMapBtn: UIButton!
    @IBOutlet weak var uploadLogoBtn: UIButton!
    @IBOutlet weak var printBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var selectedLogoLbl: UILabel!
    @IBOutlet weak var selectedMapLbl: UILabel!
    @IBOutlet weak var derpTestLbl: UILabel!
    
    @IBOutlet weak var derpTestField: UITextField!
    
    
    // MARK: - Properties
    let userDefaults = UserDefaults.standard // save company manager
    let companyManager = CompanyManager()
    var companyModel = CompanyModel()
    
    // MARK: - Document Picker Delegate Methods
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if uploadLogoBtn.isSelected {
            uploadLogoBtn.isSelected = false
            companyModel.companyLogoUrl = url
            companyModel.companyLogoFileName = url.lastPathComponent
            companyModel.companyLogo = "PUTPCX 80,190,\"" + companyModel.companyLogoFileName + "\"\r\n"
            selectedLogoLbl.text = companyModel.companyLogoFileName
        } else if uploadMapBtn.isSelected {
            uploadMapBtn.isSelected = false
            companyModel.companyMapUrl = url
            companyModel.companyMapFileName = url.lastPathComponent
            companyModel.companyMap = "PUTPCX 80,760,\"" + companyModel.companyMapFileName + "\"\r\n"
            selectedMapLbl.text = companyModel.companyMapFileName
        }
    }
    
    
    // MARK: - Textfield Delegate Methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {         // company name text field
            if let text = textField.text {
                companyModel.companyName = "TEXT 5,460,\"2\",0,2,2,\"" + text + "\"\r\n"
            }
        } else if textField.tag == 2 { // qr link text field
            if let text = textField.text { // 37
                companyModel.qrLink = "QRCODE 100,1100, L, 6, M, 0, M2, \"B0049" + text + "\"\r\n"
            }
        } else if textField.tag == 3 { // street address text field
            if let text = textField.text {
                companyModel.companyStreetAddress = "BLOCK 20,500,350,40,\"0\",0,8,8,5,2,\"" + text + "\"\r\n"
            }
        } else if textField.tag == 4 { // phone number text field
            if let text = textField.text {
                companyModel.companyPhoneNumber = text
            }
        } else if textField.tag == 5 {
            if let text = textField.text {
                userDefaults.setValue(text, forKey: "DerpTest")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - IBAction Methods
    @IBAction func Send(_ sender: UIButton)
    {
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
            var absolutePath = companyModel.companyLogoUrl?.path
            lib.downloadpcx(absolutePath, asName: companyModel.companyLogoFileName)
            lib.sendCommand(companyModel.companyLogo)
            // COMPANY NAME
            lib.sendCommand(companyModel.companyName)
            // COMPANY ADDRESS
            lib.sendCommand(companyModel.companyStreetAddress)
            // COMPANY PHONE NUMBER
            lib.windowsfont(80, y: 520, height: 24, rotation: 0, style: 0, withUnderline: 0, fontName: "Arial-ItalicMT", content: "TEL \(companyModel.companyPhoneNumber)")
            // =================================
            lib.printerfont("20", y: "550", fontName: "1", rotation: "0", magnificationRateX: "1", magnificationRateY: "1", content: "=======================================\"\r\n")
            // DID YOU KNOW? - ARRAY
            lib.windowsfont(20, y: 570, height: 24, rotation: 0, style: 0, withUnderline: 0, fontName: "Arial-ItalicMT", content: "Did You Know?")
            lib.sendCommand("BLOCK 20,600,350,170,\"0\",0,8,8,5,2,\"\(companyModel.petTips[Int.random(in: 0..<companyModel.petTips.count)])\"\r\n")
            // FIRST TIME VISITOR?
            lib.windowsfont(20, y: 720, height: 24, rotation: 0, style: 0, withUnderline: 0, fontName: "Arial-ItalicMT", content: "First Time Visitor?")
            // MINI MAP
            absolutePath = companyModel.companyMapUrl?.path
            lib.downloadpcx(absolutePath, asName: companyModel.companyMapFileName)
            lib.sendCommand(companyModel.companyMap)
            // QR CODE
            lib.sendCommand(companyModel.qrLink)
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
    
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        companyManager.companyModels.append(companyModel)
        do {
            try userDefaults.setObj(companyManager, forKey: "SavedItems")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func derpPressed(_ sender: Any) {
        print(userDefaults.value(forKey: "DerpTest"))
        derpTestLbl.text = userDefaults.value(forKey: "DerpTest") as! String
    }
    
    @IBAction func uploadLogoPressed(_ sender: Any) {
        uploadLogoBtn.isSelected = true
        let pcxUTType = UTType("com.app.pcx")!
        let supportedFiles: [UTType] = [pcxUTType]
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedFiles, asCopy: true)
        controller.delegate = self
        controller.allowsMultipleSelection = false
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func uploadMapPressed(_ sender: Any) {
        uploadMapBtn.isSelected = true
        let pcxUTType = UTType("com.app.pcx")!
        let supportedFiles: [UTType] = [pcxUTType]
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedFiles, asCopy: true)
        controller.delegate = self
        controller.allowsMultipleSelection = false
        present(controller, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        companyNameTextField.returnKeyType = .done
        companyNameTextField.autocapitalizationType = .allCharacters
        companyNameTextField.autocorrectionType = .no
        companyNameTextField.delegate = self
        
        qrTextField.returnKeyType = .done
        qrTextField.autocapitalizationType = .none
        qrTextField.autocorrectionType = .no
        qrTextField.delegate = self
        
        companyStreetAddressTextfield.returnKeyType = .done
        companyStreetAddressTextfield.autocapitalizationType = .words
        companyStreetAddressTextfield.autocorrectionType = .no
        companyStreetAddressTextfield.delegate = self
        
        companyPhoneNumberTextfield.returnKeyType = .done
        companyPhoneNumberTextfield.autocapitalizationType = .allCharacters
        companyPhoneNumberTextfield.autocorrectionType = .no
        companyPhoneNumberTextfield.delegate = self
        
        derpTestField.delegate = self
        
        printBtn.layer.cornerRadius = 5
        uploadLogoBtn.layer.cornerRadius = 5
        uploadMapBtn.layer.cornerRadius = 5
        saveBtn.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UIViewController,
           let secondVC = vc as? SecondViewController {
            secondVC.userDefaults = userDefaults
        }
    }
}


// MARK: - Helper Functions
//func placeLogo() -> String {
//    return "PUTPCX 80,190,\"" + companyModel.companyLogoFileName + "\"\r\n"
//}
//
//func placeMap() -> String {
//    return "PUTPCX 80,760,\"" + companyModel.companyMapFileName + "\"\r\n"
//}
//
//func placeName() -> String {
//    return "TEXT 5,460,\"2\",0,2,2,\"" + text + "\"\r\n"
//}
//
//func placeQrLink() -> String {
//    return "QRCODE 100,1100, L, 6, M, 0, M2, \"B0049" + text + "\"\r\n"
//}
//
//func placeAddress() -> String {
//    return "BLOCK 20,500,350,40,\"0\",0,8,8,5,2,\"" + text + "\"\r\n"
//}




// MARK: - Extensions
protocol ObjectSavable {
    func setObj<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObj<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func getObj<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object : Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
    
    func setObj<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}
