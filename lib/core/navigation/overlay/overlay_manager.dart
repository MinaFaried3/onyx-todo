import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


// ---------------------------------------------------------------------------
// Snackbar types
// ---------------------------------------------------------------------------
enum SnackBarType { info, success, warning, error }

// ---------------------------------------------------------------------------
// Loading state tracker to prevent duplicate overlays.
// ---------------------------------------------------------------------------
class _LoadingState {
  int _loadingCount = 0;
  OverlayEntry? _entry;
}
class OverlayManager {
  final GlobalKey<NavigatorState> navigatorKey;
  final _LoadingState _loadingState = _LoadingState();

  OverlayManager({required this.navigatorKey});

  BuildContext? get _context => navigatorKey.currentContext;

  // ─────────────────────────────────────────────
  // Loading
  // ─────────────────────────────────────────────
  void showLoading() {
    _loadingState._loadingCount++;
    if (_loadingState._loadingCount > 1) return; // Already showing

    final ctx = _context;
    if (ctx == null) return;

    _loadingState._entry = OverlayEntry(
      builder: (_) => const _LoadingOverlay(),
    );
    
    final entry = _loadingState._entry;
    final overlay = navigatorKey.currentState?.overlay;
    if (overlay != null && entry != null) {
      overlay.insert(entry);
      Printer.printHint('[OverlayManager] showLoading (count: ${_loadingState._loadingCount})');
    } else {
      _loadingState._loadingCount--; // Revert if failed
      Printer.printHint('[OverlayManager] Failed to show loading: No Overlay found');
    }
  }

  void hideLoading() {
    if (_loadingState._loadingCount <= 0) return;
    
    _loadingState._loadingCount--;
    if (_loadingState._loadingCount == 0) {
      _loadingState._entry?.remove();
      _loadingState._entry = null;
      Printer.printHint('[OverlayManager] hideLoading (cleared)');
    } else {
      Printer.printHint('[OverlayManager] hideLoading (count remaining: ${_loadingState._loadingCount})');
    }
  }

  // ─────────────────────────────────────────────
  // Snackbars
  // ─────────────────────────────────────────────
  void showSnackBar(
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final ctx = _context;
    if (ctx == null) return;

    final color = switch (type) {
      SnackBarType.success => const Color(0xFF4CAF50),
      SnackBarType.warning => const Color(0xFFFFC107),
      SnackBarType.error => const Color(0xFFF44336),
      SnackBarType.info => const Color(0xFF2196F3),
    };

    final icon = switch (type) {
      SnackBarType.success => Icons.check_circle_outline,
      SnackBarType.warning => Icons.warning_amber_outlined,
      SnackBarType.error => Icons.error_outline,
      SnackBarType.info => Icons.info_outline,
    };

    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Dialogs
  // ─────────────────────────────────────────────
  Future<T?> showAppDialog<T>({required Widget dialog}) async {
    final ctx = _context;
    if (ctx == null) return null;
    return showDialog<T>(
      context: ctx,
      barrierDismissible: true,
      builder: (_) => dialog,
    );
  }

  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
  }) async {
    final ctx = _context;
    if (ctx == null) return false;

    final result = await showAppDialog<bool>(
      dialog: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(ctx).pop(false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => GoRouter.of(ctx).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

// ---------------------------------------------------------------------------
// Private loading overlay widget.
// ---------------------------------------------------------------------------
class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0x66000000),
      child: Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }
}
