//
//  AdjustViewController.swift
//  final
//
//  Created by Emil Jiang on 3/8/23.
//

import UIKit
import AVKit
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension UIView {

func zoomIn(duration: TimeInterval = 0.2) {
    self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
        self.transform = .identity
        }) { (animationCompleted: Bool) -> Void in
    }
}

func zoomOut(duration : TimeInterval = 0.2) {
    self.transform = .identity
    UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
    }
}


func zoomInWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
    let easeScale = 1.0 + easingOffset
    let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
    let scalingDuration = duration - easingDuration
    UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
        self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = .identity
                }, completion: { (completed: Bool) -> Void in
            })
    })
}

func zoomOutWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
    let easeScale = 1.0 + easingOffset
    let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
    let scalingDuration = duration - easingDuration
    UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
        self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                }, completion: { (completed: Bool) -> Void in
            })
    })
}

}

class AdjustViewController: UIViewController, UITextFieldDelegate, URLSessionWebSocketDelegate{
    @IBOutlet weak var Text: UITextField!
    @IBOutlet weak var Text1: UITextField!
    @IBOutlet weak var Text2: UITextField!
    @IBOutlet weak var Text3: UITextField!
    @IBOutlet weak var save: UIButton!
    private let defaults = UserDefaults.standard
    let synthesizer = AVSpeechSynthesizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.load()
        
        save.backgroundColor = .clear
        save.layer.cornerRadius = 10
        save.layer.borderWidth = 1
        save.layer.borderColor = UIColor.blue.cgColor
        Text.borderStyle = UITextField.BorderStyle.roundedRect
        Text1.borderStyle = UITextField.BorderStyle.roundedRect
        Text2.borderStyle = UITextField.BorderStyle.roundedRect
        Text3.borderStyle = UITextField.BorderStyle.roundedRect
        
//        let url = URL(string: "http://192.168.1.176:8080")!
//        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
//
//        components.queryItems = [
//            URLQueryItem(name: "key1", value: "NeedToEscape=And&"),
//            URLQueryItem(name: "key2", value: "vålüé")
//        ]
//
//        let query = components.url!.query
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.httpBody = Data(query!.utf8)
//        URLSession.shared.dataTask(with: request) { data, HTTPURLResponse, Error in if (data != nil && data?.count != 0) { let response = String(data: data!, encoding: .utf8); print(response!) } }.resume()

        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func load() {
        let savedText = defaults.string(forKey: "text")
        let savedText1 = defaults.string(forKey: "text1")
        let savedText2 = defaults.string(forKey: "text2")
        let savedText3 = defaults.string(forKey: "text3")
        Text.text = savedText ?? ""
        Text1.text = savedText1 ?? ""
        Text2.text = savedText2 ?? ""
        Text3.text = savedText3 ?? ""
    }
    @IBAction func speak(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: "hi")
        utterance.rate = 0.52
        utterance.voice = AVSpeechSynthesisVoice(language: "en.US")
        self.synthesizer.speak(utterance)
        
    }
    @IBAction func speak1(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: Text1.text ?? "")
        utterance.rate = 0.52
        utterance.voice = AVSpeechSynthesisVoice(language: "en.US")
        synthesizer.speak(utterance)
    }
    @IBAction func speak2(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: Text2.text ?? "")
        utterance.rate = 0.52
        utterance.voice = AVSpeechSynthesisVoice(language: "en.US")
        synthesizer.speak(utterance)
    }
    @IBAction func speak3(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: Text3.text ?? "")
        utterance.rate = 0.52
        utterance.voice = AVSpeechSynthesisVoice(language: "en.US")
        synthesizer.speak(utterance)
    }

    @IBAction func saveText(_ sender: Any) {
        save.zoomInWithEasing()
        defaults.set(Text.text, forKey: "text")
        defaults.set(Text1.text, forKey: "text1")
        defaults.set(Text2.text, forKey: "text2")
        defaults.set(Text3.text, forKey: "text3")

        let baseUrl = "http://172.20.10.4:8080/"
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "Text1", value: Text.text ?? ""),
            URLQueryItem(name: "Text2", value: Text1.text ?? ""),
            URLQueryItem(name: "Text3", value: Text2.text ?? ""),
            URLQueryItem(name: "Text4", value: Text3.text ?? "")
        ]
        if let url = urlComponents?.url {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                // handle response here
            }
            task.resume()
        } else {
            print("Error: Invalid URL")
        }
    }
}

