import 'package:flutter/material.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:miloo_mobile/models/university_model.dart';
import 'package:miloo_mobile/services/university_service.dart';

class CustomUniversities extends StatefulWidget {
  final String selectedUniversity;
  final ValueChanged<String> onSelected;
  final int selectedUniversityId;
  final ValueChanged<int>? onSelectedId; // Make this optional

  const CustomUniversities({
    super.key,
    required this.selectedUniversity,
    required this.selectedUniversityId,
    required this.onSelected,
    this.onSelectedId, // Make this optional
  });

  @override
  State<CustomUniversities> createState() => _CustomUniversitiesState();
}

class _CustomUniversitiesState extends State<CustomUniversities> {
  final UniversityService _universityService = UniversityService();
  List<SelectedListItem<University>> _universities = [];
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _fetchUniversities();
  }

  Future<void> _fetchUniversities() async {
    if (_isFetching) return;
    setState(() => _isFetching = true);

    try {
      final List<University> universities =
          await _universityService.getUniversity();
      setState(() {
        _universities = universities
            .map((university) => SelectedListItem<University>(
                  data: university, // Store the university object
                ))
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isFetching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 238, 236, 236)),
        color: Colors.grey[50],
      ),
      child: ListTile(
        onTap: () {
          DropDownState(
            dropDown: DropDown<University>(
              data: _universities,
              dropDownBackgroundColor: const Color.fromARGB(255, 232, 230, 230),
              bottomSheetTitle: Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "Select University",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Customize how the items in the list will look
              listItemBuilder: (index, selectedItem) {
                final University university = selectedItem.data;
                return ListTile(
                  title: Text(university.name), // Only show the university name
                );
              },
              onSelected: (List<dynamic> selectedList) {
                if (selectedList.isNotEmpty &&
                    selectedList.first is SelectedListItem) {
                  final SelectedListItem selectedItem =
                      selectedList.first as SelectedListItem<University>;
                  final University selectedUniversity =
                      selectedItem.data as University;

                  widget.onSelected(selectedUniversity.name);
                  if (widget.onSelectedId != null) {
                    widget.onSelectedId!(selectedUniversity.id);
                  }
                }
              },
            ),
          ).showModal(context);
        },
        leading: Icon(Icons.school_outlined, color: Colors.grey[600]),
        title: Text(widget.selectedUniversity.isNotEmpty
            ? widget.selectedUniversity
            : "Select a university"),
        trailing: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
      ),
    );
  }
}
