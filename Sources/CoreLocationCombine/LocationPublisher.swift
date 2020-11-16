
import CoreLocation
import Combine

extension CLLocationManager {

    public var locationPublisher: LocationPublisher {
        let manager = CLLocationManager()
        manager.activityType = activityType
        manager.desiredAccuracy = desiredAccuracy
        manager.distanceFilter = distanceFilter
        manager.headingFilter = headingFilter
        return LocationPublisher(manager: manager)
    }
}

public struct LocationPublisher {
    let manager: CLLocationManager
}

extension LocationPublisher: Publisher {
    public typealias Output = CLLocation
    public typealias Failure = Error

    public func receive<Subscriber>(
        subscriber: Subscriber
    ) where
        Subscriber: Combine.Subscriber,
        Subscriber.Failure == Failure,
        Subscriber.Input == Output
    {
        let subscription = Subscription(subscriber: subscriber,
                                        manager: manager)
        subscriber.receive(subscription: subscription)
    }
}

extension LocationPublisher {

    final class Subscription<Subscriber>: NSObject, CLLocationManagerDelegate
        where
        Subscriber: Combine.Subscriber,
        Subscriber.Input == Output,
        Subscriber.Failure == Failure
    {
        private let subscriber: Subscriber
        private let manager: CLLocationManager

        init(subscriber: Subscriber,
             manager: CLLocationManager) {
            self.subscriber = subscriber
            self.manager = manager
        }

        func locationManager(
            _ manager: CLLocationManager,
            didUpdateLocations locations: [CLLocation]
        ) {
            locations.forEach { _ = subscriber.receive($0) }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            subscriber.receive(completion: .failure(error))
        }
    }
}

extension LocationPublisher.Subscription: Subscription {

    func request(_ demand: Subscribers.Demand) {
        manager.delegate = self
        manager.startUpdatingLocation()
    }

    func cancel() {
        manager.delegate = nil
        manager.stopUpdatingLocation()
    }
}
