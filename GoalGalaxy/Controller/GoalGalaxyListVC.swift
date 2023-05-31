
import UIKit

//TODO: Sending data between view controllers https://www.kodeco.com/books/uikit-apprentice/v10.0/chapters/14-edit-items

class GoalGalaxyListVC: UITableViewController, ItemDetailVCDelegate {
 
    var items = [GGListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()

        title = "Goal Galaxy List"
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")

    }
    
    func configureItems() { // adding placeholder list of items
    
        let item1 = GGListItem()
        item1.text = "Walk the dog"
        let item2 = GGListItem()
        item2.text = "Brush my teeth"
        item2.checked = true
        let item3 = GGListItem()
        item3.text = "Learn iOS development"
        item3.checked = true
        let item4 = GGListItem()
        item4.text = "Soccer practice"
        let item5 = GGListItem()
        item5.text = "Eat ice cream"
        let item6 = GGListItem()
        item6.text = "🧛🏿‍♀️"
        let itemsToAdd = [item1, item2, item3, item4, item5, item6]
        for item in itemsToAdd {
            items.append(item)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //what if we had two sections???
        //TODO: try having two sections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellListLabel", for: indexPath)
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
//        configureCheckmark(for: cell, with: item)
  
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            configureText(for: cell, with: item)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
    
  
     // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
            // Remove item from the data source
            items.remove(at: indexPath.row)
            
            // Delete the row from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
       
    }
    
    func configureText(for cell: UITableViewCell, with item: GGListItem) {
        var content = cell.defaultContentConfiguration()
        content.text = item.text
        
        content.image = item.checked ? UIImage(systemName: "checkmark") : UIImage(systemName: "circle")

        cell.contentConfiguration = content
    }
 
    //MARK: - Add Item ViewController Delegates
    
    func editItemVCDidCancel(_ controller: ItemDetailVC) {
        navigationController?.popViewController(animated: true)
    }
    
    func editItemVC(_ controller: ItemDetailVC, didFinishAdding item: GGListItem) {
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func editItemVC(_ controller: ItemDetailVC, didFinishEditing item: GGListItem) {
        // firstIndex(where:) is a function that finds the first item in the 'items' array that satisfies a condition. The condition is provided in the closure { $0 === item }.$0 refers to the current element being inspected in the 'items' array. We are asking Swift to find the first element where the current element ($0) and the 'item' parameter refer to the exact same instance (not merely two instances that are equal in value).
        // The === operator is used here to compare object identities, which means it checks whether two variables (in this case $0 and item) refer to exactly the same instance of a class.
        if let index = items.firstIndex(where: { $0 === item }) {
            // If such an item is found, we create an IndexPath for this item in the table view (assuming there is only one section). The row of the IndexPath is the index we just found.
            let indexPath = IndexPath(row: index, section: 0)
            // We then ask the table view for the cell at this IndexPath. The cell may not exist, for example if that row of the table view is currently off-screen, so we get an optional UITableViewCell back.
            if let cell = tableView.cellForRow(at: indexPath) {
                // If we got a cell (i.e., if the cell is not nil), we configure this cell with the new item information.
                configureText(for: cell, with: item)
            }
        }
        // Finally, we pop the AddItemViewController off the navigation stack to return to the GoalGalaxyListVC view controller.
        navigationController?.popViewController(animated: true)
    }


     // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "AddItem" {
             let controller = segue.destination as! ItemDetailVC
             controller.delegate = self
         } else if segue.identifier == "EditItem" {
             let controller = segue.destination as! ItemDetailVC
             controller.delegate = self
             
             if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) { //sender is the cell whose disclosure button was tapped.
                 controller.itemToEdit = items[indexPath.row]
             }
         }
     }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appending(path: "Checklists.plist", directoryHint: .inferFromPath) //did my own thing here
    }

}
