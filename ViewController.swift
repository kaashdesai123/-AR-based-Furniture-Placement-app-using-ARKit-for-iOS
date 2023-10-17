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
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            
            // Get 3D coordinates of the touched location
            let hitResult = sceneView.hitTest(location, types: .featurePoint)
            if let hitRes = hitResult.first {
                placeFurniture(hitRes)
            }
        }
    }
    
    func placeFurniture(_ hitResult: ARHitTestResult) {
        // Here we're assuming you've a chair.usdz model in your project
        guard let chair = SCNScene(named: "chair.usdz") else { return }
        
        let node = SCNNode(geometry: chair.rootNode.geometry!)
        
        node.position = SCNVector3(hitResult.worldTransform.columns.3.x, 
                                   hitResult.worldTransform.columns.3.y, 
                                   hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(node)
    }
}
