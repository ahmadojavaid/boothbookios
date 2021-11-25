//
//  EditLeadFormViewController.swift
//  BoothBook
//
//  Created by abbas on 26/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit
import ChromaColorPicker
import RLBAlertsPickers

class EditLeadFormViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var btnSave:UIButton!
    var colorPicker:ColorPicker!
    var imagePicker:ImgPicker!
    let headerTitle:[(String, Bool)] = [
        ("Additional Details", false),
        ("Design", true),
        ("On Submit", true),
        ("Event Details", false),
        ("Customer Details", false),
        ("Venue Details", false)
    ]
    var listMataData:LeadFormSettingsModel! = LeadFormSettingsModel.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TextFieldSetupCell", bundle: .main), forCellReuseIdentifier: "TextFieldSetupCell")
        tableView.register(UINib(nibName: "EditLeadDesignCell", bundle: .main), forCellReuseIdentifier: "EditLeadDesignCell")
        tableView.register(UINib(nibName: "ThanYouCell", bundle: .main), forCellReuseIdentifier: "ThanYouCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: .main), forCellReuseIdentifier: "ButtonCell")
    }
    override func viewDidAppear(_ animated: Bool) {
        self.addObserverKeyBoardHide(selector: #selector(keyBoardDidHide))
        self.addObserverKeyBoardShow(selector: #selector(keyBoardDidShow))
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyBoardDidHide(){
        buttonSave(isEnable: true)
    }
    @objc func keyBoardDidShow(){
        buttonSave(isEnable: false)
    }
}

extension EditLeadFormViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMataData.listMataData[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hView = EditLeadsHeaderView()
        hView.setData(title: headerTitle[section].0, hide_D_R: headerTitle[section].1)
        return hView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = ("\(indexPath.section)\(indexPath.row)" as NSString).integerValue
        let cellData = listMataData[tag] //[indexPath.section][indexPath.row]
        if tag == 53 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
            cell.configureButton(cellData.0, selector: #selector(saveFormData(_:)), target: self)
            cell.button.layer.cornerRadius = 5
            btnSave = cell.button
            btnSave.tag = tag
            return cell
        }
        switch indexPath.section {
        case 0,3,4,5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldSetupCell") as! TextFieldSetupCell
            cell.configureCell(placeHolder: cellData.0, text: cellData.1, isOn1: cellData.2!, isOn2: cellData.3!, selector1: #selector(displaySwitchValueChanged(_:)), selector2: #selector(requiredSwitchValueChanged(_:)), target: self, tag:tag)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditLeadDesignCell") as! EditLeadDesignCell
            cell.configureCell(title: cellData.0, buttonTitle: cellData.1, selector: #selector(pickerButton(_:)), target: self, tag: tag)
            switch tag {
            case 16:
                cell.pickerButton.setBackgroundImage(listMataData.logoImage, for: .normal)
            case 10,11,14,15:
                cell.pickerButton.backgroundColor = UIColor.hexStringToUIColor(hex:  "#" + cellData.1.trimmed)
                
            default:
                return cell
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThanYouCell") as! ThanYouCell
            cell.setData(cellData.0, cellData.1, isOn: cellData.2!, selector: #selector(displaySwitchValueChanged(_:)), target: self, tag: tag)
            return cell
        }
        
    }
    
    @objc func pickerButton(_ sender: UIButton) {
        buttonSave(isEnable: true)
        switch sender.tag {
        case 10, 11, 14, 15: // Color Picker
            colorPicker = ColorPicker()
            colorPicker.pick(tag: sender.tag, color:sender.backgroundColor , view: view) { (colorPicker, tag, color)  in
                sender.backgroundColor = color
                sender.setTitle(" " + color.hexCode, for: .normal)
                self.listMataData[sender.tag].1 = color.hexCode
            }
        case 12:
            let fontPicker = FontPicker()
            fontPicker.pickFamily { (fontFamily) in
                fontPicker.pickFont(fimaly: fontFamily) { (font) in
                    //fontPicker.pickSize(completion: { (size) in
                        //let fontWithSize = font + "-\(size)px"
                    sender.setTitle(font, for: .normal)
                    self.listMataData[sender.tag].1 = font
                    //})
                }
            }
        case 13:
            TextPicker(title: "Submit Button Text?", placeHolder: "Submit", text: sender.titleLabel?.text?.trimmed ?? "").pick { (title) in
                sender.setTitle(" " + title, for: .normal)
                self.listMataData[sender.tag].1 = title
            }
        case 16:
            imagePicker = ImgPicker()
            imagePicker.pick(sender: sender, target: self) { (image) in
                //print("Deinited \(image?.size)")
                sender.setBackgroundImage(image, for: .normal)
                self.listMataData[sender.tag].1 = image?.accessibilityIdentifier ?? ""
                self.listMataData.logoImage = image
            }
        default:
            print("Picker Button With Tag: \(sender.tag)")
        }
    }
    
    @objc func displaySwitchValueChanged(_ sender: UISwitch) {
        buttonSave(isEnable: true)
        listMataData[sender.tag].2 = sender.isOn
        print("Display Switch Tag \(sender.tag)")
    }
    
    @objc func requiredSwitchValueChanged(_ sender: UISwitch) {
        buttonSave(isEnable: true)
        listMataData[sender.tag].3 = sender.isOn
        print("Required Switch Tag \(sender.tag)")
    }
    
    @objc func saveFormData(_ sender: UIButton) {
        buttonSave(isEnable: false)
        print("Save data with Tag \(sender.tag)")
        listMataData.save()
    }
    
    func buttonSave(isEnable:Bool){
        if btnSave?.isEnabled != isEnable {
            btnSave?.isEnabled = isEnable
            btnSave?.backgroundColor = isEnable ? #colorLiteral(red: 0.1541696191, green: 0.3441781998, blue: 0.5642041564, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
}

class ImgPicker:ImagePickerDelegate {
    var imagePicker:ImagePicker!
    var completion: ((UIImage?)->Void)!
    func pick(sender:UIView, target:UIViewController, completion:@escaping (UIImage?)->Void){
        self.completion = completion
        self.imagePicker = ImagePicker(presentationController: target, delegate: self)
        self.imagePicker.present(from: sender)
    }
    deinit {
        print("\n\n Deinited ImgPicker ......... \n\n")
    }
    func didSelect(image: UIImage?) {
        completion(image)
        imagePicker = nil
    }
}

class ColorPicker:NSObject, ChromaColorPickerDelegate {
    var completion: ((ChromaColorPicker, Int?, UIColor)->Void)!
    var tag:Int?
    var view2:UIView!
    func pickColor(tag:Int?, color:UIColor? = nil, completion: @escaping (Int?, UIColor)->Void){
        let alert = UIAlertController(style: .actionSheet)
        alert.addColorPicker(color: color ?? UIColor.black) { colorPicked in
            completion(tag, colorPicked)
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    func pick(tag:Int?, color:UIColor? = nil, view:UIView, completion: @escaping (ChromaColorPicker, Int?, UIColor)->Void){
        self.completion = completion
        self.tag = tag
        let neatColorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        if let color = color { neatColorPicker.adjustToColor(color) }
        neatColorPicker.delegate = self //ChromaColorPickerDelegate
        //neatColorPicker.padding = 5
        neatColorPicker.stroke = 3
        neatColorPicker.hexLabel.textColor = UIColor.black
        neatColorPicker.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        neatColorPicker.supportsShadesOfGray = true
        
        //neatColorPicker.frame = view.bounds
        neatColorPicker.frame.size = CGSize(width: view.frame.size.width/1.1, height: view.frame.size.width/1.1)
        neatColorPicker.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2 - 10)
        self.view2 = UIView(frame: view.bounds)
        view2.addSubview(neatColorPicker)
        view2.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        //neatColorPicker.frame.origin.y =
        //neatColorPicker.layer.borderWidth = 1
        //neatColorPicker.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(view2)
    }
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        completion(colorPicker, tag, color)
        view2.removeFromSuperview()
    }
}

class FontPicker:NSObject /*, UIPickerViewDelegate, UIPickerViewDataSource */ {
    
    var familyNames:[String:([String], [String])] = [:]
    var keys:[String] = []
    
    //var completion:((_ fontFamily:String)->Void)!
    var selectedKey:String = ""
    override init() {
        super.init()
        loadFonts()
        keys = Array(familyNames.keys).sorted()
        selectedKey = keys[62]
        //configurePickerFiew(view: view)
        //pickerView.reloadAllComponents()
    }
    
    func pickFamily(completion:@escaping ((_ fontFamily:String)->Void)) {
        let alert = UIAlertController(style: .actionSheet, title: "Select Font?", message: nil )
        
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: /*frameSizes.index(of: 216) ??*/ 62)
        alert.addPickerView(values: [keys], initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            ///if index.column == 0 {
                //print("Hello......\n")
            self.selectedKey = self.keys[index.row]
            //}
        }
        
        alert.addAction(title: "Done", style: .cancel) { (action) in
            completion(self.selectedKey)
            //print("selected: \(self.selectedKey)")
        }
        
        alert.show()
    }
    
    func pickFont(fimaly:String, completion:@escaping ((_ fontName:String)->Void)) {
        let alert = UIAlertController(style: .actionSheet, title: "Select Font Weight?", message: nil )
        let fontType = familyNames[fimaly]!.1
        var selectedFont = fontType.count > 0 ? familyNames[fimaly]!.0[0]:""
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        alert.addPickerView(values: [fontType], initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            selectedFont = self.familyNames[fimaly]!.0[index.row]
        }
        
        alert.addAction(title: "Done", style: .cancel) { (action) in
            completion(selectedFont)
        }
        
        alert.show()
    }
    
    func pickSize(completion:@escaping ((_ size:Int)->Void)) {
        let alert = UIAlertController(style: .actionSheet, title: "Select Font Size?", message: nil )
        let fontSizes = (6...32).map { return "\(Int($0))"}
        var selectedSize = "14"
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 8)
        alert.addPickerView(values: [fontSizes], initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            selectedSize = fontSizes[index.row]
        }
        
        alert.addAction(title: "Done", style: .cancel) { (action) in
            completion((selectedSize as NSString).integerValue)
        }
        
        alert.show()
    }
    
    fileprivate func loadFonts() {
        UIFont.familyNames.forEach({ familyName in
            familyNames[familyName] = ([],[])
        })
        
        for (selectedFimaly, _)in familyNames {
            let fontNm = UIFont.fontNames(forFamilyName: selectedFimaly)
            let fontNames = fontNm.map({ (fname) -> String in
                let name1 = selectedFimaly.replacingOccurrences(of: " ", with: "")
                let name = fname.replacingOccurrences(of: name1, with: "")
                return name == "" ? "-Regular":name
            })
            familyNames[selectedFimaly] = (fontNm,fontNames)
        }
    }
}

class TextPicker:NSObject /*, UIPickerViewDelegate, UIPickerViewDataSource */ {
    var title = ""
    var placeHolder = ""
    var text = ""
    
    var alert:UIAlertController!
    var config: TextField.Config!
    weak var textField:UITextField!
    
    init(title:String, placeHolder:String, text:String) {
        super.init()
        self.title = title
        self.placeHolder = placeHolder
        self.text = text
        
        alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        configureTextField ()
        alert.addOneTextField(configuration: config)
    }
    func configureTextField (){
        config = { textField in
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.placeholder = self.placeHolder
            textField.text = self.text
            textField.font = UIFont.OpenSans(ofSize: 14)
            //textField.left(image: image, color: .black)
            textField.leftViewPadding = 5
            textField.borderWidth = 1
            //textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            //textField.backgroundColor = nil
            //textField.keyboardAppearance = .default
            textField.keyboardType = .default
            //textField.isSecureTextEntry = true
            textField.returnKeyType = .done
            //textField.action { textField in
            //}
            self.textField = textField
        }
    }
    
    func pick(completion:@escaping ((_ text:String)->Void)) {
        alert.addAction(title: "OK", style: .cancel) { (action) in
            //completion()
            completion(self.textField?.text ?? "")
        }
        alert.show()
    }
}

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    deinit {
        print("\n\nImagePicker Deinitialized\n\n")
    }
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { /*[unowned self]*/ _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
