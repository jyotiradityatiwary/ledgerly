import 'package:flutter/material.dart';

class ContentContainer extends StatelessWidget {
  final Widget child;
  const ContentContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: child,
      ),
    );
  }
}

class ContentList extends StatelessWidget {
  final List<Widget> children;
  const ContentList({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) => Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600.0),
          child: children[index],
        ),
      ),
      separatorBuilder: (context, index) => const SizedBox(
        height: 8.0,
      ),
      itemCount: children.length,
      padding: const EdgeInsetsDirectional.symmetric(vertical: 8.0),
    );
  }
}
