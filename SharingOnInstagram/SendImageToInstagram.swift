//
//  SharingOnInstagram.swift
//  DocumentInteraction
//
//  Created by JPMartha on 2015/12/26.
//  Copyright © 2015年 JPMartha. All rights reserved.
//

import UIKit

public enum InstagramFileType {
    case IGPhoto
    case IGOExclusivegram
}

public class SharingOnInstagram: NSObject, UIDocumentInteractionControllerDelegate {
    
    lazy var documentInteractionController = UIDocumentInteractionController()
    
    var imagePath: String?
    
    var hasInstagram: Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(string: "instagram://")!)
    }
    
    var filenameExtension: String!
    var UTI: String!
    
    required public init?(instagramFileType: InstagramFileType) {
        switch instagramFileType {
        case .IGPhoto:
            self.filenameExtension = "ig"
            self.UTI = "com.instagram.photo"
        case .IGOExclusivegram:
            self.filenameExtension = ".igo"
            self.UTI = "com.instagram.exclusivegram"
        }
    }
    
    /**
     Send image to Instagram App.
     - Parameter image: The image for sending to Instagram App.
     - Parameter view: The view from which to display the options menu.
    */
    public func sendImageToInstagram(image: UIImage, view: UIView) {
        
        guard self.hasInstagram else {
            return
        }
        
        documentInteractionController.URL = saveImage(image)
        documentInteractionController.UTI = UTI

        documentInteractionController.presentOptionsMenuFromRect(
            view.bounds,
            inView: view,
            animated: true
        )
    }
    
    private func saveImage(image: UIImage) -> NSURL {
        
        let documentDirectory = (NSHomeDirectory() as NSString).stringByAppendingPathComponent("tmp")
        imagePath = (documentDirectory as NSString).stringByAppendingPathComponent("InstagramPhoto\(filenameExtension)")
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        imageData?.writeToFile(imagePath!, atomically: true)
        
        return NSURL.fileURLWithPath(imagePath!)
    }
    
    private func removeTemporaryImage() {
        do {
            try NSFileManager().removeItemAtPath(imagePath!)
        } catch {
            print("Error: removeTemporaryImage")
        }
    }
    
    // MARK: - UIDocumentInteractionControllerDelegate
    
    public func documentInteractionController(controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        
        removeTemporaryImage()
    }
}