
import CoreLocation
import CoreLocationCombine
import PublisherView
import SwiftUI

struct ContentView: View {

    let authorization = CLLocationManager().requestAuthorization(.whenInUse)

    var body: some View {
        PublisherView(publisher: authorization,
                      initial: ProgressView.init,
                      output: AuthorizationView.init)
    }
}
