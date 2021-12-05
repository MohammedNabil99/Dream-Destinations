//
//  CameraViewController.swift
//  DreamDestinations
//
//  Created by Mohammed Nabil on 11/17/21.
//
import UIKit
import Parse
import AlamofireImage

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = URL(string: "https://vision.googleapis.com/v1/images:annotate")
        
        let key = "ya29.c.b0AXv0zTP1wroX-f5EtG-fdw-BYWB5mTeZRtFdgrVME8ZXHJKxoDMCHS1o_c-YIgcgI2NmVqIlR0rSGh8tbJVBBkIoOF_H-Ng5eDPBVyoIcDtQsORhKmpEygPQmEk2rtzp4wz6o8OJAZFaFtLpNMrMcJmFmuCms9mnljwgQVshnGCkZS5kU80v01NB4zlTtf4Kj63YFokCveAHwkg-enVhQAnL4CQAcQs"

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
                  "imageUri": "gs://cloud-samples-data/vision/landmark/st_basils.jpeg"
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
        let scaledImage = image.af_imageScaled(to: size)
        
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
