//
//  ViewController.swift
//  FlowerShop
//
//  Created by Brian Advent on 14.06.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    var node = SCNNode()
    var dotNodes = [SCNNode]()
    var posArray = [Position]()
    
    var pressed = false
    var count = 0
    var count2 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Object Detection
        configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "FlowerObjects", bundle: Bundle.main)!

        // Run the view's session
        sceneView.session.run(configuration)
        print(configuration.detectionObjects.count)
        
        let dot = SCNSphere(radius: 0.05)
        let dotNode = SCNNode(geometry: dot)
        dotNode.position = SCNVector3Make(-0.00011622906, 0.238536, -0.0013985336)
        sceneView.scene.rootNode.addChildNode(dotNode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
     func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
           print("hi "+"yo")
           let node = SCNNode()
           
        if(self.pressed==false){
            if let objectAnchor = anchor as? ARObjectAnchor{
             
              let plane = SCNPlane(width: CGFloat(objectAnchor.referenceObject.extent.x * 0.8), height: CGFloat(objectAnchor.referenceObject.extent.y * 0.5))
                
                plane.cornerRadius = plane.width / 8
                
                let spriteKitScene = SKScene(fileNamed: "ProductInfo")
                
                plane.firstMaterial?.diffuse.contents = spriteKitScene
                plane.firstMaterial?.isDoubleSided = true
                plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
             
                
                let planeNode = SCNNode(geometry: plane)
                //planeNode.eulerAngles.x = -.pi/2
                planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y + 0.35, objectAnchor.referenceObject.center.z)
                
             
                let scale = CGFloat(objectAnchor.referenceObject.scale.x)
                let boundingBoxNode = BlackMirrorzBoundingBox(points: objectAnchor.referenceObject.rawFeaturePoints.points, scale: scale)
                
                let dotGeometry = SCNSphere(radius: 0.05)
                
             
                
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.red
                dotGeometry.materials = [material]
                
                
                node.addChildNode(boundingBoxNode)
                node.addChildNode(planeNode)
            }
        }
        
       }
       
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if(self.pressed == false){
            print("hi "+anchor.name!)
            
            
            
            if let objectAnchor = anchor as? ARObjectAnchor {
                
                
                let plane = SCNPlane(width: CGFloat(objectAnchor.referenceObject.extent.x * 0.8), height: CGFloat(objectAnchor.referenceObject.extent.y * 0.5))
                
                plane.cornerRadius = plane.width / 8
                
                let spriteKitScene = SKScene(fileNamed: "ProductInfo")
                plane.firstMaterial?.diffuse.contents = spriteKitScene
                plane.firstMaterial?.isDoubleSided = true
                plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
                
                let planeNode = SCNNode(geometry: plane)
                
                
                planeNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x, objectAnchor.referenceObject.center.y + 0.35, objectAnchor.referenceObject.center.z)
                
                var currPos: Position!
                currPos = Position(x: objectAnchor.referenceObject.center.x, y: objectAnchor.referenceObject.center.y, z: objectAnchor.referenceObject.center.z, vector: planeNode.position)
                
                
                self.posArray.append(currPos)
                //print("x",objectAnchor.referenceObject.extent.x,"y",currPos.vector.y,"z",currPos.vector.z, "p", planeNode.position.x)
                
                
                let scale = CGFloat(objectAnchor.referenceObject.scale.x)
                let boundingBoxNode = BlackMirrorzBoundingBox(points: objectAnchor.referenceObject.rawFeaturePoints.points, scale: scale)
                
                let dotGeometry = SCNSphere(radius: 0.02)
                
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.red
                dotGeometry.materials = [material]
                
                
                
                let dotNode = SCNNode(geometry: dotGeometry)
                
                
                dotNode.position = SCNVector3Make(objectAnchor.transform.columns.3.x, objectAnchor.transform.columns.3.y, objectAnchor.transform.columns.3.z)
                
                print("x",objectAnchor.transform.columns.3.x,"y",objectAnchor.transform.columns.3.y,"z",objectAnchor.transform.columns.3.z)
                
                dotNodes.append(dotNode)
                print("For Count: " ,dotNodes.count)
                sceneView.scene.rootNode.addChildNode(dotNode)
                
                
                
                node.addChildNode(boundingBoxNode)
                node.addChildNode(planeNode)
                
                
            }
            sceneView.session.pause()
            sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            let configuration = ARWorldTrackingConfiguration()
            configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "FlowerObjects", bundle: Bundle.main)!
            
            sceneView.session.run(configuration, options: [.removeExistingAnchors])
        }
        
        
        return node
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    @IBAction func showNodes(_ sender: Any) {
        self.pressed = true
        for node in self.dotNodes{
            print("pressed")
            self.sceneView.scene.rootNode.addChildNode(node)
        }
        
        for i in 0..<self.dotNodes.count-1 {
            self.sceneView.scene.rootNode.addChildNode(lineBetweenNodes(positionA: dotNodes[i].position, positionB: dotNodes[i+1].position, inScene: sceneView.scene))
            //dotNodes[i].simdTransform.columns.3.
        }
    }
    
    
    func lineBetweenNodes(positionA: SCNVector3, positionB: SCNVector3, inScene: SCNScene) -> SCNNode {
        let vector = SCNVector3(positionA.x - positionB.x, positionA.y - positionB.y, positionA.z - positionB.z)
        let distance = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
        let midPosition = SCNVector3 (x:(positionA.x + positionB.x) / 2, y:(positionA.y + positionB.y) / 2, z:(positionA.z + positionB.z) / 2)

        let lineGeometry = SCNCylinder()
        lineGeometry.radius = 0.05
        lineGeometry.height = CGFloat(distance)
        lineGeometry.radialSegmentCount = 5
        lineGeometry.firstMaterial!.diffuse.contents = UIColor.red

        let lineNode = SCNNode(geometry: lineGeometry)
        lineNode.position = midPosition
        lineNode.look (at: positionB, up: inScene.rootNode.worldUp, localFront: lineNode.worldUp)
        return lineNode
    }
    
}
