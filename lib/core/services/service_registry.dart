import 'package:boo_mondai/core/services/service.dart';

abstract final class ServiceRegistry {
  static final Map<String, Service> _services = {};

  static T add<T extends Service>(T service) {
    final existing = _services[service.id];
    if (identical(existing, service)) {
      return service;
    }
    if (existing != null) {
      throw StateError('Service already registered: ${service.id}');
    }
    _services[service.id] = service;
    return service;
  }

  static T? maybeById<T extends Service>(String id) {
    final service = _services[id];
    return service is T ? service : null;
  }

  static T byId<T extends Service>(String id) {
    final service = maybeById<T>(id);
    if (service != null) return service;
    throw StateError('Service not found or wrong type: $id');
  }
}
