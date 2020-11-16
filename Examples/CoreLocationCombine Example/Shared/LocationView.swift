
import CoreLocation
import SwiftUI

struct LocationView: View {
    let location: CLLocation
    var body: some View {
        VStack {
            Text(location.description)
        }
    }
}
