// lib/tinder_card_pager.dart
import 'dart:math';
import 'package:flutter/material.dart';

enum SwipeCard { left, right, none }

class TinderCardPagerController {
  _TinderCardPagerState? _state;

  void _bind(_TinderCardPagerState s) => _state = s;

  void swipeLeft() => _state?._animateSwipe(SwipeCard.left);
  void swipeRight() => _state?._animateSwipe(SwipeCard.right);
}

class TinderCardPager extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Function(int, SwipeCard)? onSwipe;
  final TinderCardPagerController? controller;

  final int visibleStack;
  final double itemScale;
  final double itemOffset;
  final double maxRotation;
  final double swipeThreshold;

  const TinderCardPager({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onSwipe,
    this.controller,
    this.visibleStack = 3,
    this.itemScale = 0.04,
    this.itemOffset = 15,
    this.maxRotation = 0.25,
    this.swipeThreshold = 120,
  });

  @override
  _TinderCardPagerState createState() => _TinderCardPagerState();
}

class _TinderCardPagerState extends State<TinderCardPager>
    with TickerProviderStateMixin {   // ✅ FIXED HERE
  late AnimationController _controller;
  Offset _dragOffset = Offset.zero;
  double _rotation = 0.0;

  final List<int> _stack = [];
  int _topIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller?._bind(this);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    for (int i = 0; i < widget.visibleStack && i < widget.itemCount; i++) {
      _stack.add(i);
    }
  }

  double _calcRotation() {
    double width = context.size?.width ?? 300;
    return (_dragOffset.dx / width) * widget.maxRotation;
  }

  void _onPanStart(DragStartDetails d) {
    _controller.stop();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      _dragOffset += d.delta;
      _rotation = _calcRotation();
    });
  }

  void _onPanEnd(DragEndDetails d) {
    final th = widget.swipeThreshold;

    if (_dragOffset.dx.abs() > th) {
      final dir = _dragOffset.dx > 0 ? SwipeCard.right : SwipeCard.left;
      _animateSwipe(dir);
    } else {
      _restoreCard();
    }
  }

  void _restoreCard() {
    _controller.dispose();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    final tween = Tween<Offset>(begin: _dragOffset, end: Offset.zero);

    final anim = tween.animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    anim.addListener(() {
      setState(() {
        _dragOffset = anim.value;
        _rotation = _calcRotation();
      });
    });

    _controller.forward();
  }

  void _animateSwipe(SwipeCard dir) {
    final size = context.size ?? const Size(300, 500);
    final endX = dir == SwipeCard.right ? size.width * 1.5 : -size.width * 1.5;

    _controller.dispose();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    final slide = Tween<Offset>(
      begin: _dragOffset,
      end: Offset(endX, _dragOffset.dy),
    ).animate(_controller);

    final rotate = Tween<double>(
      begin: _rotation,
      end: dir == SwipeCard.right ? widget.maxRotation : -widget.maxRotation,
    ).animate(_controller);

    _controller.addListener(() {
      setState(() {
        _dragOffset = slide.value;
        _rotation = rotate.value;
      });
    });

    _controller.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        widget.onSwipe?.call(_topIndex, dir);
        _shiftCards();
      }
    });

    _controller.forward();
  }

  void _shiftCards() {
    setState(() {
      _topIndex++;
      _dragOffset = Offset.zero;
      _rotation = 0;

      _stack.clear();
      for (int i = 0;
      i < widget.visibleStack && (_topIndex + i) < widget.itemCount;
      i++) {
        _stack.add(_topIndex + i);
      }
    });
  }

  Widget _buildCard(int pos, int index) {
    bool isTop = pos == 0;

    double scale = 1.0 - (pos * widget.itemScale);
    double offset = pos * widget.itemOffset;

    Widget card = Transform.translate(
      offset: isTop ? _dragOffset : Offset(0, offset),
      child: Transform.rotate(
        angle: isTop ? _rotation : 0,
        child: Transform.scale(
          scale: scale,
          child: widget.itemBuilder(context, index),
        ),
      ),
    );

    if (isTop) {
      card = GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: card,
      );
    }

    return Positioned.fill(child: card);
  }

  @override
  Widget build(BuildContext context) {
    if (_topIndex >= widget.itemCount) {
      return const Center(child: Text("No more cards"));
    }

    List<Widget> children = [];

    for (int i = 0; i < _stack.length; i++) {
      children.add(_buildCard(i, _stack[i]));
    }

    return Stack(children: children);
  }
}
