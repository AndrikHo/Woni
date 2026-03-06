import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

void main() {
  final bytes = File('assets/images/logo2.jpeg').readAsBytesSync();
  final image = img.decodeImage(bytes)!;

  print('Image: ${image.width}x${image.height}');

  // Sample corners and edges (should be checkerboard)
  final samples = <String, List<int>>{
    'top-left(5,5)': [5, 5],
    'top-left(15,15)': [15, 15],
    'top-left(25,5)': [25, 5],
    'top-left(5,25)': [5, 25],
    'top-right': [image.width - 10, 10],
    'bottom-left': [10, image.height - 10],
    'bottom-right': [image.width - 10, image.height - 10],
    'top-center': [image.width ~/ 2, 10],
    'left-center': [10, image.height ~/ 2],
    'right-center': [image.width - 10, image.height ~/ 2],
    // A few more spots in corners
    'corner(50,50)': [50, 50],
    'corner(100,100)': [100, 100],
    'corner(0,0)': [0, 0],
    'corner(1,1)': [1, 1],
  };

  print('\n--- Sample pixels (should be checkerboard background) ---');
  for (final entry in samples.entries) {
    final p = image.getPixel(entry.value[0], entry.value[1]);
    final r = p.r.toInt(), g = p.g.toInt(), b = p.b.toInt();
    final maxC = [r, g, b].reduce(math.max);
    final minC = [r, g, b].reduce(math.min);
    final chroma = maxC - minC;
    final brightness = (r + g + b) / 3.0;
    print('${entry.key}: RGB($r,$g,$b) brightness=${brightness.toStringAsFixed(1)} chroma=$chroma');
  }

  // Analyze distribution of pixel types
  final Map<String, int> buckets = {};
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final p = image.getPixel(x, y);
      final r = p.r.toInt(), g = p.g.toInt(), b = p.b.toInt();
      final maxC = [r, g, b].reduce(math.max);
      final minC = [r, g, b].reduce(math.min);
      final chroma = maxC - minC;
      final brightness = (r + g + b) / 3.0;

      String bucket;
      if (chroma < 10) {
        if (brightness > 240) bucket = 'gray-ch<10-bright>240';
        else if (brightness > 200) bucket = 'gray-ch<10-bright200-240';
        else if (brightness > 160) bucket = 'gray-ch<10-bright160-200';
        else if (brightness > 100) bucket = 'gray-ch<10-bright100-160';
        else bucket = 'gray-ch<10-bright<100';
      } else if (chroma < 20) {
        if (brightness > 200) bucket = 'low-ch10-20-bright>200';
        else if (brightness > 150) bucket = 'low-ch10-20-bright150-200';
        else bucket = 'low-ch10-20-bright<150';
      } else if (chroma < 40) {
        bucket = 'med-ch20-40';
      } else {
        bucket = 'color-ch>40';
      }

      buckets[bucket] = (buckets[bucket] ?? 0) + 1;
    }
  }

  print('\n--- Pixel distribution ---');
  final sorted = buckets.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  final total = image.width * image.height;
  for (final e in sorted) {
    print('${e.key}: ${e.value} (${(e.value * 100 / total).toStringAsFixed(1)}%)');
  }

  // Also sample a row of pixels across the top to see the checkerboard pattern
  print('\n--- Top row pixels (y=50, x=0..60 step 4) ---');
  for (int x = 0; x < 60; x += 4) {
    final p = image.getPixel(x, 50);
    final r = p.r.toInt(), g = p.g.toInt(), b = p.b.toInt();
    print('  x=$x: RGB($r,$g,$b)');
  }
}
