import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  bool continueAnimation = true;
  Animation<double> sizeAnimation;
  Animation<Color> colorAnimation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    // creates a controller that takes advantage of the [Ticker] vended by [SingleTickerProviderStateMixin]
    animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    // an [Animatable] that determines the values to select from for an [Animation]
    Tween<double> sizeTween = Tween(
      begin: 100,
      end: 300,
    );

    Tween<Color> colorTween = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    );

    // create an [Animation] by transforming values from another [Animation] object
    // into the one needed by this object
    sizeAnimation = sizeTween.animate(animationController);
    colorAnimation = colorTween.animate(animationController);

    // create a listener to this newly created animation
    animationController.addListener(() {
      setState(() {
        // triggers setState every time the animation value updates
      });
    });

    // starts the [Animation] of animationController
    start();
  }

  void start() {
    if (animationController.status == AnimationStatus.reverse) {
      animationController.reverse()
        .then((_) {
          start();
        });
    } else {
      animationController.forward()
        .then((_) {
          return animationController.reverse();
        })
        .then((_) {
          start();
        });
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              height: 300,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorAnimation.value,
                  ),
                  width: sizeAnimation.value,
                  height: sizeAnimation.value,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
            OutlineButton(
              onPressed: () {
                setState(() {
                  continueAnimation = !continueAnimation;
                  if (continueAnimation) {
                    start();
                  } else if (!continueAnimation) {
                    animationController.stop();
                  }
                });
              },
              child: Text('Toggle animation'),
            ),
          ],
        ),
      ),
    );
  }
}
