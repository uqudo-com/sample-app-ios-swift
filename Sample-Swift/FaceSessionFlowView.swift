//
//  FaceSessionFlowView.swift
//  Sample-Swift
//
//  Created by NooN on 31/10/24.
//

import Foundation
import UIKit
import ExceptionCatcher
import JWTDecode

class FaceSessionFlowView: UIViewController, UQBuilderControllerDelegate {
    
    
    @IBOutlet var startButton: UIButton!
    
    var accessToken : String?
    var nonce : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startButton.layer.cornerRadius = 8
    }

    func createSessionID() -> String {
        let uuid = UUID()
        let uuidString = uuid.uuidString.lowercased()
        return uuidString
    }

    func createFacialRecognitionConfig(enableFacialRecognition: Bool) -> UQFacialRecognitionConfig {
        let config = UQFacialRecognitionConfig()
        
        // Enable facial recognition
        config.enableFacialRecognition = enableFacialRecognition
        
        // Enabling this option allows to have closed eyes during facial recognition.
        config.allowClosedEyes = true
        
        // Defines the minimum match level that the facial recognition has to meet for scanned pictures
        config.scanMinimumMatchLevel = 3
        
        // Defines the minimum match level that the facial recognition has to meet for pictures from the chip (e.g. NFC)
        config.readMinimumMatchLevel = 3
        
        config.obfuscationType = FILLED
        // Enabling this option allows for the obfuscation of the background in audit trail images, leaving only the face visible. It is beneficial when privacy concerns arise due to the background of the selfie shared in the SDK result. This feature offers two types of obfuscation:
        // 1. FILLED: This option entirely replaces the experience.
        // 2. BLURRED: This option heavily blurs the background, ensuring that objects in the scene are not recognizable. However, it still provides a perception of the environment surrounding the user, allowing for validation of the reality of the image. If privacy is a concern, we recommend using this option.
        
        // Specify the maximum number of failed facial recognition attempts allowed before ending the session. Note that only values between 1 and 3 will be considered.
        config.maxAttempts = 1
        
        return config
    }
    

    func createFaceSessionBuilderBuilder(authorizationToken: String) -> UQFaceSessionBuilder {
        
        // Config the face session builder
        let faceSessionBuilder = UQFaceSessionBuilder()
        
        // Retrieve the authorization token using oauth2 client credentials grant type. You can obtain your client credentials by navigating to the "Credentials" tab located in the "Development" section of our Uqudo Customer Portal Note: Don’t perform this operation inside your mobile application but only from your backend
        // For more information please check https://docs.uqudo.com/docs/uqudo-api/authorisation
        
        faceSessionBuilder.authorizationToken = authorizationToken
        
        // Nonce is provided by the customer's mobile application when the SDK is initiated. Ensuring the customer's mobile application has undertaken the process is helpful. It should be generated on the server side.
        faceSessionBuilder.nonce = self.nonce ?? ""
        
        // The session id returned by the “Face Session API”, see API documentation
        faceSessionBuilder.sessionId = "sessionId"
        
        // Enabling this option allows the SDK provide partial data along with the SessionStatus object if the user or SDK terminates the session prematurely. However, it's essential to remember that you can only expect some data if the user has completed at least the scanning step.
        faceSessionBuilder.returnDataForIncompleteSession = true
        
        let facialRecognitionConfig =  self.createFacialRecognitionConfig(enableFacialRecognition: true)
        
        faceSessionBuilder.minimumMatchLevel = facialRecognitionConfig.minimumMatchLevel;
        faceSessionBuilder.maxAttempts = facialRecognitionConfig.maxAttempts;
        faceSessionBuilder.allowClosedEyes = facialRecognitionConfig.allowClosedEyes;
        if (facialRecognitionConfig.obfuscationType.rawValue >= FILLED.rawValue && facialRecognitionConfig.obfuscationType.rawValue <= BLURRED.rawValue) {
            faceSessionBuilder.enableAuditTrailImageObfuscation(facialRecognitionConfig.obfuscationType)
        }

        return faceSessionBuilder
    }
    
    func performingFaceSession() {
        do {
            _ = try ExceptionCatcher.catch {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    // Handle the case where the app delegate is not found
                    return
                }
                
                let builderController = UQBuilderController.defaultBuilder()
                
                // Config the main builder. UQBuilderController is a singleton since we already initiated the build in AppDelegate; next time we will call defaultBuilder
                builderController.delegate = self
                
                // Pass an instance of the app view controller
                builderController.appViewController = self
                
                // Define appearance mode. Available options are LIGHT, DARK, and SYSTEM.
                builderController.setAppearanceMode(LIGHT)
                
                // Config the face session builder
                let faceSessionBuilder = self.createFaceSessionBuilderBuilder(authorizationToken: appDelegate.accessToken!)
                
                // Add enrollment to the main builder
                builderController.setFaceSession(faceSessionBuilder)
                
                // Start face session flow
                builderController.performFaceSession()
            }
        } catch let error as NSError {
            // Manage exception here
            // Error Domain represent the exeption name: [IllegalStateException, UnsupportedDeviceException, UnsupportedOperationException]
            // Error Description represent exception reason
            print("Error:", error.localizedDescription)
            debugPrint(error)
            self.showExceptionError(title: error.domain, message: error.localizedDescription)
        }
    }
    
    @IBAction func starttFaceSession(_ sender: UIButton) {
        self.performingFaceSession()
    }
}


extension FaceSessionFlowView {
    func didFaceSessionComplete(withInfo info: String) {
        print("didFaceSessionComplete")
        do {
            let decodedResult = try decode(jwt: info)
            // Use decodedResult
            print("encoded result: \(info)")
            print("decoded result: \(decodedResult)")
            performSegue(withIdentifier: "faceSessionComplete", sender: self)
        } catch {
            print("Error decoding JWT: \(error)")
        }
    }

    func didFaceSessionIncomplete(with status: UQSessionStatus) {
        print("didFaceSessionIncomplete")
        print("status code: \(status.statusCode)")
        print("status task: \(status.statusTask)")
        print("status message: \(status.message ?? "")")
        if let info = status.data {
            do {
                let decodedResult = try decode(jwt: info)
                // Use decodedResult
                print("encoded result: \(info)")
                print("decoded result: \(decodedResult)")
            } catch {
                print("Error decoding JWT: \(error)")
            }
        } else {
            print("Data is nil")
        }
    }

    func didFaceSessionFail(_ error: Error) {
        print(error)
    }
    
    func showExceptionError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
