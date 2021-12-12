//
//  MapViewController.swift
//  DreamDestinations
//
//  Created by Andrew Tam on 12/6/21.
//
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate

{
    var landmarks = [[String:Any]]()
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://vision.googleapis.com/v1/images:annotate")
        
        let key = "ya29.c.b0AXv0zTNGgLVKKoNaTwX8uZFNzcZjx8XTnAhlsoFAP2_qyrehfTOJDvUQovtk8dxJi7DI4bdOxq-wFBav9tL4B34ajNEMmhIez_6qxIn1yIbvoJcuKIxJFMstfW27gQebBXO9DRZerMlulFNr5Kpg5uBISg6PD9C_Shf-jsQ1KRLbPtXpxrc4SsIBqojPk9PjVtGA9D8L7rgY4V1W8Gkr5UqQ3Zbr33E"

        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let image = "https://parsefiles.back4app.com/PxG3meZUr5AikZtQ88TxsQ5o0j6uSb6xSB26oCdh/0e7f4b74f7aa358dc97e40a47a44f616_image.png"
        
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
                    let latitude = myResponse.responses[0].landmarkAnnotations[0].locations[0].latLng.latitude
                    let longitude = myResponse.responses[0].landmarkAnnotations[0].locations[0].latLng.longitude
                    print(latitude)
                    print(longitude)
                    self.locationManager.delegate = self
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.startUpdatingLocation()
                    self.mapView.showsUserLocation = true
                    self.annotation.coordinate = CLLocationCoordinate2D(latitude:latitude , longitude: longitude)
                  
                    self.mapView.addAnnotation(self.annotation)
                }
        }
        task.resume()
        

       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))

        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors " + error.localizedDescription)
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


