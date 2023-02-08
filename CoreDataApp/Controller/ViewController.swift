//
//  ViewController.swift
//  CoreDataApp
//
//  Created by Aniket Patil on 23/01/23.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        }
    }
    var context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    var refreshControl = UIRefreshControl()
    var employeeData = [Employee](){
        didSet{
            print("Counttt---\(self.employeeData.count)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        check()
        self.refreshControl.tintColor = UIColor.gray
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClick))
    }
    @objc func refresh(sender:AnyObject) {
        self.API()
        refreshControl.endRefreshing()
    }
    func check(){
        do{
            if try context.fetch(Employee.fetchRequest()).isEmpty{
                self.API()
            } else{
                self.employeeData = try context.fetch(Employee.fetchRequest())
            }
        } catch {
            print("empty")
        }
    }
    @objc func addClick() {
        let alert = UIAlertController(title: "Add Neww", message: "", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "Enter FullName"
        }
        alert.addTextField{ tf in
            tf.placeholder = "Enter Organization Name"
        }
        alert.addTextField{ tf in
            tf.placeholder = "Enter Member Name"
        }
        alert.addTextField{ tf in
            tf.placeholder = "Enter Mobile No"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { _ in
            guard let nametf = alert.textFields?[0], let name = nametf.text, !name.isEmpty else{ return }
            
            guard let onametf = alert.textFields?[1], let oname = onametf.text, !oname.isEmpty else{ return }
            
            guard let Memnametf = alert.textFields?[2], let Memname = Memnametf.text, !Memname.isEmpty else{ return }
            
            guard let mobtf = alert.textFields?[3], let mob = mobtf.text, !mob.isEmpty else{ return }
            
            let model = EmployeeData(memberID: 0, memberName: Memname, profilePhoto: "", mobileNo: mob, organizationid: "", organizationName: oname, address: "", description: "", firstName: "", middleName: "", lastName: "", name: name, isChatBlock: false)
            self.save(object: model)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    private func API(){
        print("APICALLEDD")
        deleteAllData()
        var request = URLRequest(url: URL(string: "http://measervicetest.erpguru.in/service.asmx/getAllMemberListForMenu?MemberId=347")!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    print("APIDATA---",data)
                    if let parsedData = try? JSONDecoder().decode(ViewModel.self, from: data) {
                        print(parsedData)
                        for i in parsedData.data1{
                            DispatchQueue.main.async {
                                self.save(object: i)
                            }
                        }
                    } else {
                        print("Invalid Response")
                    }
                } catch {
                    print("error---",error)
                }
            }
        }.resume()
    }
    private func save(object: EmployeeData) {
        let Employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        Employee.fullName = object.name
        Employee.memberName = object.memberName
        Employee.mobileNo = object.mobileNo
        Employee.organizationName = object.organizationName
        Employee.profilePhoto = object.profilePhoto
        do {
            try context.save()
            print("successfully saved")
        } catch {
            print("Could not save")
        }
    }
    private func fetch() -> [Employee] {
        var collegeData = [Employee]()
        do {
            collegeData =
                    try context.fetch(Employee.fetchRequest())
        } catch {
            print("couldnt fetch")
        }
        return collegeData
    }
    
    private func deleteAllData(){
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            employeeData.removeAll()
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employeeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell{
            let data = employeeData[indexPath.row]
            cell.fullName.text = data.fullName
            cell.mobNo.text = "(Mob: \(data.mobileNo ?? ""))"
            cell.orgName.text = data.organizationName
            cell.memName.text = data.memberName
            cell.img.imageFromServerURL(urlString: data.profilePhoto ?? "")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
