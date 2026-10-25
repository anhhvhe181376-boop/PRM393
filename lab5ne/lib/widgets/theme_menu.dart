import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/theme_view_model.dart';

class ThemeMenu extends ConsumerStatefulWidget {
  const ThemeMenu({super.key});

  @override
  ConsumerState<ThemeMenu> createState() => _ThemeMenuState();
}

class _ThemeMenuState extends ConsumerState<ThemeMenu> {
  bool _isSaving = false;

  Future<void> _changeTheme(ThemeMode mode) async {
    setState(() {
      _isSaving = true;
    });

    try {
      await ref
          .read(themeViewModelProvider.notifier)
          .changeTheme(mode);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không lưu được chế độ giao diện: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeViewModelProvider);
    final currentMode = themeState.asData?.value;

    if (_isSaving || themeState.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (themeState.hasError) {
      return IconButton(
        tooltip: 'Thử đọc lại cấu hình giao diện',
        icon: const Icon(Icons.refresh),
        onPressed: () async {
          await ref
              .read(themeViewModelProvider.notifier)
              .reload();
        },
      );
    }

    return PopupMenuButton<ThemeMode>(
      tooltip: 'Chọn giao diện',
      icon: const Icon(Icons.palette_outlined),
      initialValue: currentMode,
      onSelected: _changeTheme,
      itemBuilder: (context) => [
        CheckedPopupMenuItem<ThemeMode>(
          value: ThemeMode.system,
          checked: currentMode == ThemeMode.system,
          child: const Text('Theo hệ thống'),
        ),
        CheckedPopupMenuItem<ThemeMode>(
          value: ThemeMode.light,
          checked: currentMode == ThemeMode.light,
          child: const Text('Giao diện sáng'),
        ),
        CheckedPopupMenuItem<ThemeMode>(
          value: ThemeMode.dark,
          checked: currentMode == ThemeMode.dark,
          child: const Text('Giao diện tối'),
        ),
      ],
    );
  }
}