import 'package:flutter/material.dart';
import 'package:proj_1/core.dart';
import 'package:proj_1/db_and_api.dart';

import 'package:proj_1/widget.dart';

void main() async {
	var a = await CoreLogic.getInstance(
		await SharedPreferenceImplementation.getInstance(),
		OnlineApiImplementation()
	); 
	runApp(Home(a, a, a));
}

class Home extends StatelessWidget {
	final FabButtonModel _fabModel;
	final FabButtonController _fabController;
	final AdviceBarModel _adviceBarModel;

	Home(this._fabModel, this._fabController, this._adviceBarModel);
	
	@override
		Widget build(BuildContext context) {
			return MaterialApp(
					home: Scaffold(
						appBar: AppBar(
							title: Text('App 1'),
							centerTitle: true,
							),
						body: Center(
							child: Container(
								padding: EdgeInsets.all(32.0),
								child: AdviceBar(
									_adviceBarModel
								),
							),
						),

									// Floating button
						floatingActionButton: FabButton(
							_fabModel, _fabController
						)
					),
			);
		}
}
