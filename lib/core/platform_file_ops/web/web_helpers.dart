import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'package:just_audio/just_audio.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import '../core/contracts/device_services_contract.dart';
import '../core/models/resolution_info.dart';
import 'web_dom_embedder.dart';

void initializeUrlStrategyWeb() {
  usePathUrlStrategy();
}

Future<void> clearStorageWeb(
  DeviceServicesContract deviceServices,
  Future<void> Function() clearData,
) async {
  final isReload = deviceServices.readSessionStorage('isReload') == 'true';
  if (!isReload) {
    deviceServices.clearLocalStorage();
    await clearData();
    deviceServices.writeSessionStorage('isReload', 'true');
  }
}

String getBaseUrl(DeviceServicesContract deviceServices) {
  return deviceServices.locationOrigin;
}

void changeUrlWithoutNavigation(
  DeviceServicesContract deviceServices,
  String newUrl,
) {
  deviceServices.pushState(newUrl);
}

void openFormsUrl(DeviceServicesContract deviceServices, String? url) {
  final width = deviceServices.screenWidth;
  final height = deviceServices.screenHeight;
  deviceServices.openUrl(
    url ?? '',
    features: 'Location=yes,height=$height,width=$width,scrollbars=yes,status=yes,top=0,left=0',
  );
}

void disableBrowserBackButtonWeb(DeviceServicesContract deviceServices) {
  deviceServices.disableBrowserBackButton();
}

void extractAsWeb(
  DeviceServicesContract deviceServices, {
  String? url,
  String name = 'download',
  Object value = 'export.csv',
}) {
  if (url != null) {
    deviceServices.openUrl(url);
  }
}

Map<String, dynamic> getCurrentResolution(
  BuildContext context,
  DeviceServicesContract deviceServices,
) {
  return {
    'width': deviceServices.innerWidth,
    'height': deviceServices.innerHeight,
    'pixelRatio': deviceServices.devicePixelRatio,
  };
}

Map<String, dynamic> getFiscalResolution() {
  return {};
}

ResolutionInfo measureResolutionInfoWeb(DeviceServicesContract deviceServices) {
  final ppi = deviceServices.measureCssPixelsPerInch();
  return ResolutionInfo(ppi: ppi);
}

Future<void> showPdfInDialogWeb(
  BuildContext context,
  DeviceServicesContract deviceServices,
  String url, {
  bool showToolbar = true,
}) async {
  if (url.isEmpty) {
    return;
  }
  final String viewID = 'pdf-viewer-${DateTime.now().millisecondsSinceEpoch}';
  String pdfUrl = url;
  final hashIndex = url.indexOf('#');
  if (hashIndex != -1) {
    pdfUrl = url.substring(0, hashIndex);
  }
  pdfUrl = showToolbar ? '$pdfUrl#toolbar=1' : '$pdfUrl#toolbar=0';

  ui_web.platformViewRegistry.registerViewFactory(
    viewID,
    (int viewId) {
      final iframe = webDomEmbedder.buildPdfIFrame(pdfUrl);
      return iframe;
    },
  );

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: 800,
        height: 600,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 5, left: 10),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      deviceServices.openUrl(url);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0C69C0),
                        shape: .circle,
                      ),
                      child: IconButton(
                        tooltip: 'Full Screen',
                        icon: const Icon(Icons.fullscreen, color: Colors.white, size: 23),
                        onPressed: () {
                          deviceServices.openUrl(url);
                        },
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (dialogContext.mounted && Navigator.canPop(dialogContext)) {
                        Navigator.pop(dialogContext);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFCFD8DC),
                        shape: .circle,
                      ),
                      child: const Icon(Icons.close, color: Color(0xFF819AA7), size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: HtmlElementView(viewType: viewID),
            ),
          ],
        ),
      ),
    ),
  );
}

void showPdfInDialogWithToolbarWeb(
  BuildContext context,
  DeviceServicesContract deviceServices,
  String url,
) {
  showPdfInDialogWeb(context, deviceServices, url, showToolbar: true);
}

void showPdfInDialogWithoutToolbarWeb(
  BuildContext context,
  DeviceServicesContract deviceServices,
  String url,
) {
  showPdfInDialogWeb(context, deviceServices, url, showToolbar: false);
}

void openPdfInNewTabWeb(DeviceServicesContract deviceServices, String url) {
  deviceServices.openUrl(url);
}

String? _messageEventDataString(web.MessageEvent e) {
  final v = e.data;
  if (v == null) return null;
  return (v as JSString).toDart;
}

Future<bool> silentPrintPdfFromUrlWeb(String url) async {
  final completer = Completer<bool>();
  const frameId = '__silent_print_url_frame__';
  const scriptId = '__silent_print_url_script__';

  web.document.getElementById(frameId)?.remove();
  web.document.getElementById(scriptId)?.remove();

  late final web.EventListener messageListenerJs;
  messageListenerJs = ((web.Event event) {
    final data = _messageEventDataString(event as web.MessageEvent);
    if (data == '__silent_print_url_done__') {
      web.window.removeEventListener('message', messageListenerJs);
      Future.delayed(const Duration(milliseconds: 500), () {
        web.document.getElementById(frameId)?.remove();
        web.document.getElementById(scriptId)?.remove();
        if (!completer.isCompleted) completer.complete(true);
      });
    } else if (data == '__silent_print_url_error__') {
      web.window.removeEventListener('message', messageListenerJs);
      web.document.getElementById(scriptId)?.remove();
      if (!completer.isCompleted) completer.complete(false);
    }
  }).toJS;

  web.window.addEventListener('message', messageListenerJs);

  final script = web.document.createElement('script') as web.HTMLScriptElement
    ..id = scriptId
    ..type = 'text/javascript'
    ..text = '''
(function() {
  var pdfUrl = ${jsonEncode(url)};
  fetch(pdfUrl)
    .then(function(resp) {
      if (!resp.ok) throw new Error('HTTP ' + resp.status);
      return resp.blob();
    })
    .then(function(blob) {
      var blobUrl = URL.createObjectURL(blob);
      var oldFrame = document.getElementById('$frameId');
      if (oldFrame) oldFrame.remove();
      var f = document.createElement('iframe');
      f.id = '$frameId';
      f.src = blobUrl;
      f.style.cssText = 'position:fixed;left:-9999px;top:-9999px;width:1px;height:1px;opacity:0;border:none;';
      f.addEventListener('load', function() {
        try {
          f.contentWindow.addEventListener('afterprint', function() {
            window.postMessage('__silent_print_url_done__', '*');
            URL.revokeObjectURL(blobUrl);
          });
          f.contentWindow.focus();
          f.contentWindow.print();
        } catch(e) {
          window.postMessage('__silent_print_url_done__', '*');
          URL.revokeObjectURL(blobUrl);
        }
      });
      document.body.appendChild(f);
    })
    .catch(function(e) {
      console.error('silentPrintPdfFromUrl failed:', e);
      window.postMessage('__silent_print_url_error__', '*');
    });
})();
''';

  web.document.body?.appendChild(script);

  Future.delayed(const Duration(seconds: 30), () {
    web.window.removeEventListener('message', messageListenerJs);
    web.document.getElementById(frameId)?.remove();
    web.document.getElementById(scriptId)?.remove();
    if (!completer.isCompleted) completer.complete(false);
  });

  return completer.future;
}

Future<AudioPlayer> audioSetUrlWeb(AudioPlayer player, String audioUrl) async {
  await player.setUrl(audioUrl);
  return player;
}
