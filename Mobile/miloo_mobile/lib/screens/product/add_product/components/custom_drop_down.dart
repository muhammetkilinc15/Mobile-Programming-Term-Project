import 'package:flutter/material.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<SelectedListItem> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DropDownState(
          dropDown: DropDown(
            dropDownBackgroundColor: Colors.grey[100] ?? Colors.grey,
            bottomSheetTitle: Text(label),
            data: items,
            listItemBuilder: (index, dataItem) {
              return ListTile(
                title: Text(dataItem.data['name']),
              );
            },
            onSelected: (selectedList) {
              if (selectedList.isNotEmpty) {
                onChanged(selectedList.first.data['name']);
              }
            },
          ),
        ).showModal(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value ?? label),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
