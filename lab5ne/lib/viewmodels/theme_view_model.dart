import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repository/settings_repository.dart';

part 'theme_view_model.g.dart';

// Cung cấp SettingsRepository dùng chung.
@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository();
}

// Quản lý ThemeMode hiện tại.
@Riverpod(keepAlive: true)
class ThemeViewModel extends _$ThemeViewModel {
  bool _isSaving = false;

  @override
  Future<ThemeMode> build() {
    final repository = ref.watch(settingsRepositoryProvider);

    return repository.loadTheme();
  }

  Future<void> changeTheme(ThemeMode mode) async {
    final currentMode = state.asData?.value;

    // Không đổi khi chưa đọc xong cấu hình hoặc đang lưu.
    if (state.isLoading || currentMode == null || _isSaving) {
      return;
    }

    if (currentMode == mode) {
      return;
    }

    final repository = ref.read(settingsRepositoryProvider);

    _isSaving = true;

    try {
      // Lưu thành công rồi mới cập nhật giao diện.
      await repository.saveTheme(mode);

      state = AsyncData(mode);
    } finally {
      // Luôn mở khóa, kể cả khi lưu bị lỗi.
      _isSaving = false;
    }
  }

  // Đọc lại cấu hình nếu lần tải ban đầu thất bại.
  Future<void> reload() async {
    if (state.isLoading || _isSaving) {
      return;
    }

    final repository = ref.read(settingsRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => repository.loadTheme(),
    );
  }
}