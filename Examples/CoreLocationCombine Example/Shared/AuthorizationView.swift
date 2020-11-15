
import CoreLocation
import CoreLocationCombine
import SwiftUI

struct AuthorizationView: View {
    let authorization: Authorization
    var body: some View {
        VStack {
            Text(authorization.status.string)
            Text(authorization.accuracy.string)
        }
    }
}

extension CLAccuracyAuthorization {

    fileprivate var string: String {
        switch self {
        case .fullAccuracy: return "fullAccuracy"
        case .reducedAccuracy: return "reducedAccuracy"
        @unknown default: return "unknown"
        }
    }
}

extension CLAuthorizationStatus {

    fileprivate var string: String {
        switch self {
        case .authorizedAlways: return "authorizedAlways"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .denied: return "denied"
        case .notDetermined: return "notDetermined"
        case .restricted: return "restricted"
        @unknown default: return "unknown"
        }
    }
}
