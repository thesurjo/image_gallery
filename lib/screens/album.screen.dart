import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class Album extends StatefulWidget {
  final GlobalKey<ScaffoldState> albumKey;
  const Album({Key? key, required this.albumKey}) : super(key: key);
  @override
  State<Album> createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
  getAlbum() async {
    final albums = await PhotoManager.getAssetPathList();
    print(albums);
  }

  @override
  void initState() {
    getAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
