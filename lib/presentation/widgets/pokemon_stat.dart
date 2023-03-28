import 'package:flutter/material.dart';
import 'package:pokedex_with_riverpod/data/models/pokemon_details.dart';
import 'package:pokedex_with_riverpod/shared/utils/utils.dart';

class PokemonStat extends StatefulWidget {
  final Stat stat;
  final int index;
  const PokemonStat({Key? key, required this.stat, required this.index})
      : super(key: key);

  @override
  State<PokemonStat> createState() => _PokemonStatState();
}

class _PokemonStatState extends State<PokemonStat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: ((widget.index + 1) * 200)));
  late final Animation<Offset> _slideAnimation =
      Tween<Offset>(begin: const Offset(-1.5, 0), end: const Offset(0, 0))
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(children: [
          Row(
            children: [
              Text(
                widget.stat.name.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 14),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                widget.stat.baseStat.toString(),
                style: Theme.of(context).textTheme.headline4,
              )
            ],
          ),
          const SizedBox(
            height: 7,
          ),
          LinearProgressIndicator(
            value: (widget.stat.baseStat.toDouble() / 100),
            backgroundColor: Colors.grey[200],
            color: getColor((widget.stat.baseStat.toDouble() / 100)),
          )
        ]),
      ),
    );
  }
}
