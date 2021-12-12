//
//  CameraViewController.swift
//  DreamDestinations
//
//  Created by Mohammed Nabil on 11/17/21.
//
import UIKit
import Parse
import AlamofireImage
import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
// https://app.quicktype.io/?share=l0KzbhyyDujEeaS98TPx
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - Welcome
struct Welcome: Codable {
    let responses: [Response]
}

// MARK: - Response
struct Response: Codable {
    let landmarkAnnotations: [LandmarkAnnotation]
}

// MARK: - LandmarkAnnotation
struct LandmarkAnnotation: Codable {
    let mid, landmarkAnnotationDescription: String
    let score: Double
    let boundingPoly: BoundingPoly
    let locations: [Location]

    enum CodingKeys: String, CodingKey {
        case mid
        case landmarkAnnotationDescription = "description"
        case score, boundingPoly, locations
    }
}

// MARK: - BoundingPoly
struct BoundingPoly: Codable {
    let vertices: [Vertex]
}

// MARK: - Vertex
struct Vertex: Codable {
    let x, y: Int
}

// MARK: - Location
struct Location: Codable {
    let latLng: LatLng
}

// MARK: - LatLng
struct LatLng: Codable {
    let latitude, longitude: Double
}

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: "https://vision.googleapis.com/v1/images:annotate")
        

        let key = "ya29.c.b0AXv0zTN7YEwUZeO232ht9ataVOOTKzEw1jLXKz5AwcbREV1FX98KBdYCXOU4_csRausazpkKs6S4GxjySuDMv_8PqUav3_sKRwjngQr8B1qiVCV_WqPlROKrDNcTP-HE9Yr7ziVHVebBivTtUP6KrGUiS7mlXptZKHsyeBb-Lp6MvANhjXGWNLNKESSMAsYgfmil2VEXKGGkhvN-mLethxPNBbWAW5A"

      

        let image = "gs://cloud-samples-data/vision/landmark/st_basils.jpeg"
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let postString = """
        {
          "requests": [
            {
              "features": [
                {
                  "maxResults": 10,
                  "type": "LANDMARK_DETECTION"
                }
              ],
              "image": {
                "source": {
                  "imageUri": "\(image)"
                }
              }
            }
          ]
        }
        """
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
//      function that does the actual API call
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                    
                    let jsonData = dataString.data(using: .utf8)!
                    let myResponse = try! JSONDecoder().decode(Welcome.self, from: jsonData)
                    print(myResponse.responses[0].landmarkAnnotations[0].landmarkAnnotationDescription)
                    print(myResponse.responses[0].landmarkAnnotations[0].locations[0].latLng.latitude)
                    print(myResponse.responses[0].landmarkAnnotations[0].locations[0].latLng.longitude)

                }
        }
        task.resume()
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
            
        }else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
        
    }
  
    @IBAction func onSaveImageButton(_ sender: Any) {
        let post = PFObject(className: "Posts")
        
       // post["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        post["image"] = file
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            }
            else{
                print("error!")
            }
           
    }

}
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
