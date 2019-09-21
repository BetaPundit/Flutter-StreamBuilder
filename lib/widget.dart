
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AdviceBarModel {
	Stream<String> get messageStream;
	String get initialMessage;
	Stream<int> get countStream;
	int get initialCount;
}

class AdviceBar extends StatelessWidget {
	final AdviceBarModel _adviceBarModel;
	
	AdviceBar (this._adviceBarModel);

  @override
  Widget build(BuildContext context) {
	return 	Center(
		child: Container(
			padding: EdgeInsets.all(32.0),
			child: Column(
				children: <Widget>[
				// Text 1 - advice
				Container(
					padding: EdgeInsets.all(16.0),
					child: StreamBuilder<String>(
						stream: _adviceBarModel.messageStream,
						initialData: _adviceBarModel.initialMessage,
						builder: (context, snapshot) {
							return Text(
								snapshot.data,
								style: TextStyle(
									fontSize: 20.0,
									color: Colors.black,
								),
							);
						}
					),
				),

				// Text 2 - counter
				StreamBuilder<int>(
					stream: _adviceBarModel.countStream,
					initialData: _adviceBarModel.initialCount,
					builder: (context, snapshot) {
						return Text(
							snapshot.data.toString(),
							style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
						);
					}
				),
				],
			),
		)
	);
  }

}

enum FabState {
	ACTIVE,
	INACTIVE
}
abstract class FabButtonModel {
	Stream<FabState> get fabStateStream;
	FabState get initialFabState;
}

abstract class FabButtonController {
	void fetchNewAdvice ();
}


class FabButton extends StatelessWidget {
  final FabButtonModel model;
  final FabButtonController controller;

  const FabButton(this.model, this.controller);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FabState> (
		stream: model.fabStateStream,
		initialData: model.initialFabState,
		builder: (context, snapshot) {
			var isActive = snapshot.data == FabState.ACTIVE; 
			return FloatingActionButton(
				child: isActive
					? Icon(Icons.file_download)
					: CircularProgressIndicator(
						backgroundColor: Colors.white,
					),
				onPressed: isActive ? controller.fetchNewAdvice : () {},
				backgroundColor: isActive ? Colors.blue : Colors.grey,
			);
		}
	);
  }

}