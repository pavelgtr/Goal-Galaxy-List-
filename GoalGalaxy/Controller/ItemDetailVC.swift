//
//  AddItemViewController.swift
//  GoalGalaxy
//
//  Created by Pavel Rivera on 5/25/23.
//

import UIKit

protocol ItemDetailVCDelegate: AnyObject { //see notes file for explanation 
    func editItemVCDidCancel(_ controller: ItemDetailVC) //for when the user presses Cancel,
    func editItemVC(_ controller: ItemDetailVC, didFinishAdding item: GGListItem) //for when they press Done.
    func editItemVC(_ controller: ItemDetailVC, didFinishEditing item: GGListItem) //this method is for editing
}

class ItemDetailVC: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ItemDetailVCDelegate?
    
    var itemToEdit: GGListItem?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true 
        }
        navigationItem.largeTitleDisplayMode = .never
        textField.delegate = self
        doneBarButton.isEnabled = false
   
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil //Disable cell selection
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.editItemVC(self, didFinishEditing: item)
        }
        else {
            let item = GGListItem()
            item.text = textField.text!
            delegate?.editItemVC(self, didFinishAdding: item)
        }
          
    }
    
    @IBAction func cancel() {
        delegate?.editItemVCDidCancel(self) //When user taps  Cancel button, you send the editItemVCDidCancel(_:) message back to the delegate.
    }
    
    //MARK: - Textfield delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true) //hides keyboard
        return false
    }
    
    // enable or disable the "Done" button as soon as the text field's content changes (which makes the app feel more responsive)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
  
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true 
    }
    
    //to handle the Clear button correctly and disable the Done button, add:
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    }


