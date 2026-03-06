import 'dart:io';

void main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 3000;
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('Serving on http://localhost:$port');

  await for (final request in server) {
    var path = request.uri.path;
    if (path == '/') path = '/index.html';

    final file = File('build/web$path');
    if (await file.exists()) {
      final ext = path.split('.').last.toLowerCase();
      final contentType = switch (ext) {
        'html' => 'text/html',
        'js' => 'application/javascript',
        'css' => 'text/css',
        'json' => 'application/json',
        'png' => 'image/png',
        'jpg' || 'jpeg' => 'image/jpeg',
        'svg' => 'image/svg+xml',
        'ico' => 'image/x-icon',
        'woff2' => 'font/woff2',
        'woff' => 'font/woff',
        'ttf' => 'font/ttf',
        'wasm' => 'application/wasm',
        _ => 'application/octet-stream',
      };
      request.response.headers.set('Content-Type', contentType);
      request.response.headers.set('Access-Control-Allow-Origin', '*');
      request.response.headers.set('Cache-Control', 'no-cache, no-store, must-revalidate');
      await request.response.addStream(file.openRead());
    } else {
      // SPA fallback
      final index = File('build/web/index.html');
      request.response.headers.set('Content-Type', 'text/html');
      await request.response.addStream(index.openRead());
    }
    await request.response.close();
  }
}
