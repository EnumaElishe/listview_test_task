import 'dart:math';

import 'package:flutter/material.dart';
import 'package:listview_test_task/card_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Randomize'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CardModel> _models = [];

  static const List _colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blueAccent,
    Colors.lightGreen,
  ];

  Color get _randomColor => _colors[Random().nextInt(_colors.length)];

  void _generateContainers() {
    _models = List.generate(
      Random().nextInt(21),
      (index) => CardModel(
        'Card ${index + 1}',
        _randomColor,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: OutlinedButton(
          onPressed: _generateContainers,
          child: Text(
            'Randomize: ${_models.length}',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500.0,
        ),
        child: ListView.builder(
            itemCount: _models.length,
            itemBuilder: (_, index) {
              if ((index + 2) % 3 == 0) {
                return const SizedBox.shrink();
              }
              final nextExists = index < _models.length - 1;
              final isNotThird = (index + 1) % 3 != 0;
              final hasNeighbour = nextExists && isNotThird;
              return _buildRow(
                index: index,
                hasNeighbour: hasNeighbour,
              );
            }),
      ),
    );
  }

  Widget _buildRow({
    required int index,
    required hasNeighbour,
  }) {
    return Row(
      children: [
        _CardContainer(
          cardModel: _models[index],
          extended: !hasNeighbour,
        ),
        if (hasNeighbour) _CardContainer(cardModel: _models[++index]),
      ],
    );
  }
}

class _CardContainer extends StatelessWidget {
  final CardModel cardModel;
  final bool extended;

  const _CardContainer({
    required this.cardModel,
    this.extended = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: extended ? 2.5 : 1,
        child: Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: cardModel.color,
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Center(
            child: Text(
              cardModel.title,
            ),
          ),
        ),
      ),
    );
  }
}
