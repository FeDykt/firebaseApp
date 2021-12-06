//
//  TableViewController.swift
//  firebaseApp
//
//  Created by fedot on 03.12.2021.
//

import UIKit
import Firebase


class TableViewController: UIViewController {

    var tableView = UITableView()
    var ref: DatabaseReference!
    var model: [ModelUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableView()
        getAllData()
 
        view.backgroundColor = .white
 
    }
    
    func createTableView() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        view.addSubview(tableView)
    }
    
    func getAllData() {
        ref = Database.database().reference().child("users")
        ref.observe(.childAdded) { [weak self] snapshot in
            guard let self = self else { return }
            
            guard let value = snapshot.value as? [String : Any] else { print("error value"); return }
            guard let name = value["name"] as? String else { return }
            guard let avatar = value["avatar"] as? String else { return }
            guard let image = value["image"] as? String else { return }
            let modelData = ModelUser(name: name, image: image, avatar: avatar)
            
            DispatchQueue.main.async {
                self.model.append(modelData)
                self.tableView.reloadData()
            }
           
        }
    }

    
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.configure(model[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}
