import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HarivaraApp extends StatefulWidget {
  const HarivaraApp({super.key});

  @override
  State<HarivaraApp> createState() => _HarivaraAppState();
}

class _HarivaraAppState extends State<HarivaraApp> {
  HarivarFieldController maxOnEachSide = HarivarFieldController(0);
  HarivarFieldController maxSelectionOnEachSde = HarivarFieldController(0);
  HarivarFieldController maxSelectionOfAlphabets = HarivarFieldController(0);
  HarivarFieldController maxSleectionOfNumbers = HarivarFieldController(0);

  var selectedAlphabets = <int, bool>{};
  var selectedNumbers = <int, bool>{};

  showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  _validate() {
    const max = 11;
    if (maxOnEachSide.value > max) {
      showMessage(
        "Only Max of $max select boxes can be Created,enter value less than or equal to $max",
      );
      maxOnEachSide.value = 11;
    }

    selectedAlphabets = Map.fromEntries(
        List.generate(maxOnEachSide.value, (index) => "0".codeUnitAt(0) + index)
            .map((e) => MapEntry(e, false)));
    selectedNumbers = Map.fromEntries(
        List.generate(maxOnEachSide.value, (index) => index)
            .map((e) => MapEntry(e, false)));

    if (maxSelectionOnEachSde.value > maxOnEachSide.value * 2) {
      showMessage(
          "You cannot enter value more than ${maxOnEachSide.value * 2} in max No of selections");
      maxSelectionOnEachSde.value = maxOnEachSide.value * 2;
    }

    if (maxSelectionOfAlphabets.value > maxOnEachSide.value) {
      showMessage(
        "You cannot enter value more than ${maxOnEachSide.value} in max No of alphabets",
      );
      maxSelectionOfAlphabets.value = maxOnEachSide.value;
    }
    if (maxSleectionOfNumbers.value > maxOnEachSide.value) {
      showMessage(
        "You cannot enter value more than ${maxOnEachSide.value} in max No of numbers",
      );
      maxSleectionOfNumbers.value = maxOnEachSide.value;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int get lengthOfSelectedNumbers =>
      selectedNumbers.entries.where((element) => element.value).length;
  int get lengthOfSelectedAlphabets =>
      selectedAlphabets.entries.where((element) => element.value).length;

  checkNumberSelection(Map<int, bool> old, Map<int, bool> neww) {
    final oldLen = old.entries.where((element) => element.value).length;
    final newLen = neww.entries.where((element) => element.value).length;
    if (oldLen < newLen) {
      if (checkBothSelection()) {
        return;
      }
      if (maxSleectionOfNumbers.value - (lengthOfSelectedNumbers) == 0) {
        showMessage("Unable to select as max no of Numbers reached");
        return;
      }
    }

    setState(() {
      selectedNumbers = neww;
    });
  }

  bool checkBothSelection() {
    if (maxSelectionOnEachSde.value -
            (lengthOfSelectedAlphabets + lengthOfSelectedNumbers) ==
        0) {
      showMessage("Unable to select as max no of selection reached");
      return true;
    }
    return false;
  }

  checkAlphabetSelection(Map<int, bool> old, Map<int, bool> neww) {
    final oldLen = old.entries.where((element) => element.value).length;
    final newLen = neww.entries.where((element) => element.value).length;
    if (oldLen < newLen) {
      if (checkBothSelection()) {
        return;
      }
      if (maxSelectionOfAlphabets.value - lengthOfSelectedAlphabets == 0) {
        showMessage("Unable to select as max no of Alphabets reached");
        return;
      }
    }
    setState(() {
      selectedAlphabets = neww;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: OutlinedButton.icon(
        onPressed: () {
          setState(() {
            maxOnEachSide.value = 0;
            maxSelectionOnEachSde.value = 0;
            maxSelectionOfAlphabets.value = 0;
            maxSleectionOfNumbers.value = 0;
          });
        },
        icon: const Icon(Icons.restore_page),
        label: const Text("RESET"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: HarivaraField(
              controller: maxOnEachSide,
              label: "Total no of boxes on each side",
              onChange: (i) {
                maxOnEachSide.value = i;
                setState(() {
                  _validate();
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: HarivaraField(
              controller: maxSelectionOnEachSde,
              label:
                  "Max no of total selections allowed for selecting on both sides",
              onChange: (i) {
                maxSelectionOnEachSde.value = i;
                setState(() {
                  _validate();
                });
              },
            ),
          ),
          ListTile(
            title: HarivaraField(
              controller: maxSelectionOfAlphabets,
              label: "Max no of alphabets allowed for selecting",
              onChange: (i) {
                maxSelectionOfAlphabets.value = i;
                setState(() {
                  _validate();
                });
              },
            ),
          ),
          ListTile(
            title: HarivaraField(
              controller: maxSleectionOfNumbers,
              label: "Max no of numbers allowed for selecting",
              onChange: (i) {
                maxSleectionOfNumbers.value = i;
                setState(() {
                  _validate();
                });
              },
            ),
          ),
          const Divider(),
          HarivarTwoSidedView(
            maxOnEachSide: maxOnEachSide.value,
            selectedNumbers: selectedNumbers,
            selectedAlphabets: selectedAlphabets,
            onChangeNumbers: checkNumberSelection,
            onChangeAlphabets: checkAlphabetSelection,
          )
        ],
      ),
      appBar: AppBar(
        title: const Text("yadunandan_ks_harivar"),
      ),
    );
  }
}

class HarivarTwoSidedView extends StatefulWidget {
  final int maxOnEachSide;
  final Map<int, bool> selectedNumbers;
  final Map<int, bool> selectedAlphabets;
  final Function(Map<int, bool> old, Map<int, bool> neww) onChangeAlphabets,
      onChangeNumbers;
  const HarivarTwoSidedView(
      {super.key,
      required this.maxOnEachSide,
      required this.selectedNumbers,
      required this.selectedAlphabets,
      required this.onChangeAlphabets,
      required this.onChangeNumbers});

  @override
  State<HarivarTwoSidedView> createState() => _HarivarTwoSidedViewState();
}

class _HarivarTwoSidedViewState extends State<HarivarTwoSidedView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Row(
          children: [
            Column(
              children: List.generate(
                widget.maxOnEachSide,
                (index) {
                  index = "a".codeUnitAt(0) + index;
                  return Selectible(
                    name: String.fromCharCode(index),
                    selected: widget.selectedAlphabets[index] ?? false,
                    onSelected: (b) {
                      final old = widget.selectedAlphabets;
                      final neww = Map.of(widget.selectedAlphabets);
                      neww[index] = !(neww[index] ?? false);
                      widget.onChangeAlphabets(old, neww);
                    },
                  );
                },
              ),
            ),
            const Spacer(),
            Column(
              children: List.generate(
                widget.maxOnEachSide,
                (index) => Selectible(
                  name: index.toString(),
                  selected: widget.selectedNumbers[index] ?? false,
                  onSelected: (b) {
                    final old = widget.selectedNumbers;
                    final neww = Map.of(widget.selectedNumbers);
                    neww[index] = !(neww[index] ?? false);
                    widget.onChangeNumbers(old, neww);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Selectible extends StatefulWidget {
  final String name;
  final bool selected;
  final void Function(bool?) onSelected;
  const Selectible(
      {super.key,
      required this.name,
      required this.selected,
      required this.onSelected});

  @override
  State<Selectible> createState() => _SelectibleState();
}

class _SelectibleState extends State<Selectible> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: widget.selected, onChanged: widget.onSelected),
        const SizedBox(
          width: 8,
        ),
        Text(widget.name),
      ],
    );
  }
}

class HarivarFieldController {
  final TextEditingController controller;

  HarivarFieldController(int value)
      : controller = TextEditingController(text: value.toString());

  int get value => int.tryParse(controller.text) ?? 0;

  set value(int value) {
    controller.text = value.toString();
    controller.selection = TextSelection(
        baseOffset: controller.text.length,
        extentOffset: controller.text.length);
  }

  void dispose() {
    controller.dispose();
  }
}

class HarivaraField extends StatefulWidget {
  final String label;
  final HarivarFieldController controller;
  final Function(int data) onChange;

  const HarivaraField({
    super.key,
    required this.label,
    required this.onChange,
    required this.controller,
  });

  @override
  State<HarivaraField> createState() => _HarivaraFieldState();
}

class _HarivaraFieldState extends State<HarivaraField> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, cons) {
      return Row(
        children: [
          SizedBox(
            width: cons.maxWidth * .79,
            child: Text(widget.label),
          ),
          const Spacer(),
          SizedBox(
            width: cons.maxWidth * .2,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: widget.controller.controller,
              onChanged: (s) {
                final i = int.tryParse(s);
                if (i != null) {
                  widget.onChange(i);
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
            ),
          ),
        ],
      );
    });
  }
}

//schedulers 
//creating investment ids nd trade ids
//rebalance and recurring
//auth0
//grouping logic