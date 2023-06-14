import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_gallery/screens/file-view.screen.dart';
import 'package:photo_manager/photo_manager.dart';

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

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchNewMedia();
    }
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
      List<Widget> temp = await Future.wait(media.map((asset) async {
        final Uint8List? thumbnailData =
            await asset.thumbnailDataWithSize(const ThumbnailSize(150, 150));
        return GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FileView(
                        asset: asset,
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
        title: const Text('Images'),
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
              return _mediaList[index];
            } else {
              return const Center(
                child: CircularProgressIndicator(),
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
