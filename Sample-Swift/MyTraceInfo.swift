//
//  MyTraceInfo.swift
//  Sample-Swift
//
//  Created by NooN on 28/6/24.
//

import Foundation
import UqudoSDK

extension UQTrace {
    
    private func traceString<T: Equatable>(value: T, mapping: [T: String], defaultString: String = "(null)") -> String {
        return mapping[value] ?? defaultString
    }

    func traceStatus() -> String {
        traceString(
            value: self.status,
            mapping: [TS_SUCCESS: "SUCCESS"],
            defaultString: "FAILURE"
        )
    }
    
    func traceCategory() -> String {
        traceString(
            value: self.category,
            mapping: [
                TC_ENROLLMENT: "ENROLLMENT",
                TC_ACCOUNT_RECOVERY: "ACCOUNT_RECOVERY",
                TC_FACE_SESSION: "FACE_SESSION",
                TC_LOOKUP: "LOOKUP"
            ],
            defaultString: "SDK"
        )
    }
    
    func traceEvent() -> String {
        traceString(
            value: self.event,
            mapping: [
                TE_FINISH: "FINISH",
                TE_VIEW: "VIEW",
                TE_START: "START",
                TE_COMPLETE: "COMPLETE",
                TE_SKIP: "SKIP",
                TE_IN_PROGRESS: "IN_PROGRESS"
            ],
            defaultString: "INIT"
        )
    }
    
    func tracePage() -> String {
        traceString(
            value: self.page,
            mapping: [
                TP_SCAN: "SCAN",
                TP_READ: "READ",
                TP_FACE: "FACE",
                TP_BACKGROUND_CHECK: "BACKGROUND_CHECK",
                TP_LOOKUP: "LOOKUP",
                TP_LOOKUP_OTP: "LOOKUP_OTP"
            ]
        )
    }
    
    func traceStatusCode() -> String {
        traceString(
            value: self.statusCode,
            mapping: [
                TSC_USER_CANCEL: "USER_CANCEL",
                TSC_SESSION_EXPIRED: "SESSION_EXPIRED",
                TSC_UNEXPECTED_ERROR: "UNEXPECTED_ERROR",
                TSC_SESSION_INVALIDATED: "SESSION_INVALIDATED",
                TSC_SCAN_DOCUMENT_FRONT_BACK_MISMATCH: "SCAN_DOCUMENT_FRONT_BACK_MISMATCH",
                TSC_SCAN_DOCUMENT_NOT_RECOGNIZED: "SCAN_DOCUMENT_NOT_RECOGNIZED",
                TSC_SCAN_DOCUMENT_EXPIRED: "SCAN_DOCUMENT_EXPIRED",
                TSC_SCAN_DOCUMENT_AGE_VERIFICATION_FAILED: "SCAN_DOCUMENT_AGE_VERIFICATION_FAILED",
                TSC_READ_NFC_UNAVAILABLE: "READ_NFC_UNAVAILABLE",
                TSC_READ_NFC_DOCUMENT_NOT_SUPPORTED: "READ_NFC_DOCUMENT_NOT_SUPPORTED",
                TSC_READ_DOCUMENT_DISCONNECTED: "READ_DOCUMENT_DISCONNECTED",
                TSC_READ_DOCUMENT_INVALID_SIGNATURE: "READ_DOCUMENT_INVALID_SIGNATURE",
                TSC_READ_AUTHENTICATION_FAILED: "READ_AUTHENTICATION_FAILED",
                TSC_READ_DOCUMENT_VALIDATION_FAILED: "READ_DOCUMENT_VALIDATION_FAILED",
                TSC_READ_CHIP_VALIDATION_FAILED: "READ_CHIP_VALIDATION_FAILED",
                TSC_FACE_LIVENESS_FAILED: "FACE_LIVENESS_FAILED",
                TSC_FACE_NO_MATCH: "FACE_NO_MATCH",
                TSC_FACE_TIMEOUT: "FACE_TIMEOUT",
                TSC_FACE_RECOGNITION_TOO_MANY_ATTEMPTS: "FACE_RECOGNITION_TOO_MANY_ATTEMPTS",
                TSC_LOOKUP_INVALID_INPUT: "LOOKUP_INVALID_INPUT",
                TSC_LOOKUP_ID_NOT_FOUND: "LOOKUP_ID_NOT_FOUND",
                TSC_LOOKUP_OTP_TOO_MANY_ATTEMPTS: "LOOKUP_OTP_TOO_MANY_ATTEMPTS",
                TSC_CAMERA_NOT_AVAILABLE: "CAMERA_NOT_AVAILABLE",
                TSC_CAMERA_PERMISSION_NOT_GRANTED: "CAMERA_PERMISSION_NOT_GRANTED",
                TSC_SCAN_DOCUMENT_FRONT_PROCESSED: "SCAN_DOCUMENT_FRONT_PROCESSED",
                TSC_SCAN_DOCUMENT_BACK_PROCESSED: "SCAN_DOCUMENT_BACK_PROCESSED",
                TSC_SCAN_DOCUMENT_DARK_ENVIRONMENT_DETECTED: "SCAN_DOCUMENT_DARK_ENVIRONMENT_DETECTED",
                TSC_SCAN_DOCUMENT_INCORRECT_DISTANCE_DETECTED: "SCAN_DOCUMENT_INCORRECT_DISTANCE_DETECTED",
                TSC_SCAN_DOCUMENT_BLUR_DETECTED: "SCAN_DOCUMENT_BLUR_DETECTED",
                TSC_SCAN_DOCUMENT_INCORRECT_TYPE_DETECTED: "SCAN_DOCUMENT_INCORRECT_TYPE_DETECTED",
                TSC_SCAN_DOCUMENT_INCORRECT_SIDE_DETECTED: "SCAN_DOCUMENT_INCORRECT_SIDE_DETECTED",
                TSC_SCAN_DOCUMENT_GLARE_DETECTED: "SCAN_DOCUMENT_GLARE_DETECTED",
                TSC_SCAN_DOCUMENT_ID_PHOTO_BAD_QUALITY_DETECTED: "SCAN_DOCUMENT_ID_PHOTO_BAD_QUALITY_DETECTED",
                TSC_SCAN_DOCUMENT_SCREEN_DETECTED: "SCAN_DOCUMENT_SCREEN_DETECTED",
                TSC_SCAN_DOCUMENT_PRINT_DETECTED: "SCAN_DOCUMENT_PRINT_DETECTED",
                TSC_SCAN_DOCUMENT_ID_PHOTO_TAMPERING_DETECTED: "SCAN_DOCUMENT_ID_PHOTO_TAMPERING_DETECTED",
                TSC_FACE_INCORRECT_POSITION_DETECTED: "FACE_INCORRECT_POSITION_DETECTED",
                TSC_FACE_DARK_ENVIRONMENT_DETECTED: "FACE_DARK_ENVIRONMENT_DETECTED",
                TSC_FACE_BLUR_DETECTED: "FACE_BLUR_DETECTED",
                TSC_FACE_MOUTH_COVER_DETECTED: "FACE_MOUTH_COVER_DETECTED",
                TSC_FACE_EYES_COVER_DETECTED: "FACE_EYES_COVER_DETECTED",
                TSC_FACE_EYES_CLOSED_DETECTED: "FACE_EYES_CLOSED_DETECTED",
                TSC_FACE_SPOTLIGHT_DETECTED: "FACE_SPOTLIGHT_DETECTED",
                TSC_FACE_SHADOW_DETECTED: "FACE_SHADOW_DETECTED",
                TSC_FACE_EYES_SHADOW_DETECTED: "FACE_EYES_SHADOW_DETECTED",
                TSC_FACE_INCORRECT_DISTANCE_DETECTED: "FACE_INCORRECT_DISTANCE_DETECTED",
                TSC_FACE_LIVENESS_MOVE_CLOSER: "FACE_LIVENESS_MOVE_CLOSER",
                TSC_FACE_LIVENESS_MOVE_FURTHER: "FACE_LIVENESS_MOVE_FURTHER",
                TSC_FACE_LIVENESS_TILT_RIGHT: "FACE_LIVENESS_TILT_RIGHT",
                TSC_FACE_LIVENESS_TILT_LEFT: "FACE_LIVENESS_TILT_LEFT"
            ]
        )
    }
    
    func traceStatusMessage() -> String {
        if let string = self.statusMessage as String?, !string.isEmpty {
            return string
        } else {
            return ""
        }
    }
    
    func traceSessionId() -> String {
        if let string = self.sessionId as String?, !string.isEmpty {
            return string
        } else {
            return ""
        }
    }
    
    func traceDocumentName() -> String {
        if self.documentType.rawValue != UNSPECIFY.rawValue {
            let document = UQDocumentConfig(documentType: self.documentType.rawValue)
            return document.documentName()
        }
        return ""
    }
    
    func traceTimeStamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        return dateFormatter.string(from: self.timestamp)
    }


    func traceInfo() -> [String: String] {
        return [
            "status": traceStatus(),
            "category": traceCategory(),
            "event": traceEvent(),
            "page": tracePage(),
            "statusCode": traceStatusCode(),
            "statusMessage": traceStatusMessage(),
            "sessionId": traceSessionId(),
            "documentName": traceDocumentName(),
            "timestamp": traceTimeStamp()
        ]
    }
}
