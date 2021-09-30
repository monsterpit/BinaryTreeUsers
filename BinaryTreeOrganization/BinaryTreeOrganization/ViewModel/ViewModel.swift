//
//  ViewModel.swift
//  BinaryTreeOrganization
//
//  Created by Vikas S on 01/10/21.
//

import Foundation

class ViewModel{
    
    var userDatas: [UserData] = []
    
    func getAllOrganizationData(completion: @escaping ([YSTreeTableViewNode]) -> ()){
        getData {userData in
            switch userData{
            case .success(let userDatas):
                DispatchQueue.main.async {
                    self.userDatas = userDatas
                    if !self.userDatas.isEmpty{

                        if let nodes = self.insertLevelOrder(rootNode: nil, index: 0){
                            completion([nodes])
                        }else{
                            completion([])
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getData(completion: @escaping (Result<[UserData],Error>) -> ()){
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: "https://jsonplaceholder.typicode.com/users")!) { (data, response, error) in
            guard  error  == nil else {print(error?.localizedDescription ?? "Unknown error"); completion(.failure(error!)); return}
            
            if  response != nil,let data = data{
                do {
                    let userData = try JSONDecoder().decode([UserData].self, from: data)
                    completion(.success(userData ))
                } catch let error {
                    completion(.failure(error))
                }
            }else{
                completion(.failure(NSError(domain: "Unknown Error", code: 200, userInfo: [NSLocalizedDescriptionKey: "Unknown Error"])))
            }
        }.resume()
    }
    
    private func insertLevelOrder(rootNode:  YSTreeTableViewNode?,index: Int) -> YSTreeTableViewNode?{
        var rootNode = rootNode
        if index < userDatas.count{
            let tempNode = YSTreeTableViewNode(nodeID: index, nodeName: userDatas[index].name ?? "")
            rootNode = tempNode
            
            rootNode?.addChildNode(childNode: insertLevelOrder(rootNode: rootNode?.subNodes.first, index: 2 * index + 1))
            rootNode?.addChildNode(childNode: insertLevelOrder(rootNode: rootNode?.subNodes.last, index: 2 * index + 2))
        }
        return rootNode
    }
}
