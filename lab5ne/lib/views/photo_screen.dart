import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lab5_photo/widgets/photo_title.dart';

import '../viewmodels/photo_view_model.dart';
import '../viewmodels/wishlist_view_model.dart';
import '../widgets/theme_menu.dart';


class PhotoScreen extends ConsumerWidget {
  const PhotoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(photoViewModelProvider);
    final wishlistAsync = ref.watch(wishlistViewModelProvider);

    final wishlist = wishlistAsync.asData?.value;

    final canToggle = !wishlistAsync.isLoading &&
        !wishlistAsync.hasError &&
        wishlist != null &&
        !wishlist.isBusy;

    // Hiển thị thông báo sau thao tác quan tâm / bỏ quan tâm.
    ref.listen<AsyncValue<WishlistState>>(
      wishlistViewModelProvider,
      (previous, next) {
        final message = next.asData?.value.message;
        final previousMessage = previous?.asData?.value.message;

        if (message == null || message == previousMessage) {
          return;
        }

        // Chỉ hiển thị thông báo khi màn hình này đang ở phía trước.
        if (ModalRoute.of(context)?.isCurrent != true) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(message)),
          );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách Photo'),
        actions: [
          IconButton(
            tooltip: 'Danh sách quan tâm',
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).pushNamed('/wishlist');
            },
          ),
          const ThemeMenu(),
        ],
      ),
      body: Column(
        children: [
          // Trạng thái đọc SQLite hoặc đang cập nhật WishList.
          if (wishlistAsync.isLoading || (wishlist?.isBusy ?? false))
            const LinearProgressIndicator(),

          // Lỗi WishList không ngăn việc xem danh sách API.
          if (wishlistAsync.hasError)
            MaterialBanner(
              content: const Text(
                'Không đọc được danh sách quan tâm trên máy.',
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await ref
                        .read(wishlistViewModelProvider.notifier)
                        .reload();
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),

          Expanded(
            child: photosAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_off,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Không tải được danh sách Photo.\n$error',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () async {
                          await ref
                              .read(photoViewModelProvider.notifier)
                              .reload();
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (photos) {
                return RefreshIndicator(
                  onRefresh: () {
                    return ref
                        .read(photoViewModelProvider.notifier)
                        .reload();
                  },
                  child: photos.isEmpty
                      ? ListView(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(
                                child: Text('Không có Photo nào.'),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            final photo = photos[index];

                            return PhotoTile(
                              key: ValueKey(photo.id),
                              photo: photo,
                              isFavorite:
                                  wishlist?.contains(photo.id) ?? false,
                              enabled: canToggle,
                              onToggle: () async {
                                await ref
                                    .read(
                                      wishlistViewModelProvider.notifier,
                                    )
                                    .toggle(photo);
                              },
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}