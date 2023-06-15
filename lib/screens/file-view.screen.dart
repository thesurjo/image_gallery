import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../export/widget.export.dart';

class FileView extends StatefulWidget {
  final AssetEntity asset;
  final String heroTag;
  const FileView({Key? key, required this.asset, required this.heroTag})
      : super(key: key);

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  late AssetEntityImageProvider imageProvider;
  Image? imageWidget;

  @override
  void initState() {
    super.initState();
    imageProvider = AssetEntityImageProvider(widget.asset);
    imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        if (mounted) {
          setState(() {
            imageWidget = Image(image: imageProvider);
          });
        }
      }),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: widget.heroTag,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 5.0,
            clipBehavior: Clip.hardEdge,
            child: imageWidget ?? const DefaultCircularLoader(),
          ),
        ),
      ),
    );
  }
}
