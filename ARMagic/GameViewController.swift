//
//  GameViewController.swift
//  ARMagic
//
//  Created by Alex Nagy on 09/01/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import ARKit
import LBTAComponents

class GameViewController: UIViewController {
  
  let arView: ARSCNView = {
    let view = ARSCNView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let plusButtonWidth = ScreenSize.width * 0.1
  lazy var plusButton: UIButton = {
    var button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "PlusButton").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = UIColor(white: 1.0, alpha: 0.7)
    button.layer.cornerRadius = plusButtonWidth * 0.5
    button.layer.masksToBounds = true
    button.addTarget(self, action: #selector(handlePlusButtonTapped), for: .touchUpInside)
    button.layer.zPosition = 1
    button.imageView?.contentMode = .scaleAspectFill
    return button
  }()
  
  @objc func handlePlusButtonTapped() {
    print("Tapped on plus button")
    addBox()
  }
  
  let configuration = ARWorldTrackingConfiguration()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    setupViews()
    
    arView.session.run(configuration, options: [])
    arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
    arView.autoenablesDefaultLighting = true
  }
  
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  func setupViews() {
//    arView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//    arView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//    arView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    arView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    
    view.addSubview(arView)
//    arView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    arView.fillSuperview()
    
    view.addSubview(plusButton)
    plusButton.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 24, bottomConstant: 12, rightConstant: 0, widthConstant: plusButtonWidth, heightConstant: plusButtonWidth)
  }
  
  func addBox() {
    let boxNode = SCNNode()
    boxNode.geometry = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0.0002)
    boxNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Material")
    boxNode.position = SCNVector3(0,0,-0.3)
    arView.scene.rootNode.addChildNode(boxNode)
  }
  
  
}


















