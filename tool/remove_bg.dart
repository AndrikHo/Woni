import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

void main() {
  final bytes = File('assets/images/logo2.jpeg').readAsBytesSync();
  final image = img.decodeImage(bytes)!;

  print('Image: ${image.width}x${image.height}, numChannels: ${image.numChannels}');

  // The checkerboard "transparency" pattern in this JPEG uses DARK colors:
  //   Black squares:     ~RGB(0-5, 0-5, 0-5)     brightness ~0-5
  //   Dark gray squares: ~RGB(78-87, 78-87, 78-87) brightness ~78-87
  // Both have near-zero chroma (R ≈ G ≈ B).
  // Logo content (gold "Woni" text, Korean bills in "W") has visible color.

  final result = img.Image(
    width: image.width,
    height: image.height,
    numChannels: 4,
  );

  int transparent = 0;
  int semiTransparent = 0;

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      final r = pixel.r.toInt();
      final g = pixel.g.toInt();
      final b = pixel.b.toInt();

      final maxC = [r, g, b].reduce(math.max);
      final minC = [r, g, b].reduce(math.min);
      final chroma = maxC - minC;
      final brightness = (r + g + b) / 3.0;

      // Detect checkerboard background pixels
      final bool isBlackSquare = brightness < 20 && chroma < 18;
      final bool isGraySquare =
          brightness > 65 && brightness < 100 && chroma < 18;
      final bool isCheckerboard = isBlackSquare || isGraySquare;

      // Transition zone — near-dark desaturated pixels along edges
      final bool isTransition = !isCheckerboard &&
          chroma < 30 &&
          brightness < 110;

      int alpha;
      if (isCheckerboard) {
        alpha = 0;
        transparent++;
      } else if (isTransition) {
        // Smooth based on how colorful the pixel is (more color = more opaque)
        final chromaFactor = (chroma / 30.0).clamp(0.0, 1.0);
        alpha = (255 * chromaFactor).round().clamp(0, 255);
        semiTransparent++;
      } else {
        alpha = 255;
      }

      final p = result.getPixel(x, y);
      p.r = r;
      p.g = g;
      p.b = b;
      p.a = alpha;
    }
  }

  final total = image.width * image.height;
  print('Transparent: $transparent / $total (${(transparent * 100 / total).toStringAsFixed(1)}%)');
  print('Semi-transparent: $semiTransparent');
  print('Opaque: ${total - transparent - semiTransparent}');

  // Resize to 512px wide
  final resized = img.copyResize(result, width: 512);
  print('Resized: ${resized.width}x${resized.height}');

  final png = img.encodePng(resized);
  File('assets/images/logo.png').writeAsBytesSync(png);
  print('Done! Saved logo.png (${(png.length / 1024).toStringAsFixed(0)} KB)');
}
