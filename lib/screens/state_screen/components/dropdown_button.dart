import 'package:daxno_task/constants/colors.dart';
import 'package:daxno_task/widgets/text_style.dart';
import 'package:flutter/material.dart';

//class to update the account
class DropDownButtonAcc extends StatefulWidget {
  final List<String> item;
  final Function(String) onSelected;
  const DropDownButtonAcc(
      {Key? key, required this.item, required this.onSelected})
      : super(key: key);

  @override
  State<DropDownButtonAcc> createState() => _DropDownButtonAccState();
}

class _DropDownButtonAccState extends State<DropDownButtonAcc> {
  String? selectedName;

  @override
  void initState() {
    super.initState();

    // Set the default value to the first item in the list
    if (widget.item.isNotEmpty) {
      selectedName = widget.item[0];

      widget.onSelected(selectedName!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: const SizedBox(),
      dropdownColor: prussianBlue,
      menuMaxHeight: 250,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      value: selectedName,
      items: widget.item.map((String item) {
        return buildMenuItem(item);
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedName = newValue;
          widget.onSelected(newValue!);
        });
      },
      iconEnabledColor: greyColor,
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child:
          Center(child: normalText(text: item, color: greyColor, size: 16.0)),
    );
  }
}
