//
//  ViewController.swift
//  ArJam
//
//  Created by Noirdemort on 07/11/18.
//  Copyright © 2018 Noirdemort. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // create debug options
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    @IBAction func addObjects(_ sender: Any) {
        let node = SCNNode()
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
        node.geometry?.materials = [material]
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange
        node.position = SCNVector3(0, 0, 0.1)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    
    
    @IBAction func resetScene(_ sender: Any) {
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes{ (node, _) in
            node.removeFromParentNode()
        }
        viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return} //Get's touch on screen
        let result = sceneView.hitTest(touch.location(in: sceneView), types: ARHitTestResult.ResultType.featurePoint) //searches for real world objects
        guard let pointResult = result.last else {return} //a hit test result (where the point was clicked)
        let pointTransform = SCNMatrix4(pointResult.worldTransform) //turns the point into a point on the world grid
        let pointVector = SCNVector3Make(pointTransform.m41, pointTransform.m42, pointTransform.m43) //the X, Y, and Z of the clicked cordinate
//        let cameraTransform = sceneView.session.currentFrame?.camera.transform
//        let camerCoordinate = MDLTransform(matrix: cameraTransform!)
//        print(camerCoordinate.translation.x)
        let marker = SCNNode()
        marker.geometry = SCNBox(width: 0.05, height: 0.01, length: 0.05, chamferRadius: 0.1)
        marker.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        marker.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        _ = touches.first?.location(in:sceneView)
//        let total = Float((location?.x)!) + Float((location?.y)!)
//        let x = Float((location?.x)!)/total
//        let y = Float((location?.y)!)/total
//        print(x,y)
        marker.position = pointVector
//        marker.scale = SCNVector3(0.5, 0.5, 0.5)
        sceneView.scene.rootNode.addChildNode(marker)
        
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        sceneView.session.run(session.configuration!,
                              options: [.resetTracking,
                                        .removeExistingAnchors])
        viewWillAppear(true)
    }
}
