import UIKit
import AVFoundation

class CameraViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate{

//Camera Capture requiered properties
var imagePickers:UIImagePickerController?

@IBOutlet weak var customCameraView: UIView!

override func viewDidLoad() {
    addCameraInView()
    super.viewDidLoad()
}

func addCameraInView(){

    imagePickers = UIImagePickerController()
    if UIImagePickerController.isCameraDeviceAvailable( UIImagePickerController.CameraDevice.front) {
        imagePickers?.delegate = self
        imagePickers?.sourceType = UIImagePickerController.SourceType.camera
        imagePickers?.cameraDevice = .front

        //add as a childviewcontroller
        addChild(imagePickers!)

        // Add the child's View as a subview
        self.customCameraView.addSubview((imagePickers?.view)!)
        imagePickers?.view.frame = customCameraView.bounds
        imagePickers?.allowsEditing = false
        imagePickers?.showsCameraControls = false
        imagePickers?.view.autoresizingMask = [.flexibleWidth,  .flexibleHeight]
        }
    }
}

