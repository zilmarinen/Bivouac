//
//  Scene.swift
//
//  Created by Zack Brown on 06/09/2023.
//

import GameController
import SceneKit

open class Scene: SCNScene,
                  Updatable {
    
    public let camera = Camera()
    
    internal let surface = Surface()
    
    internal lazy var inputManager = InputManager(delegate: self)
    
    internal var lastUpdate: TimeInterval?
    
    required override public init() {
        
        super.init()
        
        rootNode.addChildNode(camera)
        rootNode.addChildNode(surface)
    }
    
    public required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    open func update(delta: TimeInterval,
                     time: TimeInterval) {
        
        inputManager.update(delta: delta,
                            time: time)
    }
    
    open func clear() {
        
        rootNode.removeAllChildren()
        rootNode.addChildNode(camera)
        rootNode.addChildNode(surface)
    }
}

extension Scene: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer,
                         updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
                
        update(delta: delta,
               time: time)
                
        lastUpdate = time
    }
}

extension Scene: InputManagerDelegate {
 
    func inputManager(inputManager: InputManager,
                      didConnectController: GCController) {
        
        print("inputManager:didConnectController")
    }
    
    func inputManager(inputManager: InputManager,
                      didDisconnectController: GCController) {
        
        self.isPaused = true
    }
    
    func inputManager(inputManager: InputManager,
                      didConnectKeyboard: GCKeyboard) {
        
        print("inputManager:didConnectKeyboard")
    }
    
    func inputManager(inputManager: InputManager,
                      didDisconnectKeyboard: GCKeyboard) {
        
        self.isPaused = true
    }
    
    func inputManager(inputManager: InputManager,
                      didConnectMouse: GCMouse) {
        
        print("inputManager:didConnectMouse")
    }
    
    func inputManager(inputManager: InputManager,
                      didDisconnectMouse: GCMouse) {
        
        self.isPaused = true
    }
}

