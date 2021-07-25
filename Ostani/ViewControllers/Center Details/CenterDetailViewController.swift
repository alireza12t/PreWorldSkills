//
//  CenterDetailViewController.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import UIKit
import Alamofire

struct DetailItem {
    var detail, title: String
}

class CenterDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var id: String = ""
    var data: CenterDetail? = nil
    var details: [DetailItem] = []
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        Coordinator.popViewController(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        getCenterDetail()
    }
    
    func setupUI() {
        imageView.addBorder(cornerRadius: 20, color: .brandGreen, borderWidth: 3)
    }
    
    func getCenterDetail() {
        loadingIndicatorView.isHidden = false
        loadingIndicatorView.startAnimating()
        let url = "http://api.alihejazi.me/Center/GetCenter/"
        let parameters: [String: String] = [
            "id" : self.id
        ]
        let headders = HTTPHeaders([HTTPHeader(name: "Authorization", value: StoringData.token)])
        
        AF.request(url, method: .get, parameters: parameters, headers: headders)
            .responseDecodable(of: CenterDetail.self) { (response) in
                switch response.result {
                case .success(let model):
                    self.data = model
                    self.fillDetailsList()
                    DispatchQueue.main.async {
                        self.fillView()
                        self.loadingIndicatorView.isHidden = true
                        self.loadingIndicatorView.stopAnimating()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    BannerManager.showMessage(errorMessageStr: "خطا در دریافت اطلاعات مرکز")
                    DispatchQueue.main.async {
                        self.loadingIndicatorView.isHidden = true
                        self.loadingIndicatorView.stopAnimating()
                    }
                }
            }
    }
    
    func fillDetailsList() {
        if let data = self.data {
            details.append(DetailItem(detail: data.centerType.title, title: "نوع"))
            details.append(DetailItem(detail: data.telephone, title: "تلفن ثابت"))
            details.append(DetailItem(detail: data.address, title: "آدرس"))
        details.append(DetailItem(detail: String(data.score), title: "امتیاز مرکز"))
            details.append(DetailItem(detail: data.manager.firstName + " " + data.manager.lastName, title: "نام مالک مرکز"))
            details.append(DetailItem(detail: data.manager.nationalCode, title: "کد ملی مالک مرکز"))
            details.append(DetailItem(detail: data.manager.phoneNumber, title: "شماره تلفن مالک مرکز"))
            details.append(DetailItem(detail: data.manager.birthDate, title: "تاریخ تولد مالک مرکز"))
        }
    }
    
    func fillView() {
        if let data = self.data {
            nameLabel.text = data.name
            imageView.image = data.image.base64ToImage
            tableView.reloadData()
        }
    }
}

extension CenterDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if details.indices.contains(indexPath.row) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CenterDetailItemTableViewCell", for: indexPath) as! CenterDetailItemTableViewCell
            let cellData = details[indexPath.row]
            if indexPath.row == 0 {
                cell.detailLabel.textColor = .brandGreen
                cell.nameLabel.textColor = .brandGreen
            } else {
                cell.detailLabel.textColor = .lightGray
                cell.nameLabel.textColor = .lightGray
            }
            cell.detailLabel.text = cellData.detail
            cell.nameLabel.text = "\(cellData.title) : "
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}
