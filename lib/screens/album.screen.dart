import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../export/screen.export.dart';
import '../export/widget.export.dart';

class Album extends StatefulWidget {
  final GlobalKey<ScaffoldState> albumKey;

  const Album({Key? key, required this.albumKey}) : super(key: key);

  @override
  State<Album> createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
  List<AssetPathEntity> _albums = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }
 @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  Future<void> _fetchAlbums() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(type: RequestType.image);

      setState(() {
        _albums = albums;
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
        title: const Text('Albums',  style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: DefaultCircularLoader(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 15.0,
                ),
                itemCount: _albums.length,
                itemBuilder: (BuildContext context, int index) {
                  final album = _albums[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AlbumImage(
                                  album: album,
                                )),
                      );
                    },
                    child: GridTile(
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            child: FutureBuilder<List<AssetEntity>>(
                              future: album.getAssetListPaged(page: 0, size: 1),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const DefaultCircularLoader();
                                } else if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  return FutureBuilder<Uint8List?>(
                                    future: snapshot.data![0]
                                        .thumbnailDataWithSize(
                                            const ThumbnailSize(150, 150)),
                                    builder: (context, thumbSnapshot) {
                                      if (thumbSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const DefaultCircularLoader();
                                      } else if (thumbSnapshot.hasData) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                bottomRight:
                                                    Radius.circular(30),
                                              ),
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.3))),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomRight: Radius.circular(30),
                                            ),
                                            child: Image.memory(
                                              thumbSnapshot.data!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const Text(
                                          'Error',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  return const Text(
                                    'Error',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                }
                              },
                            ),
                          ),
                          Positioned.fill(
                              right: 10,
                              bottom: 10,
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            offset: const Offset(
                                              1.0,
                                              2.0,
                                            ),
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                    child: Text(
                                      album.name,
                                      style: const TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))),
                          Positioned.fill(
                            right: 10,
                            top: 10,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: FutureBuilder<int>(
                                future: album.assetCountAsync,
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const DefaultCircularLoader();
                                  } else if (snapshot.hasData) {
                                    return Container(
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          // shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              offset: const Offset(
                                                1.0,
                                                2.0,
                                              ),
                                              blurRadius: 1.0,
                                              spreadRadius: 1.0,
                                            ),
                                          ]),
                                      child: Text(
                                        '${snapshot.data}',
                                        style: const TextStyle(
                                          fontSize: 10.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  } else {
                                    return const Text(
                                      'Error',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
