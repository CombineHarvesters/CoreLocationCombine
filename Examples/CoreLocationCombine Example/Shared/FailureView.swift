
import SwiftUI

struct FailureView: View {
    let error: Error
    var body: some View {
        Text(error.localizedDescription)
    }
}
