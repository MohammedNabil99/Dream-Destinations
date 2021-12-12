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
        
        let key = "ya29.c.b0AXv0zTOOi58frl8CJxsnt5LRoqT8z9Nizm8obC_JOzw-TBh6bRwYJS916SQJ-ITVjnPVprZzftAgHDV2DUJtCpLgyl1LMw7yPGOXvXZ3Bmgk5r2Hl8SzieaWbzNF-oLDaHIARRTjuXye5Ib5fr9MYc2p_ZhaEX-Wh0zRClMM2dpTqg702XIbf1DmIbJadnDdGOzOJc1tFXpFOtFRnySRJrtOseEIkPA"

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
                    print(dataString)
                }
            do {
                      if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                           
                           // Print out entire dictionary
                           print(convertedJsonIntoDict)
                           
                           // Get value by key
                           let userId = convertedJsonIntoDict["userId"]
                           print(userId ?? "userId could not be read")
                           
                       }
            } catch let error as NSError {
                       print(error.localizedDescription)
             }
        }
        
        
        task.resume()
        

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        annotation.coordinate = CLLocationCoordinate2D(latitude: 55.75, longitude: 37.62)
      
        mapView.addAnnotation(annotation)

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


