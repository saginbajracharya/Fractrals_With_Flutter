import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Fractrals'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  double _progress = 0.01;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    const curve = Cubic(.49, 0, .04, 1);
    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    final Animation<double> curveAnimation = CurvedAnimation(parent: controller, curve: curve);
    animation = Tween<double>(begin: 0.01, end: 0.26).animate(curveAnimation)
      ..addListener(() => _onSliderChanged(animation.value))
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    // controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: TreePainter(_progress),
              ),
            ),
          ),
          Flexible(
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: TreePainter2(_progress),
              ),
            ),
          ),
          Slider(
            value: _progress,
            min: 0.01,
            max: 0.26,
            onChanged: (value) {
              setState(() {
                _progress = value;
              });
            },
          ),
          const SizedBox(
            height: 24,
          )
        ],
      ),
      // implement BottomAppBar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white38,
        elevation: 5,
        notchMargin: 2,
        // make rounded corners & create a notch for the floating action button
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            side: BorderSide(width: 2, color: Colors.blue),
          ),
          CircleBorder(),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red, // Set the button's text color
                  disabledForegroundColor: Colors.red, // Set the button's outline color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Set the button's border radius
                  ),
                  side: const BorderSide(color: Colors.red), // Set the button's outline border color
                ),
                child: const Text('Tree'),
                onPressed: () {

                }, 
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green, // Set the button's text color
                  disabledForegroundColor: Colors.green, // Set the button's outline color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Set the button's border radius
                  ),
                  side: const BorderSide(color: Colors.green), // Set the button's outline border color
                ),
                child: const Text('Pri'),
                onPressed: () {}, 
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
      // implement the big floating action button
      // floatingActionButton: FloatingActionButton.small(
      //   onPressed: () {},
      //   backgroundColor: Colors.red,
      //   child: const Icon(Icons.add),
      // ),
      // position the floating action button
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _onSliderChanged(double progress) {
    setState(() {
      _progress = progress;
    });
  }
}

class TreePainter extends CustomPainter {
  final double progress;
  static const int _depth = 12;

  TreePainter(this.progress);

  static const degToRed = math.pi / 180.0;
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final lineLength = math.min(size.width, size.height) * 0.008;
    final x = size.width / 2;
    final y = size.height * 0.8;
    _drawTree(canvas, x, y, -90, 90 * progress, _depth, lineLength);
  }

  void _drawTree(Canvas canvas, double x1, double y1, double angle,
      double offset, int depth, double lineLength) {
    if (depth != 0) {
      _paint
        ..strokeWidth = depth * 0.2
        ..color = _colors[(depth % _colors.length)];
      final x2 = x1 + (math.cos(angle * degToRed) * depth * lineLength);
      final y2 = y1 + (math.sin(angle * degToRed) * depth * lineLength);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), _paint);
      _drawTree(canvas, x2, y2, angle - offset, offset, depth - 1, lineLength);
      _drawTree(canvas, x2, y2, angle + offset, offset, depth - 1, lineLength);
    }
  }

  final _colors = [
    const Color(0xFF70d6ff),
    const Color(0xFFff70a6),
    const Color(0xffff006e),
    const Color(0xff3a86ff),
    const Color(0xffffbe0b),
    const Color(0xff39ff14),
  ];

  @override
  bool shouldRepaint(TreePainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class TreePainter2 extends CustomPainter {
  final double progress;
  static const int _depth = 12;

  TreePainter2(this.progress);

  static const degToRed = math.pi / 180.0;
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final lineLength = math.min(size.width, size.height) * 0.008;
    final x1 = size.width / 2;
    final y1 = size.height *0.1;
    _drawTree(canvas, x1, y1, 90, 90 * progress, _depth, lineLength);
  }

  void _drawTree(Canvas canvas, double x1, double y1, double angle,
      double offset, int depth, double lineLength) {
    if (depth != 0) {
      _paint
        ..strokeWidth = depth * 0.2
        ..color = _colors[(depth % _colors.length)];
      final x2 = x1 + (math.cos(angle * degToRed) * depth * lineLength);
      final y2 = y1 + (math.sin(angle * degToRed) * depth * lineLength);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), _paint);
      _drawTree(canvas, x2, y2, angle - offset, offset, depth - 1, lineLength);
      _drawTree(canvas, x2, y2, angle + offset, offset, depth - 1, lineLength);
    }
  }

  final _colors = [
    const Color(0xFF70d6ff),
    const Color(0xFFff70a6),
    const Color(0xffff006e),
    const Color(0xff3a86ff),
    const Color(0xffffbe0b),
    const Color(0xff39ff14),
  ];

  @override
  bool shouldRepaint(TreePainter2 oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

