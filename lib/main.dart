import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './pages/game_menu.dart';
import './pages/game_screen.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameMenu(),
    );
  }
}

// device preview mode

// void main() => runApp(
//       DevicePreview(
//         enabled: !kReleaseMode,
//         builder: (context) => MyApp(), // Wrap your app
//       ),
//     );

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       useInheritedMediaQuery: true,
//       locale: DevicePreview.locale(context),
//       builder: DevicePreview.appBuilder,
//       theme: ThemeData.light(),
//       darkTheme: ThemeData.dark(),
//       home: const GameScreen(),
//     );
//   }
// }
