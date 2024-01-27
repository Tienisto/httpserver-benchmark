# Benchmark

This repo tests the performance between Dart and Node.js when uploading large binary data to a server.

The motivation is to investigate the poor performance of Dart when processing large binary data via HTTPS.

## HTTP result

| Client  | Server  | Speed (more is better) | Factor |
|---------|---------|------------------------|--------|
| Dart    | Dart    | 1641 MB/s              | 1x     |
| Node.js | Dart    | 1655 MB/s              | 1x     |
| Dart    | Node.js | 2270 MB/s              | 1.38x  |
| Node.js | Node.js | 2177 MB/s              | 1.33x  |

## HTTPS result

| Client  | Server  | Speed (more is better) | Factor |
|---------|---------|------------------------|--------|
| Dart    | Dart    | 170 MB/s               | 1x     |
| Node.js | Dart    | 158 MB/s               | 0.92x  |
| Dart    | Node.js | 272 MB/s               | 1.6x   |
| Node.js | Node.js | 1228 MB/s              | 7.22x  |

## How to run

### Dart

Server:

```bash
cd dart
dart run
```

Client:

```bash
cd dart
dart run benchmark:upload
```

### Node.js

Server:

```bash
cd node
node main.js
```

Client:

```bash
cd node
node upload.js
```
