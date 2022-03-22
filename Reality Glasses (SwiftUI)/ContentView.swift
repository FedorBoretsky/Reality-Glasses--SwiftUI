//
//  ContentView.swift
//  Reality Glasses (SwiftUI)
//
//  Created by Fedor Boretskiy on 21.03.2022.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    // MARK: - Primitives
    
    func makeLense(x: Float = 0, y: Float = 0, z: Float = 0) -> Entity {
        // Create rounded box.
        let mesh = MeshResource.generateBox(size: 0.05, cornerRadius: 0.025)
        
        // Create material.
        let material = SimpleMaterial(color: .blue, isMetallic: true)
        
        // Create entity.
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.position = SIMD3(x, y, z)
        
        // Flatten entity.
        entity.scale.x = 1.1
        entity.scale.z = 0.01
        
        // Output result.
        return entity
    }
    
    func makeSphere(x: Float = 0,
                    y: Float = 0,
                    z: Float = 0,
                    radius: Float = 0.05,
                    color: UIColor = .red) -> Entity
    {
        // Create sphere mesh.
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, isMetallic: true)
        
        // Create sphere entity.
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.position = SIMD3(x, y, z)
        
        // Output result.
        return entity
    }
    
    // MARK: - makeUIView
    
    func makeUIView(context: Context) -> ARView {
        // Create AR representation.
        let arView = ARView(frame: .zero)
        
        // Check if face tracking is possible.
        guard ARFaceTrackingConfiguration.isSupported
        else {
            print ("Face tracking is not supported by this device.")
            return arView
        }
        
        // Set up face tracking configuration.
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // Face AR.
        let faceAnchor = AnchorEntity(.face)
        faceAnchor.addChild(makeLense(x: 0.035, y: 0.025, z: 0.06))
        faceAnchor.addChild(makeLense(x: -0.035, y: 0.025, z: 0.06))
        faceAnchor.addChild(makeSphere(z: 0.06, radius: 0.025))
        arView.scene.anchors.append(faceAnchor)
        
        // Run face tracking session.
        arView.session.run(configuration)
        
        return arView
    }
    
    // MARK: - updateUIView

    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

// MARK: - Preview

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
