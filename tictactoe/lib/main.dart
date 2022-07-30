import 'package:flutter/material.dart';

import './screens/HomeScreen.dart';

void main() {
	runApp(App());
}

class App extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp (
			debugShowCheckedModeBanner: false,
			title: 'Tic Tac Toe',
			home: HomeScreen(),
		);
	}
}