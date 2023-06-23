// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../utils/custom_style.dart';
import '../utils/dimension_utils.dart';
import '../utils/rgb_utils.dart';

class SearchDropdown extends StatefulWidget {
  String value;
  List items;
  String id;
  String name;
  SearchDropdown({super.key, required this.value, required this.items, required this.id, required this.name});

  @override
  State<SearchDropdown> createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: Dimension.defaultSize,
      ),
      decoration: BoxDecoration(
        color: RGB.secondaryColor,
        borderRadius: BorderRadius.circular(
          Dimension.defaultSize / 2,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          style: CustomStyle.hintTextStyle,
          isExpanded: true,
          hint: Text(
            'Select Item',
            style: CustomStyle.hintTextStyle,
          ),
          items: widget.items.map((item) => DropdownMenuItem<String>(
            value: item[widget.id],
            child: Text(
              "${item[widget.name]}",
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          )).toList(),
          value: widget.value,
          onChanged: (value) {
            
            setState(() {
              widget.value = value as String;
            });
          },
          buttonStyleData: const ButtonStyleData(
            height: 40,
            width: 200,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(color: Colors.black)
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: textEditingController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Search for an item...',
                  hintStyle: CustomStyle.hintTextStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              /*
              for (var i = 0; i < widget.items.length;) {
                return (widget.items[i][widget.name].toString().toLowerCase().contains(searchValue.toLowerCase()));
              }
              */
              //return false;
              
              return (item.value.toString().contains(searchValue));
            },
          ),
          //This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textEditingController.clear();
            }
          },
        ),
      )
    );
  }
}

////////////////////////////////////

class DropdownTitle extends StatefulWidget {
  String title;
  DropdownTitle({super.key, required this.title});

  @override
  State<DropdownTitle> createState() => _DropdownTitleState();
}

class _DropdownTitleState extends State<DropdownTitle> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        widget.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12
        ),
      ),
    );
  }
}

////////////////////////////////////////
