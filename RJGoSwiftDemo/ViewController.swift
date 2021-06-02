
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
    
    @IBOutlet weak var selectedLogoLbl: UILabel!
    @IBOutlet weak var selectedMapLbl: UILabel!
    
    var companyName = "", qrLink = "", companyLogo = "", companyLogoFileName = "", companyMapFileName = "", companyMap = "", companyPhoneNumber = "", companyStreetAddress = ""
    var companyLogoUrl = URL(string: ""), companyMapUrl = URL(string: "")
    let petTips = ["Adopting a pet is like having a 24/7 personal nurse.",
                   "Adopting a pet helps you to become friendlier and more approachable. A common interest brings people together.",
                   "Adopting a pet can help kids learn responsibility by teaching them to care for their pet.",
                   "Adopting a pet can bring so much love and joy into your home.",
                   "Adopting a pet can help with depression by getting your mind off your own issues."
    ]

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if uploadLogoBtn.isSelected {
            uploadLogoBtn.isSelected = false
            companyLogoUrl = url
            companyLogoFileName = url.lastPathComponent
            companyLogo = "PUTPCX 80,190,\"" + companyLogoFileName + "\"\r\n"
            selectedLogoLbl.text = companyLogoFileName
        } else if uploadMapBtn.isSelected {
            uploadMapBtn.isSelected = false
            companyMapUrl = url
            companyMapFileName = url.lastPathComponent
            companyMap = "PUTPCX 80,760,\"" + companyMapFileName + "\"\r\n"
            selectedMapLbl.text = companyMapFileName
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {         // company name text field
            if let text = textField.text {
                companyName = "TEXT 5,460,\"2\",0,2,2,\"" + text + "\"\r\n"
            }
        } else if textField.tag == 2 { // qr link text field
            if let text = textField.text { // 37
                qrLink = "QRCODE 100,1100, L, 6, M, 0, M2, \"B0049" + text + "\"\r\n"
            }
        } else if textField.tag == 3 { // street address text field
            if let text = textField.text {
                companyStreetAddress = "BLOCK 20,500,350,40,\"0\",0,8,8,5,2,\"" + text + "\"\r\n"
            }
        } else if textField.tag == 4 { // phone number text field
            if let text = textField.text {
                companyPhoneNumber = text
            }
        }
    }
    
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
            var absolutePath = companyLogoUrl?.path
            lib.downloadpcx(absolutePath, asName: companyLogoFileName)
            lib.sendCommand(companyLogo)
            // COMPANY NAME
            lib.sendCommand(companyName)
            // COMPANY ADDRESS
            lib.sendCommand(companyStreetAddress)
            // COMPANY PHONE NUMBER
            lib.windowsfont(80, y: 520, height: 24, rotation: 0, style: 0, withUnderline: 0, fontName: "Arial-ItalicMT", content: "TEL \(companyPhoneNumber)")
            // =================================
            lib.printerfont("20", y: "550", fontName: "1", rotation: "0", magnificationRateX: "1", magnificationRateY: "1", content: "=======================================\"\r\n")
            // DID YOU KNOW? - ARRAY
            lib.windowsfont(20, y: 570, height: 24, rotation: 0, style: 0, withUnderline: 0, fontName: "Arial-ItalicMT", content: "Did You Know?")
            lib.sendCommand("BLOCK 20,600,350,170,\"0\",0,8,8,5,2,\"\(petTips[Int.random(in: 0..<petTips.count)])\"\r\n")
            // FIRST TIME VISITOR?
            lib.windowsfont(20, y: 720, height: 24, rotation: 0, style: 0, withUnderline: 0, fontName: "Arial-ItalicMT", content: "First Time Visitor?")
            // MINI MAP
            absolutePath = companyMapUrl?.path
            lib.downloadpcx(absolutePath, asName: companyMapFileName)
            lib.sendCommand(companyMap)
            // QR CODE
            lib.sendCommand(qrLink)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        printBtn.layer.cornerRadius = 5
        uploadLogoBtn.layer.cornerRadius = 5
        uploadMapBtn.layer.cornerRadius = 5
        
    }
}
