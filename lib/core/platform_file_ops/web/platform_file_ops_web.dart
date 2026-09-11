import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../core/contracts/device_services_contract.dart';
import '../core/contracts/platform_file_ops_contract.dart';
import '../core/models/resolution_info.dart';
import 'device_services_web_adapter.dart';
import 'web_helpers.dart' as web_helpers;

/// Web shell: all device/DOM primitives go through [deviceServices].
final class PlatformFileOpsWeb implements PlatformFileOpsContract {
  final DeviceServicesContract deviceServices;

  PlatformFileOpsWeb(this.deviceServices);

  @override
  void initializeUrlStrategy() => web_helpers.initializeUrlStrategyWeb();

  @override
  Future<void> clearStorageWeb(Future<void> Function() clearData) =>
      web_helpers.clearStorageWeb(deviceServices, clearData);

  @override
  String getBaseUrl() => web_helpers.getBaseUrl(deviceServices);

  @override
  void changeUrlWithoutNavigation(String newUrl) =>
      web_helpers.changeUrlWithoutNavigation(deviceServices, newUrl);

  @override
  void openFormsUrl(String? url) => web_helpers.openFormsUrl(deviceServices, url);

  @override
  void disableBrowserBackButton() =>
      web_helpers.disableBrowserBackButtonWeb(deviceServices);

  @override
  void extractAs({
    String? url,
    String name = 'download',
    Object value = 'export.csv',
  }) =>
      web_helpers.extractAsWeb(deviceServices, url: url, name: name, value: value);

  @override
  Map<String, dynamic> getCurrentResolution(BuildContext context) =>
      web_helpers.getCurrentResolution(context, deviceServices);

  @override
  Map<String, dynamic> getFiscalResolution() => web_helpers.getFiscalResolution();

  @override
  ResolutionInfo measureResolutionInfo() =>
      web_helpers.measureResolutionInfoWeb(deviceServices);

  @override
  Future<void> showPdfInDialog(
    BuildContext context,
    String url, {
    bool showToolbar = true,
  }) =>
      web_helpers.showPdfInDialogWeb(
        context,
        deviceServices,
        url,
        showToolbar: showToolbar,
      );

  @override
  void showPdfInDialogWithToolbar(BuildContext context, String url) =>
      web_helpers.showPdfInDialogWithToolbarWeb(context, deviceServices, url);

  @override
  void showPdfInDialogWithoutToolbar(BuildContext context, String url) =>
      web_helpers.showPdfInDialogWithoutToolbarWeb(context, deviceServices, url);

  @override
  void openPdfInNewTab(String url) =>
      web_helpers.openPdfInNewTabWeb(deviceServices, url);

  @override
  Future<bool> silentPrintPdfFromUrl(String url) =>
      web_helpers.silentPrintPdfFromUrlWeb(url);

  @override
  Future<AudioPlayer> audioSetUrl(AudioPlayer player, String audioUrl) =>
      web_helpers.audioSetUrlWeb(player, audioUrl);
}

PlatformFileOpsContract getPlatformFileOps() => PlatformFileOpsWeb(DeviceServicesWebAdapter());
