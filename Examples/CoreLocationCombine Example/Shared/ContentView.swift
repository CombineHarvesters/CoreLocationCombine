
import CoreLocation
import CoreLocationCombine
import PublisherView
import SwiftUI

struct ContentView: View {

    let location = CLLocationManager()
        .requestAuthorization(.whenInUse)
        .filter { $0.status == .authorizedWhenInUse || $0.status == .authorizedWhenInUse }
        .flatMap { _ in CLLocationManager().locationPublisher }

    var body: some View {
        PublisherView(publisher: location,
                      initial: ProgressView.init,
                      output: LocationView.init,
                      failure: FailureView.init)
    }
}
