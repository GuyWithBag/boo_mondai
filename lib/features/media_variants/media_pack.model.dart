class MediaPack<T> {
  const MediaPack({
    required this.id,
    required this.name,
    required this.media,
    this.description,
    this.author,
  }) : assert(id != '', 'MediaPack id must not be empty');

  final String id;
  final String name;
  final String? description;
  final String? author;
  final T media;

  MediaPack<T> copyWith({
    String? name,
    String? description,
    String? author,
    T? media,
  }) {
    return MediaPack<T>(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      author: author ?? this.author,
      media: media ?? this.media,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MediaPack<T> && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
