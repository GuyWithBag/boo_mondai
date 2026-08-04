enum ProfileRole {
  user('user'),
  researcher('researcher'),
  admin('admin');

  const ProfileRole(this.value);

  final String value;

  static ProfileRole fromString(String? value) {
    final normalized = value?.trim().toLowerCase();
    return ProfileRole.values.firstWhere(
      (role) => role.value == normalized,
      orElse: () => ProfileRole.user,
    );
  }
}
