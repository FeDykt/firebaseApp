//
//  TableViewController.swift
//  firebaseApp
//
//  Created by fedot on 03.12.2021.
//

import UIKit
import Firebase

struct Model {
    var name: String
    var email: String
    var image: String
}

class TableViewController: UIViewController {

    var tableView = UITableView()
    var ref: DatabaseReference!
    var model: [Model] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableView()
//        getDataFB()
        getAllData()

        
        
        view.backgroundColor = .white
 
    }
    
    func createTableView() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(TestTableViewCell.nib(), forCellReuseIdentifier: TestTableViewCell.identifier)
        view.addSubview(tableView)
    }
    
    func getAllData() {
        ref = Database.database().reference().child("users")
        ref.observe(.childAdded) { [weak self] snapshot in
            guard let self = self else { return }
            
            guard let key = snapshot.key as? String else { return }
            guard let value = snapshot.value as? [String : Any] else { print("erororor"); return }
            
            if let email = value["email"] as? String, let image = value["image"] as? String, let name = value["name"] as? String {
                let modelData = Model(name: name, email: email, image: image)
                self.model.append(modelData)
                self.tableView.reloadData()
                
            } else {
                print("erroror")
            }
            
            self.tableView.reloadData()
        }
    }
    
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TestTableViewCell.identifier, for: indexPath) as! TestTableViewCell
        cell.configure(model[indexPath.row])
        return cell
    }
}
