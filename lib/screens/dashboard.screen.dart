import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_manager/photo_manager.dart';

import '../export/screen.export.dart';
import '../export/widget.export.dart';

class Dashboard extends StatefulWidget {
  final GlobalKey<ScaffoldState> dashboardKey;

  const Dashboard({Key? key, required this.dashboardKey}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Widget> _mediaList = [];
  int currentPage = 0;
  bool isLoading = false;
  bool isEnded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
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

  _deleteMedia(assetId) async {
    List<String> assets = await PhotoManager.editor.deleteWithIds([assetId]);
    print(assets);
  }

  _fetchNewMedia() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(size: 100, page: currentPage);
      if (media.isEmpty || media.length < 100) {
        setState(() {
          isEnded = true;
        });
      }
      List<Widget> temp = await Future.wait(media.map((asset) async {
        var index = media.indexOf(asset);
        Uint8List? thumbnailData =
            await asset.thumbnailDataWithSize(const ThumbnailSize(150, 150));
        return GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FileView(
                  asset: asset,
                  heroTag: "image$index",
                ),
              ),
            )
          },
          onLongPress: () => {
            // showModalBottomSheet(
            //   context: context,
            //   showDragHandle: true,
            //   enableDrag: true,
            //   builder: (BuildContext context) {
            //     return Container(
            //         padding: const EdgeInsets.all(20),
            //         width: double.maxFinite,
            //         // height: 300,
            //         child: Column(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             ClipRRect(
            //               borderRadius: BorderRadius.circular(15),
            //               child: Image.memory(
            //                 thumbnailData,
            //                 fit: BoxFit.cover,
            //                 height: 200,
            //               ),
            //             ),
            //             const SizedBox(
            //               height: 20,
            //             ),
            //             Row(
            //               children: [
            //                 Column(
            //                   children: [
            //                     IconButton(
            //                         onPressed: () {
            //                           _deleteMedia(asset.id);
            //                         },
            //                         icon: const Icon(Icons.delete_outline))
            //                   ],
            //                 )
            //               ],
            //             )
            //           ],
            //         ));
            //   },
            // )
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

        if (isEnded) {
          _scrollController.removeListener(_scrollListener);
        }
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
        title: const Text(
          'Images',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
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
                          : const SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: ShimmerImageLoader(),
                              ),
                            );
                    }
                  },
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
              ),
            ),
            SizedBox.expand(
              child: DraggableScrollableSheet(
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    color: Colors.white,
                    child: const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding:  EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                                Icon(Icons.abc),
                              ]),
                        )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
