import 'package:web/web.dart' as web;

/// Web-only DOM embedding (iframes, etc.). Non-web code must not depend on this type.
abstract class WebDomEmbedder {
  web.HTMLIFrameElement buildPdfIFrame(String url);
}

class DefaultWebDomEmbedder implements WebDomEmbedder {
  @override
  web.HTMLIFrameElement buildPdfIFrame(String url) {
    return web.HTMLIFrameElement()
      ..src = url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..width = '100%'
      ..height = '100%';
  }
}

/// Default embedder for PDF iframe platform views.
final WebDomEmbedder webDomEmbedder = DefaultWebDomEmbedder();
