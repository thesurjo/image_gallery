import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:photo_manager/photo_manager.dart';

import '../export/screen.export.dart';
import '../export/widget.export.dart';

class AlbumImage extends StatefulWidget {
  final AssetPathEntity album;
  const AlbumImage({super.key, required this.album});

  @override
  State<AlbumImage> createState() => _AlbumImageState();
}

class _AlbumImageState extends State<AlbumImage> {
  final List<Widget> _mediaList = [];
  int currentPage = 0;
  bool isLoading = false;
  bool isEnded = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();

    // Add scroll listener
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // Dispose the scroll controller
    _scrollController.dispose();
    super.dispose();
  }
 @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isEnded) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetEntity> media =
          await widget.album.getAssetListPaged(size: 100, page: currentPage);
      if (media.isEmpty || media.length < 100) {
        setState(() {
          isEnded = true;
        });
      }
      List<Widget> temp = await Future.wait(media.map((asset) async {
        var index = media.indexOf(asset);
        final Uint8List? thumbnailData =
            await asset.thumbnailDataWithSize(const ThumbnailSize(150, 150));
        return GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FileView(
                        asset: asset,
                        heroTag: "image$index",
                      )),
            )
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.memory(
              thumbnailData!,
              fit: BoxFit.cover,
            ),
          ),
        );
      }));

      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.album.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: MasonryGridView.count(
          controller: _scrollController,
          crossAxisCount: 3,
          itemCount: _mediaList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index < _mediaList.length) {
              return Hero(tag: "image$index", child: _mediaList[index]);
            } else {
              return isEnded
                  ? const SizedBox.shrink()
                  : const Center(
                      child: ShimmerImageLoader(),
                    );
            }
          },
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
      ),
    );
  }
}
