import 'package:flutter/material.dart';
import 'package:swipe_card/swipe%20card/swipe_card.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  final controller = TinderCardPagerController();
  final items = List.generate(6, (i) => i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tinder-like Swipe Pager')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: 360,
            height: 520,
            child: TinderCardPager(
              itemCount: items.length,
              controller: controller,
              visibleStack: 1, // 👈 Show only ONE card like Tinder

              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        child: Image.network(
                          "https://picsum.photos/400/300?random=$index",
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "Custom Card #$index",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "You can add ANY UI inside this card.",
                        textAlign: TextAlign.center,
                      ),

                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            debugPrint("Button pressed on $index");
                          },
                          child: const Text("Custom Button"),
                        ),
                      )
                    ],
                  ),
                );
              },

              onSwipe: (index, dir) {
                debugPrint('Swiped card $index → $dir');
              },
            ),
          ),
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'left',
            child: const Icon(Icons.close),
            onPressed: () => controller.swipeLeft(),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'right',
            child: const Icon(Icons.favorite),
            onPressed: () => controller.swipeRight(),
          ),
        ],
      ),
    );
  }
}
