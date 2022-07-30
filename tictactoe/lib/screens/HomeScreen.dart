import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:math' as math;
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

class ConfigData {
	double maxAxisSize; // Axis size at which scaling stops
	double fontWidthDivisionMin; // Width division allocated to font size for smallest widths
	double fontWidthDivisionMax; // Width division allocated to font size for largest widths
	double straplineFontSizeDivision; // Strapline font size division of Title
	List<Color> colours; // Colours for game (length: 2)
	Color colourActive; // Primary colour
	Color colourInactive; // Secondary colour
	Color colourContrast; // Background colour
	String stringTitle;
	String stringStrapline;
	TextStyle baseTextStyle;
	double textPadding;
	double dotLargeAxisDivision; // Largest dot division of smallest axis size
	double largeDotGapDivision; // Division of smallest axis size used to divide large dots

	ConfigData ({
		this.maxAxisSize,
		this.fontWidthDivisionMin,
		this.fontWidthDivisionMax,
		this.straplineFontSizeDivision,
		this.colours,
		this.colourActive,
		this.colourInactive,
		this.colourContrast,
		this.stringTitle,
		this.stringStrapline,
		this.baseTextStyle,
		this.textPadding,
		this.dotLargeAxisDivision,
		this.largeDotGapDivision,
	});

	ConfigData withUpdates ({
		double maxAxisSize,
		double fontWidthDivisionMin,
		double fontWidthDivisionMax,
		double straplineFontSizeDivision,
		List<Color> colours,
		Color colourActive,
		Color colourInactive,
		Color colourContrast,
		String stringTitle,
		String stringStrapline,
		TextStyle baseTextStyle,
		double textPadding,
		double dotLargeAxisDivision,
		double largeDotGapDivision,
	}) {
		return ConfigData (
			maxAxisSize: maxAxisSize ?? this.maxAxisSize,
			fontWidthDivisionMin: fontWidthDivisionMin ?? this.fontWidthDivisionMin,
			fontWidthDivisionMax: fontWidthDivisionMax ?? this.fontWidthDivisionMax,
			straplineFontSizeDivision: straplineFontSizeDivision ?? this.straplineFontSizeDivision,
			colours: colours ?? this.colours,
			colourActive: colourActive ?? this.colourActive,
			colourInactive: colourInactive ?? this.colourInactive,
			colourContrast: colourContrast ?? this.colourContrast,
			stringTitle: stringTitle ?? this.stringTitle,
			stringStrapline: stringStrapline ?? this.stringStrapline,
			baseTextStyle: baseTextStyle ?? this.baseTextStyle,
			textPadding: textPadding ?? this.textPadding,
			dotLargeAxisDivision: dotLargeAxisDivision ?? this.dotLargeAxisDivision,
			largeDotGapDivision: largeDotGapDivision ?? this.largeDotGapDivision,
		);
	}
}

ConfigData DefaultConfig = ConfigData (
	maxAxisSize: 1600,
	fontWidthDivisionMin: 5,
	fontWidthDivisionMax: 10,
	straplineFontSizeDivision: 2,
	colours: [Colors.orange, Colors.lightBlue],
	stringTitle: 'Tip Tap Toe',
	// stringStrapline: 'choose a colour',
	stringStrapline: 'how many players?',
	baseTextStyle: GoogleFonts.caveat(),
	textPadding: 15,
	dotLargeAxisDivision: 3,
	largeDotGapDivision: 6,
);

ConfigData DefaultConfigDark = DefaultConfig.withUpdates (
	colourActive: Colors.grey[300],
	colourInactive: Colors.grey[800],
	colourContrast: Colors.grey[850],
);

ConfigData DefaultConfigLight = DefaultConfig.withUpdates (
	colourActive: Colors.grey[800],
	colourInactive: Colors.grey[500],
	colourContrast: Colors.grey[300],
);

ConfigData AbstractConfigDark = DefaultConfigDark.withUpdates (
	colours: [Colors.red, Colors.blue],
);

ConfigData AbstractConfigLight= DefaultConfigLight.withUpdates (
	colours: [Colors.red, Colors.blue],
);

ConfigData Config = DefaultConfigDark;
// ConfigData Config = AbstractConfigDark;

class HomeScreen extends StatefulWidget {
	final List<Color> colours;
	final String headlineText;
	final String straplineText;
	final TextStyle headlineTextStyle;
	final TextStyle straplineTextStyle;

	HomeScreen ({
		Key key,
		this.colours,
		this.headlineText,
		this.straplineText,
		this.headlineTextStyle,
		this.straplineTextStyle,
	}) : super(key: key);

	@override
    HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
	AnimationController animationController;
    Animation<double> animation;

	double distance = 0;

	 @override
    void initState() {
        super.initState();

		this.animationController = AnimationController (
			duration: Duration(milliseconds: 800),
			vsync: this,
        );

		Tween<double> distanceTween =  Tween<double>(
			begin: 0,
			// end: 250,
			end: 350,
			// end: 30,
		);

		this.animation = distanceTween.animate(this.animationController);

		this.animation.addListener(() {
			// int currentParticleIndex = this.animation.value;

			// if (currentParticleIndex != this._currentParticleIndex) {
			// 	this._currentParticleIndex = currentParticleIndex;

			// 	AnimatedParticle animatedParticle = this.animatedParticles[currentParticleIndex];
			// 	Particle particle = animatedParticle.particle;

			// 	particle.offset = Offset (
			// 		math.Random().nextDouble() * MediaQuery.of(context).size.width,
			// 		math.Random().nextDouble() * MediaQuery.of(context).size.height,
			// 	);

			// 	animatedParticle.startAnimation();
			// }

			// print(this.animation.value);

			

			setState(() {
				this.distance = this.animation.value;
			});
		});

		this.animation.addStatusListener((status) {
			if (status == AnimationStatus.completed) {
				this.animationController.reverse();
			}
			if (status == AnimationStatus.dismissed) {
					this.animationController.forward();
				}

			setState(() {});
		});

		this.animationController.forward();

		// async.Timer(this._animationDelay, this.lifecycleAnimationController.forward);
	}

	@override
    void dispose() {
		this.animationController.dispose();
		super.dispose();
    }

	@override
	Widget build(BuildContext context) {
		double screenWidth = MediaQuery.of(context).size.width;
		double screenHeight = MediaQuery.of(context).size.height;

		// dont argue with the maths (linear scale bound between 0 - maxScreenWidth): a=5, b=12, c=1600, y = (x/b-x/a)x/c+x/a [desmos]

		double axisSize = [
			screenWidth,
			screenHeight,
			Config.maxAxisSize,
		].reduce(math.min);

		double fontSize = ((((axisSize / Config.fontWidthDivisionMax) - (axisSize / Config.fontWidthDivisionMin)) / Config.maxAxisSize) * axisSize) + (axisSize / Config.fontWidthDivisionMin);

		return Scaffold (
			backgroundColor: Config.colourContrast,
			body: GestureDetector (
				behavior: HitTestBehavior.opaque,
				onTapUp: (details) {
					// Navigator.of(context).pushReplacement (
					// 	CrossFadePageRoute (
					// 		exitPage: this,
					// 		enterPage: ParticlesScreen(),
					// 	)
					// );

					double tapDx = details.globalPosition.dx;
					double tapDy = details.globalPosition.dy;

					double screenWidth = MediaQuery.of(context).size.width;
					double screenHeight = MediaQuery.of(context).size.height;

					double axisSize = [
						screenWidth,
						screenHeight,
						Config.maxAxisSize,
					].reduce(math.min);

					double largeDotRadius = axisSize / Config.dotLargeAxisDivision / 2;
					double gapSize = screenWidth - axisSize / Config.largeDotGapDivision;

					Offset dotLeftOffset = Offset (
						gapSize / 2 - largeDotRadius,
						screenHeight / 2,
					);
					Offset dotRightOffset = Offset (
						(screenWidth - gapSize / 2) + largeDotRadius,
						screenHeight / 2,
					);

					double leftDotOriginTapDistance = math.sqrt(math.pow(tapDx - dotLeftOffset.dx, 2) + math.pow(tapDy - dotLeftOffset.dy, 2));
					double rightDotOriginTapDistance = math.sqrt(math.pow(tapDx - dotRightOffset.dx, 2) + math.pow(tapDy - dotRightOffset.dy, 2));

					Color chosenColour;

					if (leftDotOriginTapDistance <= largeDotRadius) {
						chosenColour = Config.colours[0];
					}

					if (rightDotOriginTapDistance <= largeDotRadius) {
						chosenColour = Config.colours[1];
					}

					if (chosenColour != null) {
						print('Next stage... (${chosenColour})');
					}
				},
				child: CustomPaint (
					foregroundPainter: HomePainter (
						// controller: this.animationController,
						distance: this.distance,
					),
					child:
					// child: AnimatedOpacity (
					// 	opacity: this.inGame ? 0 : 1,
						// duration: Duration(seconds: 3),
						Center (
							child: Column (
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
									Expanded (
										child: Container (
											// alignment: Alignment.bottomCenter,
											alignment: Alignment.center,
											padding: EdgeInsets.only (
												// bottom: Config.textPadding,
											),
											child: Text (
												Config.stringTitle,
												style: Config.baseTextStyle.copyWith (
													color: Config.colourActive,
													fontSize: fontSize,
												),
											),
										)
									),
									Expanded (
										child: Container(),
									),
									Expanded (
										child: Container (
											alignment: Alignment.center,
											child: Text (
												Config.stringStrapline,
												style: Config.baseTextStyle.copyWith (
													color: Config.colourInactive,
													fontSize: fontSize / Config.straplineFontSizeDivision,
												),
											)
										)
									),
								],
							),
						),
				),
			),
		);
	}
}

class HomePainter extends CustomPainter {
	// AnimationController controller;

	// HomePainter({this.controller});

	double distance;

	HomePainter({this.distance});

    @override
    void paint(Canvas canvas, Size canvasSize) {
		Paint paint = new Paint();

        paint.strokeCap = StrokeCap.round;
        paint.style = PaintingStyle.fill;

		paint.color = Config.colours[0];

		double canvasWidth = canvasSize.width;
		double canvasHeight = canvasSize.height;

		double axisSize = [
			canvasWidth,
			canvasHeight,
			Config.maxAxisSize,
		].reduce(math.min);

		double largeDotRadius = axisSize / Config.dotLargeAxisDivision / 2;
		double gapSize = canvasWidth - axisSize / Config.largeDotGapDivision;


		// The two main large circles
		/*
        canvas.drawCircle (
			Offset (
				gapSize / 2 - largeDotRadius,
				canvasHeight / 2,
			),
			largeDotRadius,
			paint,
		);

		paint.color = Config.colours[1];

		canvas.drawCircle (
			Offset (
				(canvasWidth - gapSize / 2) + largeDotRadius,
				canvasHeight / 2,
			),
			largeDotRadius,
			paint,
		);
		*/











		// print(this.controller);

		// Testing
		// double radius = 100;
		double radius = largeDotRadius;
		double attraction = 10;
		// double attraction = 0;
		// double intersection = radius + 60;
		// double intersection = radius + this.controller.value;
		// double intersection = radius + this.distance;
		double intersection = this.distance;

		// Paint paintLeft = new Paint();
		// Paint paintRight = new Paint();
		Paint paintPrimary = new Paint();
		Paint paintMeta = new Paint();
		Paint paintContrast = new Paint();

        paintMeta.style = PaintingStyle.stroke;
		
		// paintPrimary.color = Colors.lightBlue;
		// paintPrimary.color = Colors.orange;
		// paintPrimary.color = Config.colourInactive;
		paintPrimary.color = Config.colourActive;
		paintMeta.color = Colors.blue;
		paintContrast.color = Colors.red;

		Paint paintLeft = paintPrimary;
		Paint paintRight = paintPrimary;

		// List<double> colourFilter = [
		// 1,  0,  0, 0, 0,
		// 0, 1,  0, 0, 0,
		// 0,  0, 1, 0, 0,
		// 0,  0,  0, 20, -7,
		// ];
		// List<double> colourFilter2 = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 20, -1200];
		// List<double> colourFilter2 = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 20, -255];
		// ImageFilter imageFilter = ImageFilter.blur(sigmaX: 13, sigmaY: 13);
		// ImageFilter imageFilter = ImageFilter.blur(sigmaX: 10, sigmaY: 10);

		// paint2.colorFilter = ColorFilter.matrix(colourFilter2);
		// paint3.colorFilter = ColorFilter.matrix(colourFilter2);
		// paint2.imageFilter = imageFilter;
		// paint2.maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

		// canvas.drawRect (
		// 	Rect.fromLTWH(0, 0, 600, 300),
		// 	paint3,
		// );

		// double offsetX = radius * 2;
		// double offsetY = radius * 2;

		double offsetX = canvasWidth / 2;
		double offsetY = canvasHeight / 2;

		offsetX = offsetX - distance / 2;
		distance = distance / 2;

		double x = offsetX + intersection / 2;
		double y = math.sqrt(math.pow(radius, 2) - math.pow(x, 2) + 2 * x * offsetX - math.pow(offsetX, 2));

		double overlapRadius = radius - intersection / 2 + attraction;

		canvas.drawCircle (
			Offset (
				offsetX,
				offsetY,
			),
			radius,
			paintLeft,
		);

		canvas.drawCircle (
			Offset (
				offsetX + intersection,
				offsetY,
			),
			radius,
			paintRight,
		);

		if (intersection >= radius * 2 + attraction - 1) {
			return;
		}

		// canvas.drawCircle (
		// 	Offset (
		// 		offsetX,
		// 		offsetY,
		// 	),
		// 	radius + attraction,
		// 	paintMeta,
		// );

		// canvas.drawCircle (
		// 	Offset (
		// 		offsetX + intersection,
		// 		offsetY,
		// 	),
		// 	radius + attraction,
		// 	paintMeta,
		// );

		// canvas.drawCircle (
		// 	Offset (
		// 		offsetX + intersection / 2,
		// 		offsetY,
		// 	),
		// 	radius - intersection / 2 + attraction,
		// 	paintMeta,
		// );

		// canvas.drawCircle (
		// 	Offset (
		// 		offsetX + intersection / 2,
		// 		y - attraction / 2, // to be determined
		// 	),
		// 	// (intersection - (intersection - radius) - (intersection - radius)) / 2 + attraction,
		// 	radius - intersection / 2 + attraction,
		// 	paintContrast,
		// );

		double theta = math.acos((intersection / 2) / (radius + overlapRadius));
		double dy = math.sin(theta) * (radius + overlapRadius);

		double superOffsetX = offsetX + intersection / 2;
		double superOffsetY = offsetY  - dy;
		double superBottomOffsetY = offsetY  + dy;

		double intersectionCircleRadius = (intersection - (intersection - radius) - (intersection - radius)) / 2 + attraction;

		// Offset centreOfIntersectionOffset = Offset (
		// 	offsetX + radius,
		// 	// 2 * offsetY - (y - attraction / 2), // Not working :/
		// 	offsetY, // Not working :/
		// );

		// canvas.drawCircle(centreOfIntersectionOffset, 20, paintMeta);

		Offset centreOfIntersectionOffset = Offset (
			offsetX + intersection / 2,
			offsetY,
		);

		/*canvas.drawCircle (
			Offset (
				superOffsetX,
				// 2 * offsetY - (y - attraction / 2), // Not working :/
				superOffsetY, // Not working :/
			),
			(intersection - (intersection - radius) - (intersection - radius)) / 2 + attraction,
			paintContrast,
		);

		canvas.drawCircle (
			Offset (
				superOffsetX,
				// 2 * offsetY - (y - attraction / 2), // Not working :/
				superBottomOffsetY, // Not working :/
			),
			(intersection - (intersection - radius) - (intersection - radius)) / 2 + attraction,
			paintContrast,
		);*/

		double distX = intersection / 2;
		double distY = offsetY - superOffsetY;
		double scalar = intersectionCircleRadius / (radius + intersectionCircleRadius);
		double scaledDistX = scalar * distX;
		double scaledDistY = scalar * distY;

		/*canvas.drawLine (
			Offset (
				offsetX,
				offsetY,
			),
			Offset (
				offsetX + distX,
				offsetY,
			),
			paintMeta,
		);

		canvas.drawLine (
			Offset (
				superOffsetX,
				offsetY,
			),
			Offset (
				superOffsetX,
				offsetY - distY,
			),
			paintMeta,
		);

		canvas.drawLine (
			Offset (
				offsetX,
				offsetY,
			),
			Offset (
				superOffsetX,
				superOffsetY,
			),
			paintMeta,
		);*/

		/////////////////
		
		/*canvas.drawLine (
			Offset (
				superOffsetX,
				offsetY - distY,
			),
			Offset (
				superOffsetX,
				offsetY - distY + scaledDistY,
			),
			paintMeta,
		);

		canvas.drawLine (
			Offset (
				superOffsetX,
				offsetY - distY + scaledDistY,
			),
			Offset (
				superOffsetX - scaledDistX,
				offsetY - distY + scaledDistY,
			),
			paintMeta,
		);*/

		Offset offsetTLCircleMeetPoint = Offset (
			superOffsetX - scaledDistX,
			offsetY - distY + scaledDistY,
		);

		Offset offsetTRCircleMeetPoint = Offset (
			superOffsetX + scaledDistX,
			offsetY - distY + scaledDistY,
		);

		Offset offsetBLCircleMeetPoint = Offset (
			superOffsetX - scaledDistX,
			offsetY + distY - scaledDistY,
		);

		Offset offsetBRCircleMeetPoint = Offset (
			superOffsetX + scaledDistX,
			offsetY + distY - scaledDistY,
		);

		// canvas.drawCircle(offsetTLCircleMeetPoint, 10, paintMeta);
		// canvas.drawCircle(offsetTRCircleMeetPoint, 10, paintMeta);
		// canvas.drawCircle(offsetBLCircleMeetPoint, 10, paintMeta);
		// canvas.drawCircle(offsetBRCircleMeetPoint, 10, paintMeta);

		/*canvas.drawRect (
			Rect.fromPoints (
				offsetTLCircleMeetPoint,
				Offset (
					superOffsetX + scaledDistX,
					superOffsetY + intersectionCircleRadius,
				),
			),
			paintMeta,
		);*/

		/*canvas.drawArc (
			Rect.fromPoints (
				offsetTLCircleMeetPoint,
				Offset (
					superOffsetX + scaledDistX,
					superOffsetY + intersectionCircleRadius,
				),
			),
			math.pi,
			- math.pi,
			false,
			paintMeta
		);*/

		double angleArcStart = math.atan(scaledDistY / scaledDistX);
		double angleArcStartBottom = - angleArcStart;
		double angleArcStop = math.pi - angleArcStart * 2;
		double angleArcStopBottom = - math.pi - angleArcStartBottom * 2;


		// Working gooey bounds!
		/*
		canvas.drawArc (
			Rect.fromCircle (
				center: Offset (
					superOffsetX,
					superOffsetY,
				),
				radius: intersectionCircleRadius,
			),
			angleArcStart,
			angleArcStop,
			false,
			paintMeta
		);

		canvas.drawArc (
			Rect.fromCircle (
				center: Offset (
					superOffsetX,
					superBottomOffsetY,
				),
				radius: intersectionCircleRadius,
			),
			angleArcStartBottom,
			angleArcStopBottom,
			false,
			paintMeta
		);

		canvas.drawLine (
			offsetTLCircleMeetPoint,
			offsetBLCircleMeetPoint,
			paintMeta,
		);

		canvas.drawLine (
			offsetTRCircleMeetPoint,
			offsetBRCircleMeetPoint,
			paintMeta,
		);
		*/

		Path path = Path();

		path.moveTo(offsetTRCircleMeetPoint.dx, offsetTRCircleMeetPoint.dy);
		path.arcTo (
			Rect.fromCircle (
				center: Offset (
					superOffsetX,
					superOffsetY,
				),
				radius: intersectionCircleRadius,
			),
			angleArcStart,
			angleArcStop,
			false,
		);
		path.lineTo (
			offsetTLCircleMeetPoint.dx,
			centreOfIntersectionOffset.dy,
		);
		path.lineTo (
			offsetTRCircleMeetPoint.dx,
			centreOfIntersectionOffset.dy,
		);

		path.close();

		canvas.drawPath(path, paintLeft);

		Path path2 = Path();

		path2.moveTo(offsetBRCircleMeetPoint.dx, offsetBRCircleMeetPoint.dy);
		path2.arcTo (
			Rect.fromCircle (
				center: Offset (
					superOffsetX,
					superBottomOffsetY,
				),
				radius: intersectionCircleRadius,
			),
			angleArcStartBottom,
			angleArcStopBottom,
			false,
		);
		path2.lineTo (
			offsetBLCircleMeetPoint.dx,
			centreOfIntersectionOffset.dy,
		);
		path2.lineTo (
			offsetBRCircleMeetPoint.dx,
			centreOfIntersectionOffset.dy,
		);

		path2.close();

		canvas.drawPath(path2, paintLeft);

		/*path.moveTo(offsetBRCircleMeetPoint.dx, offsetBRCircleMeetPoint.dy);

		path.arcTo (
			Rect.fromCircle (
				center: Offset (
					superOffsetX,
					superBottomOffsetY,
				),
				radius: intersectionCircleRadius,
			),
			angleArcStartBottom,
			angleArcStopBottom,
			false,
		);*/
		// path.lineTo (
		// 	offsetTRCircleMeetPoint.dx,
		// 	offsetTRCircleMeetPoint.dy,
		// );

		// path.lineTo(offsetTLCircleMeetPoint.dx + 50, offsetTLCircleMeetPoint.dy);
		// path.lineTo(offsetTLCircleMeetPoint.dx + 50, offsetTLCircleMeetPoint.dy + 50);
		// path.lineTo(offsetTLCircleMeetPoint.dx, offsetTLCircleMeetPoint.dy + 50);
		// path.lineTo(offsetTLCircleMeetPoint.dx, offsetTLCircleMeetPoint.dy);

		// path.close();

		// // canvas.drawPath(path, paintContrast);
		// canvas.drawPath(path, paintMeta);
		
		// canvas.drawLine (
		// 	Offset (
		// 		offsetX + distX,
		// 		offsetY,
		// 	),
		// 	Offset (
		// 		offsetX + distX - scaledDistX,
		// 		offsetY,
		// 	),
		// 	paintMeta,
		// );


		// NEXT Fun begins :))
		// https://www.raywenderlich.com/7560981-drawing-custom-shapes-with-custompainter-in-flutter
		// https://blog.usejournal.com/how-to-draw-custom-shapes-in-flutter-aa197bda94bf

		final p = Paint()..color = Colors.pink;
		double avatarRadius = 50;
		final shapeBounds = Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height - avatarRadius);

final centerAvatar = Offset(shapeBounds.center.dx, shapeBounds.bottom);
//2
final avatarBounds = Rect.fromCircle(center: centerAvatar, radius: avatarRadius);
  //2
  final backgroundPath = Path()
    ..moveTo(shapeBounds.left, shapeBounds.top) //3
    ..lineTo(shapeBounds.bottomLeft.dx, shapeBounds.bottomLeft.dy) //4
    ..arcTo(avatarBounds, -math.pi, math.pi, false) //5
    ..lineTo(shapeBounds.bottomRight.dx, shapeBounds.bottomRight.dy) //6
    ..lineTo(shapeBounds.topRight.dx, shapeBounds.topRight.dy) //7
    ..close(); //8

  //9
//   canvas.drawPath(backgroundPath, p);



	// Draw the two main large circles for reference
	canvas.drawCircle (
			Offset (
				gapSize / 2 - largeDotRadius,
				canvasHeight / 2,
			),
			largeDotRadius,
			paint,
		);

		paint.color = Config.colours[1];

		canvas.drawCircle (
			Offset (
				(canvasWidth - gapSize / 2) + largeDotRadius,
				canvasHeight / 2,
			),
			largeDotRadius,
			paint,
		);
    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate) => true;
}