import 'dart:io';

void main() async {
  print('Uploading file...');
  await uploadFile(
    sourcePath: 'test_file',
    destinationPath: 'https://localhost:3000',
  );
}

Future<void> uploadFile({
  required String sourcePath,
  required String destinationPath,
}) async {
  final httpClient = HttpClient();
  httpClient.badCertificateCallback = (_, __, ___) => true;

  final request = await httpClient.postUrl(Uri.parse(destinationPath));
  request.headers.contentType = ContentType('application', 'octet-stream');
  final stopwatch = Stopwatch()..start();
  await request.addStream(File(sourcePath).openRead());
  await request.close();
  final fileSize = File(sourcePath).lengthSync();
  final speed = fileSize / (stopwatch.elapsedMilliseconds / 1000);
  print('File size: ${fileSize / 1024 / 1024} MB');
  print('Speed: ${speed / 1024 / 1024} MB/s');
  print('Time: ${stopwatch.elapsedMilliseconds} ms');
}
