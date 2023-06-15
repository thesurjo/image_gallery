import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../export/screen.export.dart';
import '../export/widget.export.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isLoading = true;
  bool isPass = false;
  Future<void> _checkStoragePermission() async {
    setState(() {
      isLoading = true;
    });
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      setState(() {
        isLoading = false;
        isPass = true;
      });
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
          (route) => false);
    } else {
      setState(() {
        isLoading = false;
        isPass = false;
      });
    }
  }

  @override
  void initState() {
    _checkStoragePermission();
    super.initState();
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
      body: isLoading
          ? const DefaultCircularLoader()
          : !isPass
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/noimage.png'),
                      const Text('Please allow permission from setting')
                    ],
                  ),
                )
              : const Center(),
    );
  }
}
