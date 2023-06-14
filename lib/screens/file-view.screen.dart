import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

class FileView extends StatefulWidget {
  final AssetEntity asset;
  const FileView({super.key, required this.asset});

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FutureBuilder<Uint8List?>(
                future: widget.asset.thumbnailData,
                builder: (_, snapshot) {
                  final bytes = snapshot.data;
                  // If we have no data, display a spinner
                  if (bytes == null) return const CircularProgressIndicator();
                  // If there's data, display it as an image
                  return InkWell(
                    onTap: () {},
                    child: Stack(
                      children: [
                        // Wrap the image in a Positioned.fill to fill the space
                        Positioned.fill(
                          child: Image.memory(bytes, fit: BoxFit.cover),
                        ),
                        // Display a Play icon if the asset is a video
                        if (widget.asset.type == AssetType.video)
                          Center(
                            child: Container(
                              color: Colors.blue,
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                })));
  }
}
