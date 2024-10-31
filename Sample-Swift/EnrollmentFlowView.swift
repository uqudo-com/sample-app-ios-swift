//
//  EnrollmentFlow.swift
//  Sample-Swift
//
//  Created by NooN on 31/10/24.
//

import Foundation
import UIKit
import ExceptionCatcher
import JWTDecode

class EnrollmentFlowView: UIViewController, UQBuilderControllerDelegate {

    @IBOutlet weak var startButton: UIButton!
    
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

    func createScanConfig() -> UQScanConfig {
        let scanConfig = UQScanConfig()
        
        // Disable scanning help page
        scanConfig.disableHelpPage = false
        
        // Specifies the required match level for facial recognition of this document's scanned picture.
        scanConfig.faceMinimumMatchLevel = 3 // Valid number 1-5
        
        // Enable the user to review and confirmation the document for front side or back side or both.
        scanConfig.enableScanReview(true, backSide: true)
        
        return scanConfig
    }
    
    func createReadingConfig() -> UQReadingConfig {
        let readingConfig = UQReadingConfig()
        
        // Enable reading for the document, e.g., NFC reading of the chip
        readingConfig.enableReading = false
        
        // Specifies the required match level for facial recognition of the picture in the chip for this specific document
        readingConfig.faceMinimumMatchLevel = 3 // Valid number 1-5
        
        // Force the reading part. Users will not be able to skip the reading part. Enrollment builder throws an exception if NFC is not supported and force reading is enabled.
        readingConfig.forceReading(false)
        
        return readingConfig
    }

    func createDocument() -> UQDocumentConfig {
        // Create document type Passport
        let docConfig = UQDocumentConfig(documentType: UAE_ID.rawValue)
        
        // Enabling this option allows scanning expired documents
        docConfig.disableExpiryValidation = true
        
        // Enabling this option allows age verification, and if the calculated age from the document is below the defined age, the scan fails and shows a message to the user. Age must be higher than 0 to be considered.
        docConfig.enableAgeVerification = 15
        
        // Add scan configuration
        docConfig.scan = createScanConfig()
        
        // Add reading configuration
        docConfig.reading = createReadingConfig()
        
        return docConfig
    }

    func createFacialRecognitionConfig(enableFacialRecognition: Bool) -> UQFacialRecognitionConfig {
        let config = UQFacialRecognitionConfig()
        
        // Enable facial recognition
        config.enableFacialRecognition = enableFacialRecognition
        
        // Enabling this option allows to have closed eyes during facial recognition.
        config.allowClosedEyes = true
        
        // Enabling this option allows you to enroll your face for account recovery. For more information, refer to the Account Recovery Flow.
        config.enrollFace = true
        
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

    func createEnrollmentBuilder(authorizationToken: String) -> UQEnrollmentBuilder {
        
        // Config the enrollment builder
        let enrollmentBuilder = UQEnrollmentBuilder()
        
        // Retrieve the authorization token using oauth2 client credentials grant type. You can obtain your client credentials by navigating to the "Credentials" tab located in the "Development" section of our Uqudo Customer Portal Note: Don’t perform this operation inside your mobile application but only from your backend
        // For more information please check https://docs.uqudo.com/docs/uqudo-api/authorisation
        
        enrollmentBuilder.authorizationToken = authorizationToken
        
        // Nonce is provided by the customer's mobile application when the SDK is initiated. Ensuring the customer's mobile application has undertaken the process is helpful. It should be generated on the server side.
        enrollmentBuilder.nonce = self.nonce ?? ""
        
        // Required during the enrolment process using a QR code, see QR code App. Note: make sure to create always a new session id when you trigger the SDK flow
        // The SDK will generate sessionID if the sessionID is empty
        enrollmentBuilder.sessionID = self.createSessionID()
        
        // Required during the enrolment process using a QR code
        // UUID v4 that represents the user identifier for recurrent usage of the SDK for the same user. This is related to the type of license agreement with Uqudo. Please note that if the UUID v4 is malformed it is simply ignored
        enrollmentBuilder.userIdentifier = UUID()
        
        
        // Enabling this option allows the SDK provide partial data along with the SessionStatus object if the user or SDK terminates the session prematurely. However, it's essential to remember that you can only expect some data if the user has completed at least the scanning step.
        enrollmentBuilder.returnDataForIncompleteSession = true
        
        
        // Add document if no document, the UQExceptionMissingDocument throw
        let uaeid = self.createDocument()
        // If reading enable but document is not supported reading the SDK will throw kExceptionReasonDocumentNotSupportReading.
        // If document is not supported enrollment the SDK will throw kExceptionReasonDocumentEnrollmentNotSupport.
        enrollmentBuilder.add(uaeid)
        
        // Enabling face recognition
//        if docConfig.isSupportFaceRecognition() {
//            enrollmentBuilder.facialRecognitionConfig = self.createFacialRecognitionConfig(enableFacialRecognition: true)
//        }

        // Background Check Configuration id needed
        // Begin enableBackgroundCheck config.
        /*// Uncomment if needed
         // Disable consent option for the user
         // Sets the background check type RDC or DOW_JONES
         // Enable continuous monitoring.
         // If enabled, the step will be skipped, and the SDK will trigger the background check without any user interaction.
         enrollmentBuilder.enableBackgroundCheck(true, type: BackgroundCheckType(rawValue: RDC.rawValue), monitoring: true, skipView: true)
        */// Uncomment if needed
        // End enableBackgroundCheck config.
        
        // This feature requires an additional permission and must be explicitly requested
        
        // Enable third party lookup (Government database). See the supported documents and the data returned in Lookup Object
        // Begin enableLookup config.
        // enrollmentBuilder.enableLookup()// Uncomment if needed
        // End enableLookup config.
        
        // Enable third party lookup (Government database) filtered by document type. For instance, if your KYC process includes more than one document, you can decide to perform the lookup only for one single document.
        // Begin enableLookup filtered by document type config.
        // enrollmentBuilder.enableLookup([list of lookup document]) // Uncomment if needed
        // End enableLookup filtered by document type config.
        
        // Enabling this option allows to exceped screens and printed copies. is disable by default
        enrollmentBuilder.allowNonPhysicalDocuments = true;
        
        return enrollmentBuilder
    }
    
    func performingEnrollment() {
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
                
                // Config the enrollment builder
                let enrollmentBuilder = self.createEnrollmentBuilder(authorizationToken: appDelegate.accessToken!)
                
                // Add enrollment to the main builder
                builderController.setEnrollment(enrollmentBuilder)
                
                // Start enrollment flow
                // AccessToken is required; if no token, UQExceptionInvalidToken will be thrown
                builderController.performEnrollment()
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
    
    @IBAction func startOnBording(_ sender: UIButton) {
        self.performingEnrollment()
    }
}


extension EnrollmentFlowView {
    
    func didEnrollmentComplete(withInfo info: String) {
        print("didEnrollmentComplete")
        do {
            let decodedResult = try decode(jwt: info)
            // Use decodedResult
            print("encoded result: \(info)")
            print("decoded result: \(decodedResult)")
            performSegue(withIdentifier: "enrollmentComplete", sender: self)
        } catch {
            print("Error decoding JWT: \(error)")
        }
    }

    func didEnrollmentIncomplete(with status: UQSessionStatus) {
        print("didEnrollmentIncomplete")
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

    func didEnrollmentFailWithError(_ error: Error) {
        print(error)
    }
    
    
    func showExceptionError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
