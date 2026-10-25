import 'package:flutter/material.dart';

import '../models/photo.dart';

class PhotoTile extends StatelessWidget {
  final Photo photo;
  final bool isFavorite;
  final bool enabled;
  final VoidCallback onToggle;

  const PhotoTile({
    super.key,
    required this.photo,
    required this.isFavorite,
    required this.onToggle,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        // Ảnh thu nhỏ.
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            photo.thumbnailUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }

              return const SizedBox(
                width: 64,
                height: 64,
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                width: 64,
                height: 64,
                child: Center(
                  child: Icon(Icons.broken_image_outlined),
                ),
              );
            },
          ),
        ),

        // Thông tin Photo.
        title: Text(
          photo.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Photo #${photo.id} • Album ${photo.albumId}',
        ),

        // Nút quan tâm / bỏ quan tâm.
        trailing: IconButton(
          tooltip: isFavorite ? 'Bỏ quan tâm' : 'Quan tâm',
          onPressed: enabled ? onToggle : null,
          icon: Icon(
            isFavorite
                ? Icons.favorite
                : Icons.favorite_border,
          ),
          color: isFavorite ? Colors.red : null,
        ),
      ),
    );
  }
}