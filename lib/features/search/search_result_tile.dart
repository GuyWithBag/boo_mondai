import 'package:flutter/material.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.onTap,
    this.selected = false,
    super.key,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final VoidCallback? onTap;
  final bool selected;

  static Widget buildSearchResult<TObject>(
    BuildContext context,
    TObject result,
    int index, {
    String? label,
    VoidCallback? onTap,
  }) {
    return SearchResultTile(
      onTap: onTap,
      title: Text(
        label ?? result.toString(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: leading ?? const Icon(Icons.search),
      onTap: onTap,
      selected: selected,
      title: title,
      subtitle: subtitle,
    );
  }
}
