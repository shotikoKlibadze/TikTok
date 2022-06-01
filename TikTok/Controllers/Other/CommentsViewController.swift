//
//  CommentsViewController.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 05.05.22.
//

import UIKit

protocol CommentsViewControllerDelegate: AnyObject {
    func didTapCloseForComments(with viewController: CommentsViewController)
}
class CommentsViewController: UIViewController {
    
    private let post : PostModel
    private var comments = [PostComment]()
    weak var delegate : CommentsViewControllerDelegate?
    
    let tableView : UITableView = {
        let tableview = UITableView()
        tableview.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        return tableview
    }()
    
    private let closeButton : UIButton = {
        let btn = UIButton()
        btn.tintColor = .blue
        btn.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        return btn
    }()
    
    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        fetchPostComments()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 60, y: 10, width: 35, height: 35)
        tableView.frame = CGRect(x: 0, y: closeButton.bottom, width: view.width, height: view.height - closeButton.bottom)
    }
    
    @objc func closeButtonTapped() {
        delegate?.didTapCloseForComments(with: self)
    }
    
    func fetchPostComments() {
        comments = PostComment.mockComments()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CommentsViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        let comment = comments[indexPath.row]
        cell.configure(model: comment)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
