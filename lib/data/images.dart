import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class StoredImageProvider extends StatefulWidget {
  final String? imageId;

  const StoredImageProvider({super.key, required this.imageId});
  @override
  State<StatefulWidget> createState() {
    return _ImageProviderState(imageId);
  }
}

class _ImageProviderState extends State<StoredImageProvider> {
  final String? _imageId;
  Uint8List? _loadedData;
  _ImageProviderState(this._imageId) {
    if (_imageId is String) {
      _load(_imageId).then((value) {
        setState(() {
          _loadedData = value;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_loadedData == null) {
      return Container();
    }
    return Image.memory(_loadedData!);
  }
}

Future<Uint8List> _load(String imageId) async {
  final path =
      '${(await getApplicationDocumentsDirectory()).path}/images/$imageId';
  return File(path).readAsBytes();
}

Future store(String imageId, Uint8List data) async {
  final path = '${(await getApplicationDocumentsDirectory()).path}/images/$imageId';
  final file = File(path);
  if (!await file.exists()) {
    await file.create(recursive: true);
  }
  return await file.writeAsBytes(data, mode: FileMode.write);
}
