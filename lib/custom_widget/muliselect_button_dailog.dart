import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/dynamic_screen_model/options_model.dart';
import '../style/styles.dart';

class MultiSelectButtonDialog extends StatefulWidget {
  final List<OptionsModel> items;
  final List<OptionsModel> selectedItem;
  final String? title;
  final String? selectAll;
  final String posButton;
  final String negButton;

  const MultiSelectButtonDialog({
    Key? key,
    required this.items,
    required this.selectedItem,
    this.title,
    this.selectAll,
    required this.posButton,
    required this.negButton,
  }) : super(key: key);

  @override
  _MultiSelectButtonDialogState createState() =>
      _MultiSelectButtonDialogState();
}

class _MultiSelectButtonDialogState extends State<MultiSelectButtonDialog> {
  final TextEditingController _searchController = TextEditingController();
  late Map<String, bool> checkedItem;
  late List<OptionsModel> _filteredItems;
  bool selectAll = false;

  @override
  void initState() {
    super.initState();

    // init checked items
    checkedItem = {
      for (var item in widget.items)
        item.name!: widget.selectedItem.any((e) => e.name == item.name)
    };

    _filteredItems = widget.items;
    selectAll = !checkedItem.containsValue(false);

    _searchController.addListener(() {
      filterSearchResults(_searchController.text);
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) =>
            (item.values ?? "").toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      for (var item in widget.items) {
        checkedItem[item.name!] = selectAll;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            // Title
            Container(
              height: 40,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color(0xff5979AA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
              ),
              child: Center(
                child: Text(widget.title ?? "Select Items",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),

            // 🔎 Search box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),

            // Select All
            _filteredItems.length>0?CheckboxListTile(
              title: Text(widget.selectAll ?? "Select All"),
              value: selectAll,
              onChanged: toggleSelectAll,
            ):SizedBox(),

            // List
            Expanded(
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  var item = _filteredItems[index];
                  return CheckboxListTile(
                    title: Text(item.values ?? "-"),
                    value: checkedItem[item.name] ?? false,
                    onChanged: (newValue) {
                      setState(() {
                        checkedItem[item.name!] = newValue!;
                        selectAll = !checkedItem.containsValue(false);
                      });
                    },
                  );
                },
              ),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffDB4B73)),
                      onPressed: () => Navigator.pop(context, null),
                      child: Text(widget.negButton,style:  Styles.white125),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff369A8D)),
                      onPressed: () {
                        final selected = widget.items
                            .where((e) => checkedItem[e.name] == true)
                            .toList();
                        Navigator.pop(context, selected);
                      },
                      child: Text(widget.posButton,style:  Styles.white125),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


