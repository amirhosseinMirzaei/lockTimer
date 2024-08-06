import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(DetoxCloneApp());
}

class DetoxCloneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  static const platform = MethodChannel('com.example.timer/lock');
  Timer? _timer;
  int _start = 30; // Countdown seconds



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detox Clone"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _startLockDevice,
              child: Text("Lock Device"),
            ),
            if (_timer != null)
              Text(
                "$_start",
                style: TextStyle(fontSize: 48),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {

      SystemNavigator.pop();
      runApp(DetoxCloneApp());
    }
  }

  void _startLockDevice() {
    _startCountdown();
    _lockDevice();
  }

  void _startCountdown() {
    _start = 30;
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _unlockDevice();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future<void> _lockDevice() async {
    try {
      await platform.invokeMethod('startLockTask');
    } on PlatformException catch (e) {
      print("Failed to start lock task: '${e.message}'.");
    }
  }

  Future<void> _unlockDevice() async {
    try {
      await platform.invokeMethod('stopLockTask');
    } on PlatformException catch (e) {
      print("Failed to stop lock task: '${e.message}'.");
    }
  }
}

// ios code

// void main() {
//   runApp(DetoxCloneApp());
// }
//
// class DetoxCloneApp extends StatelessWidget with WidgetsBindingObserver{
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   static const platform = MethodChannel('com.example.timer/lock');
//   Timer? _timer;
//   int _start = 10; // Countdown seconds
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Detox Clone"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: _startLockDevice,
//               child: Text("Lock Device"),
//             ),
//             if (_timer != null)
//               Text(
//                 "$_start",
//                 style: TextStyle(fontSize: 48),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   void _startLockDevice() {
//     _startCountdown();
//     _lockDevice();
//   }
//
//   void _startCountdown() {
//     _start = 10;
//     const oneSec = const Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (_start == 0) {
//           setState(() {
//             timer.cancel();
//             _unlockDevice();
//           });
//         } else {
//           setState(() {
//             _start--;
//           });
//         }
//       },
//     );
//   }
//
//   Future<void> _lockDevice() async {
//     try {
//       await platform.invokeMethod('startLockTask');
//     } on PlatformException catch (e) {
//       print("Failed to start lock task: '${e.message}'.");
//     }
//   }
//
//   Future<void> _unlockDevice() async {
//     try {
//       await platform.invokeMethod('stopLockTask');
//     } on PlatformException catch (e) {
//       print("Failed to stop lock task: '${e.message}'.");
//     }
//   }
// }
