abstract final class StoredMediaHelper {
  static String getSemanticId(
    String namespace,
    String entityId,
    String role, [
    Object? qualifier,
  ]) {
    final parts = [namespace, entityId, role, ?qualifier];
    return parts.map((part) => part.toString().trim()).join(':');
  }
}
