//
//  GameViewController.swift
//  ARMagic
//
//  Created by Alex Nagy on 09/01/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

// https://developer.apple.com/documentation/scenekit/built_in_geometry_types

import ARKit
import LBTAComponents

class GameViewController: UIViewController, ARSCNViewDelegate {
  
  let arView: ARSCNView = {
    let view = ARSCNView()
//    view.translatesAutoresizingMaskIntoConstraints = false
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
//    addNode()
    var doesEarthNodeExistInScene = false
    arView.scene.rootNode.enumerateChildNodes { (node, _) in
      if node.name == "earth" {
        doesEarthNodeExistInScene = true
      }
    }
    if !doesEarthNodeExistInScene {
      addEarth()
    }
  }
  
  let minusButtonWidth = ScreenSize.width * 0.1
  lazy var minusButton: UIButton = {
    var button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "MinusButton").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = UIColor(white: 1.0, alpha: 0.7)
    button.layer.cornerRadius = minusButtonWidth * 0.5
    button.layer.masksToBounds = true
    button.addTarget(self, action: #selector(handleMinusButtonTapped), for: .touchUpInside)
    button.layer.zPosition = 1
    button.imageView?.contentMode = .scaleAspectFill
    return button
  }()
  
  @objc func handleMinusButtonTapped() {
    print("Tapped on minus button")
    removeAllBoxes()
  }
  
  let resetButtonWidth = ScreenSize.width * 0.1
  lazy var resetButton: UIButton = {
    var button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "ResetButton").withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = UIColor(white: 1.0, alpha: 0.7)
    button.layer.cornerRadius = resetButtonWidth * 0.5
    button.layer.masksToBounds = true
    button.addTarget(self, action: #selector(handleResetButtonTapped), for: .touchUpInside)
    button.layer.zPosition = 1
    button.imageView?.contentMode = .scaleAspectFill
    return button
  }()
  
  @objc func handleResetButtonTapped() {
    print("Tapped on reset button")
    resetScene()
  }
  
  let configuration = ARWorldTrackingConfiguration()
  
  var distanceLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.textColor = UIColor.black
    label.text = "Distance:"
    return label
  }()
  
  let xLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.textColor = UIColor.red
    label.text = "x:"
    return label
  }()
  
  let yLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.textColor = UIColor.green
    label.text = "y:"
    return label
  }()
  
  let zLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.textColor = UIColor.blue
    label.text = "z:"
    return label
  }()
  
  let centerImageView: UIImageView = {
    let view = UIImageView()
    view.image = #imageLiteral(resourceName: "Center")
    view.contentMode = .scaleAspectFill
    return view
  }()
  
  var startingPositionNode: SCNNode?
  var endingPositionNode: SCNNode?
  let cameraRelativePosition = SCNVector3(0,0,-0.1)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    setupViews()
    
    configuration.planeDetection = .horizontal
    arView.session.run(configuration, options: [])
    arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
    arView.autoenablesDefaultLighting = true
    arView.delegate = self
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    arView.addGestureRecognizer(tapGestureRecognizer)
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
    
    view.addSubview(minusButton)
    minusButton.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 24, widthConstant: minusButtonWidth, heightConstant: minusButtonWidth)
    
    view.addSubview(resetButton)
    resetButton.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 0, widthConstant: resetButtonWidth, heightConstant: resetButtonWidth)
    resetButton.anchorCenterXToSuperview()
    
    view.addSubview(distanceLabel)
    distanceLabel.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 24)
    
    view.addSubview(xLabel)
    view.addSubview(yLabel)
    view.addSubview(zLabel)
    
    xLabel.anchor(distanceLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 24)
    yLabel.anchor(xLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 24)
    zLabel.anchor(yLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 24)
    
    view.addSubview(centerImageView)
    centerImageView.anchorCenterSuperview()
    centerImageView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: ScreenSize.width * 0.05, heightConstant: ScreenSize.width * 0.05)
  }
  
  func addNode() {
    let shapeNode = SCNNode()
//    boxNode.geometry = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0.0002)
//    shapeNode.geometry = SCNCapsule(capRadius: 0.05, height: 0.20)
//    shapeNode.geometry = SCNCone(topRadius: 0.05, bottomRadius: 0.10, height: 0.15)
//    shapeNode.geometry = SCNTorus(ringRadius: 0.10, pipeRadius: 0.02)
    shapeNode.geometry = SCNTube(innerRadius: 0.10, outerRadius: 0.20, height: 0.15)
    shapeNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Material")
    shapeNode.position = SCNVector3(0.0, 0.0, -0.3)
    shapeNode.name = "node"
    arView.scene.rootNode.addChildNode(shapeNode)
  }
  
  func removeAllBoxes() {
    arView.scene.rootNode.enumerateChildNodes { (node, _) in
      if node.name == "node" {
        node.removeFromParentNode()
      }
    }
  }
  
  func resetScene() {
    arView.session.pause()
    arView.scene.rootNode.enumerateChildNodes { (node, _) in
      if node.name == "node" {
        node.removeFromParentNode()
      }
    }
    arView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
  }
  
  func createFloor(anchor: ARPlaneAnchor) -> SCNNode {
    let floor = SCNNode()
    floor.name = "floor"
    floor.eulerAngles = SCNVector3(90.degreesToRadians,0,0)
    floor.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
    floor.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Material")
    floor.geometry?.firstMaterial?.isDoubleSided = true
    floor.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
    return floor
  }
  
  func removeNode(named: String) {
    arView.scene.rootNode.enumerateChildNodes { (node, _) in
      if node.name == named {
        node.removeFromParentNode()
      }
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let anchcorPlane = anchor as? ARPlaneAnchor else { return }
    print("New Plane Anchor found with extent:", anchcorPlane.extent)
    let floor = createFloor(anchor: anchcorPlane)
    node.addChildNode(floor)
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    guard let anchcorPlane = anchor as? ARPlaneAnchor else { return }
    print("Plane Anchor updated with extent:", anchcorPlane.extent)
    removeNode(named: "floor")
    let floor = createFloor(anchor: anchcorPlane)
    node.addChildNode(floor)
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    guard let anchcorPlane = anchor as? ARPlaneAnchor else { return }
    print("Plane Anchor removed with extent:", anchcorPlane.extent)
    removeNode(named: "floor")
  }
  
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    
    if startingPositionNode != nil && endingPositionNode != nil {
      return
    }
    
    guard let xDistance = Service.distance3(fromStartingPositionNode: startingPositionNode, onView: arView, cameraRelativePosition: cameraRelativePosition)?.x else {return}
    guard let yDistance = Service.distance3(fromStartingPositionNode: startingPositionNode, onView: arView, cameraRelativePosition: cameraRelativePosition)?.y else {return}
    guard let zDistance = Service.distance3(fromStartingPositionNode: startingPositionNode, onView: arView, cameraRelativePosition: cameraRelativePosition)?.z else {return}
    
    DispatchQueue.main.async {
      self.xLabel.text = String(format: "x: %.2f", xDistance) + "m"
      self.yLabel.text = String(format: "y: %.2f", yDistance) + "m"
      self.zLabel.text = String(format: "z: %.2f", zDistance) + "m"
      self.distanceLabel.text = String(format: "Distance: %.2f", Service.distance(x: xDistance, y: yDistance, z: zDistance)) + "m"
    }
    
  }
  
  @objc func handleTap(sender: UITapGestureRecognizer) {
//    let tappedView = sender.view as! SCNView
//    let touchLocation = sender.location(in: tappedView)
//    let hitTest = tappedView.hitTest(touchLocation, options: nil)
//    if !hitTest.isEmpty {
//      let result = hitTest.first!
//      let name = result.node.name
//      let geometry = result.node.geometry
//      print("Tapped \(String(describing: name)) with geometry: \(String(describing: geometry))")
//    }
    
    if startingPositionNode != nil && endingPositionNode != nil {
      startingPositionNode?.removeFromParentNode()
      endingPositionNode?.removeFromParentNode()
      startingPositionNode = nil
      endingPositionNode = nil
    } else if startingPositionNode != nil && endingPositionNode == nil {
      let sphere = SCNNode(geometry: SCNSphere(radius: 0.002))
      sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.red
      Service.addChildNode(sphere, toNode: arView.scene.rootNode, inView: arView, cameraRelativePosition: cameraRelativePosition)
      endingPositionNode = sphere
    } else if startingPositionNode == nil && endingPositionNode == nil {
      let sphere = SCNNode(geometry: SCNSphere(radius: 0.002))
      sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
      Service.addChildNode(sphere, toNode: arView.scene.rootNode, inView: arView, cameraRelativePosition: cameraRelativePosition)
      startingPositionNode = sphere
    }
    
  }
  
  // Earth Material Resources:
  // https://www.solarsystemscope.com/
  //
  //
  // Basic Material Properties:
  //
  //
  // Diffuse: The diffuse property specifies the amount of light diffusely reflected from the surface.
  //
  // Specular: The specular property specifies the amount of light to reflect in a mirror-like manner.
  //
  // Emmision: The emission property specifies the amount of light the material emits. This emission does not light up other surfaces in the scene.
  //
  // Normal: The normal property specifies the surface orientation.
  
  func addEarth() {
    let earthNode = SCNNode()
    earthNode.name = "earth"
    earthNode.geometry = SCNSphere(radius: 0.2)
    earthNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "EarthDiffuse")
    earthNode.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "EarthSpecular")
    earthNode.geometry?.firstMaterial?.emission.contents = #imageLiteral(resourceName: "EarthEmmision")
    earthNode.geometry?.firstMaterial?.normal.contents = #imageLiteral(resourceName: "EarthNormal")
    earthNode.position = SCNVector3(0,0,-0.5)
    arView.scene.rootNode.addChildNode(earthNode)
    
    let rotate = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 15)
    let rotateForever = SCNAction.repeatForever(rotate)
    earthNode.runAction(rotateForever)
    
  }
  
}




































