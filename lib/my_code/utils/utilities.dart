import 'dart:io';
class  Utilites{
  static Future<String> getFileFormat(File file) async {
    final List<int> bytes = await file.readAsBytes();

    if (bytes.length >= 2) {
      if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
        return 'jpeg'; // It's a JPEG image
      } else if (bytes[0] == 0x89 && bytes[1] == 0x50) {
        return 'png'; // It's a PNG image
      }
    }

    return 'unknown'; // Unknown format
  }
}
