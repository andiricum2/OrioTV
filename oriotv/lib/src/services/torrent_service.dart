import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class TorrentDownloader {
  Dio dio = Dio();

  Future<void> downloadTorrent(String url) async {
    try {
      var response = await dio.get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              }));

      var documentsPath = await getApplicationDocumentsDirectory();
      var filePath = path.join(documentsPath.path, 'downloaded.torrent');

      File file = File(filePath);
      await file.writeAsBytes(response.data!);

      // Lógica de manejo del archivo torrent descargado aquí
    } catch (e) {
      print('Error al descargar el torrent: $e');
    }
  }
}
