//
//  DetailViewController.swift
//  CustomTransitionDemo
//
//  Created by GuoYongming on 2021/1/31.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var clickView: UIView?
    
    var typeArray: Array<TransitionType> = [.circle, .boom, .spreadFromRight, .spreadFromLeft, .spreadFromTop, .spreadFromBottom]
    var selectedTransitionType: TransitionType = .none

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "详情"
        tableView.backgroundColor = view.backgroundColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.delegate = nil
    }
    
    func createTransition(operation: TransitionOperation) -> Transition? {
        switch selectedTransitionType {
        case .circle:
            let animation = CircleTransition()
            animation.operation = operation
            animation.clickView = clickView
            return animation
        case .boom:
            let animation = BoomTransition()
            animation.operation = operation
            return animation
        case .spreadFromRight:
            let animation = SpreadTransition()
            animation.direction = .fromRight
            animation.operation = operation
            return animation
        case .spreadFromLeft:
            let animation = SpreadTransition()
            animation.direction = .fromLeft
            animation.operation = operation
            return animation
        case .spreadFromTop:
            let animation = SpreadTransition()
            animation.direction = .fromTop
            animation.operation = operation
            return animation
        case .spreadFromBottom:
            let animation = SpreadTransition()
            animation.direction = .fromBottom
            animation.operation = operation
            return animation
        default:
            return nil
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.backgroundColor = tableView.backgroundColor
        let type = typeArray[indexPath.row]
        cell.textLabel?.text = type.text
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Push Animation"
        }else {
            return "Present Animation"
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = typeArray[indexPath.row]
        selectedTransitionType = type
        if type == .circle {
            clickView = tableView.cellForRow(at: indexPath)?.contentView
        }
        if indexPath.section == 0 {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.transitioningDelegate = self
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return createTransition(operation: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return createTransition(operation: .dismiss)
    }
}

extension DetailViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            return createTransition(operation: .push)
        }else if operation == .pop {
            return createTransition(operation: .pop)
        }else {
            return nil
        }
    }
}
