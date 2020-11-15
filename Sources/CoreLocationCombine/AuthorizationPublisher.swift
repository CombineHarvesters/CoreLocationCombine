
import CoreLocation
import Combine

extension CLLocationManager {

    public func requestAuthorization(
        _ request: AuthorizationRequest
    ) -> AuthorizationPublisher {
        let manager = CLLocationManager()
        manager.activityType = activityType
        manager.desiredAccuracy = desiredAccuracy
        manager.distanceFilter = distanceFilter
        manager.headingFilter = headingFilter
        return AuthorizationPublisher(manager: manager, request: request)
    }
}

public enum AuthorizationRequest {
    case whenInUse
    case always
    case temporaryFullAccuracy(purposeKey: String)
}

public struct Authorization {
    public let accuracy: CLAccuracyAuthorization
    public let status: CLAuthorizationStatus
}

public struct AuthorizationPublisher {
    let manager: CLLocationManager
    let request: AuthorizationRequest
}

extension AuthorizationPublisher: Publisher {
    public typealias Output = Authorization
    public typealias Failure = Never

    public func receive<Subscriber>(
        subscriber: Subscriber
    ) where
        Subscriber: Combine.Subscriber,
        Subscriber.Failure == Failure,
        Subscriber.Input == Output
    {
        let subscription = Subscription(subscriber: subscriber,
                                        manager: manager,
                                        request: request)
        subscriber.receive(subscription: subscription)
    }
}

extension AuthorizationPublisher {

    final class Subscription<Subscriber>: NSObject, CLLocationManagerDelegate
        where
        Subscriber: Combine.Subscriber,
        Subscriber.Input == Output
    {
        private let subscriber: Subscriber
        private let manager: CLLocationManager
        private let request: AuthorizationRequest

        init(subscriber: Subscriber,
             manager: CLLocationManager,
             request: AuthorizationRequest) {
            self.subscriber = subscriber
            self.manager = manager
            self.request = request
        }

        func locationManagerDidChangeAuthorization(
            _ manager: CLLocationManager
        ) {
            let authorization = Authorization(
                accuracy: manager.accuracyAuthorization,
                status: manager.authorizationStatus)
            _ = subscriber.receive(authorization)
        }
    }
}

extension AuthorizationPublisher.Subscription: Subscription {

    func request(_ demand: Subscribers.Demand) {
        let authorization = Authorization(
            accuracy: manager.accuracyAuthorization,
            status: manager.authorizationStatus)
        _ = subscriber.receive(authorization)
        manager.delegate = self
        switch request {
        case .always:
            manager.requestAlwaysAuthorization()
        case .whenInUse:
            manager.requestWhenInUseAuthorization()
        case .temporaryFullAccuracy(let key):
            manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: key)
        }
    }

    func cancel() {
        manager.delegate = nil
    }
}
