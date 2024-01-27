import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';

Future<void> main() async {
  final server = await createServer(secure: true);
  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    // final sink = File('uploaded_file').openWrite();
    await for (final Uint8List event in request) {
      // sink.add(event);
    }
    // await sink.close();
    request.response.statusCode = HttpStatus.ok;
    await request.response.close();
  }
}

Future<HttpServer> createServer({required bool secure}) {
  if (secure) {
    return HttpServer.bindSecure('0.0.0.0', 3000, generateSecurityContext());
  } else {
    return HttpServer.bind('0.0.0.0', 3000);
  }
}

SecurityContext generateSecurityContext() {
  final keyPair = CryptoUtils.generateRSAKeyPair();
  final privateKey = keyPair.privateKey as RSAPrivateKey;
  final publicKey = keyPair.publicKey as RSAPublicKey;
  final dn = {
    'CN': 'Test',
    'O': '',
    'OU': '',
    'L': '',
    'S': '',
    'C': '',
  };
  final csr = X509Utils.generateRsaCsrPem(dn, privateKey, publicKey);
  final certificate = X509Utils.generateSelfSignedCertificate(keyPair.privateKey, csr, 365 * 10);

  return SecurityContext()
    ..usePrivateKeyBytes(CryptoUtils.encodeRSAPrivateKeyToPemPkcs1(privateKey).codeUnits)
    ..useCertificateChainBytes(certificate.codeUnits);
}
