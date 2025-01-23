import 'package:flutter/material.dart';
import 'package:miloo_mobile/size_config.dart';

class StoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int? initialCategoryId;
  final Function(String) onSortChanged;
  final String currentSort;

  const StoreAppBar({
    Key? key,
    this.initialCategoryId,
    required this.onSortChanged,
    required this.currentSort,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Store'),
      leading: _buildLeading(context),
      actions: [_buildSortDropdown()],
    );
  }

  Widget _buildLeading(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
      child: initialCategoryId != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            )
          : _buildLogo(),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
      child: ClipOval(
        child: Image.asset(
          'assets/logo/logo.jpeg',
          width: getProportionateScreenWidth(50),
          height: getProportionateScreenHeight(50),
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButton<String>(
      value: currentSort,
      underline: const SizedBox(),
      icon: const Icon(Icons.sort, color: Colors.white),
      items: const [
        DropdownMenuItem(value: 'popular', child: Text('Popular')),
        DropdownMenuItem(value: 'price-low', child: Text('price-low')),
        DropdownMenuItem(value: 'price-high', child: Text('price-high')),
        DropdownMenuItem(value: 'newest', child: Text('Newest')),
      ],
      onChanged: (value) => value != null ? onSortChanged(value) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
