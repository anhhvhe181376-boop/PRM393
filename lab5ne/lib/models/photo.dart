class Photo {
  final int id;
  final int albumId;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo({
    required this.id,
    required this.albumId,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: (map['id'] as num).toInt(),
      albumId: (map['albumId'] as num).toInt(),
      title: map['title'] as String,
      url: map['url'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'albumId': albumId,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
