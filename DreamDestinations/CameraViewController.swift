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
    let y: Int
    let x: Int?
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

        //let urlString = file?.url!
        
        post["image"] = file
        
        let url = URL(string: "https://vision.googleapis.com/v1/images:annotate")

        let key = "ya29.c.b0AXv0zTOIg-77gQZeGY1MF7cJ3r2pknK-dJr96AnY1iU6tlR0e4KDPlb0xQ1iqoJEk0aZzq2qZ78FFnUDmyIaFRul3AnVMUnotRlGRnd2YL54ys7I953CS6nbFXv-naHqg_hVeibY-EN806HputiWz50rF1VhmnMqv0HmyEpEW8Ohd1erns1nnIOjXnL6lK987ZuQ1yK68ZWtPqDjFQYU9u4GS8LGRZE"

    
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let image = imageData!.base64EncodedString()
        let postString = """
        {
          "requests": [
            {
              "image": {
                "content": "\(image)"
              },
              "features": [
                {
                  "maxResults": 10,
                  "type": "LANDMARK_DETECTION"
                },
              ]
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
                    let description = myResponse.responses[0].landmarkAnnotations[0].landmarkAnnotationDescription
                    let latitude = myResponse.responses[0].landmarkAnnotations[0].locations[0].latLng.latitude
                    let longitude = myResponse.responses[0].landmarkAnnotations[0].locations[0].latLng.longitude

                    // TODO: change the print statements to upload to parse database
                   // print(description)
                    //print(latitude)
                   // print(longitude)
                    
                    post.setObject(description, forKey: "Description")
                    post.setObject(latitude, forKey: "latitude")
                    post.setObject(longitude, forKey: "longitude")
                    
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
        }
        task.resume()
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
