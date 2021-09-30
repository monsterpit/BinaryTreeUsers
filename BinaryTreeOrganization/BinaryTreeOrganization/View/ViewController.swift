//
//  ViewController.swift
//  BinaryTreeOrganization
//
//  Created by Vikas S on 30/09/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var binaryTreeTableView: YSTreeTableView!
    
    var viewModel: ViewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getAllOrganizationData { (nodes) in
            self.binaryTreeTableView.rootNodes =  nodes
        }
        
    }
}
