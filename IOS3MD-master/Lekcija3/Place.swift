import Foundation
import MapKit

class Place: NSObject, MKAnnotation {
    let title: String?
    let des: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, des: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.des = des
        self.coordinate = coordinate
        
        super.init()
    }
}
