import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/resolution_info.dart';

abstract class PlatformFileOpsContract {
  void initializeUrlStrategy();
  Future<void> clearStorageWeb(Future<void> Function() clearData);
  String getBaseUrl();
  void changeUrlWithoutNavigation(String newUrl);
  void openFormsUrl(String? url);
  void disableBrowserBackButton();
  void extractAs({
    String? url,
    String name = 'download',
    Object value = 'export.csv',
  });
  Map<String, dynamic> getCurrentResolution(BuildContext context);
  Map<String, dynamic> getFiscalResolution();
  ResolutionInfo measureResolutionInfo();
  Future<void> showPdfInDialog(
    BuildContext context,
    String url, {
    bool showToolbar = true,
  });
  void showPdfInDialogWithToolbar(BuildContext context, String url);
  void showPdfInDialogWithoutToolbar(BuildContext context, String url);
  void openPdfInNewTab(String url);
  Future<bool> silentPrintPdfFromUrl(String url);
  Future<AudioPlayer> audioSetUrl(AudioPlayer player, String audioUrl);
}
