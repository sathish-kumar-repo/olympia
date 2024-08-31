import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olympia/extension/string_extension.dart';
import 'package:olympia/services/training_firestore.dart';
import 'package:olympia/utils/app_color.dart';
import 'package:olympia/utils/helper_fn.dart';
import 'package:olympia/widgets/my_app_bar.dart';
import 'package:olympia/widgets/my_fab.dart';
import 'package:olympia/widgets/my_text_field.dart';
import '../../utils/my_snack_bar.dart';
import '../../utils/sound.dart';
import '../../widgets/my_validation.dart';
import 'widget/training_days_heading.dart';

class AddSectionPage extends StatefulWidget {
  const AddSectionPage({
    super.key,
    this.selectedWeekDayIndex,
    this.value,
  });
  final int? selectedWeekDayIndex;
  final Map? value;
  @override
  State<AddSectionPage> createState() => _AddSectionPageState();
}

class _AddSectionPageState extends State<AddSectionPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ordercontroller = TextEditingController();
  final TextEditingController _subTextcontroller = TextEditingController();
  List<String> _subSection = [];
  final firestoreService = TrainingFirestoreServices();
  late int _selectedWeekDayIndex;
  List<String> options = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];
  @override
  void initState() {
    super.initState();
    _selectedWeekDayIndex = widget.selectedWeekDayIndex ?? 0;
    if (widget.value != null) {
      _titleController.text = widget.value!['title'];
      _ordercontroller.text = widget.value!['order'].toString();
      _subSection = List<String>.from((widget.value!['section-training']));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _ordercontroller.dispose();
    _subTextcontroller.dispose();
  }

  _getAppText() {
    if (widget.value != null) {
      return 'Edit your training';
    }
    return 'Add your training';
  }

  @override
  Widget build(BuildContext context) {
    String title =
        (_titleController.text == '' ? 'Your Title' : _titleController.text)
            .toCapitalized();
    return Scaffold(
      appBar: MyAppBar(
        title: _getAppText(),
      ),
      floatingActionButton: MyFAB(
        onTap: _onSave,
      ),
      body: DoubleBackToCloseApp(
        snackBar: mySnackBar(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TrainindDayHeading(
                    txt: getWeekDay(_selectedWeekDayIndex).toCapitalized(),
                    onTap: () => _showBottomSheet(),
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: _ordercontroller,
                    placeholder: 'Your order',
                    isDigitOnly: true,
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: _titleController,
                    placeholder: 'Your Title',
                    autofocus: true,
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 30),
                  _buildSubItemsContainer(title),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColor.bottomBar,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              itemCount: options.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return RadioListTile(
                  title: Text(options[index].toCapitalized()),
                  value: index,
                  groupValue: _selectedWeekDayIndex,
                  onChanged: (value) {
                    _selectedWeekDayIndex = value ?? 0;
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ],
        ),
      ),
    ).then((value) => setState(() {}));
  }

  Container _buildSubItemsContainer(String title) {
    return Container(
      width: double.infinity,
      // padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColor.bottomBar,
        border: Border.all(color: AppColor.accent),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColor.accent,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Text(title),
                  ),
                ),
                IconButton(
                  onPressed: () => popTextField(title: title),
                  icon: const Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          _subSection.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'No Data',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : _buildSubItemsView(title),
        ],
      ),
    );
  }

  ReorderableListView _buildSubItemsView(String title) {
    return ReorderableListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: List.generate(
        _subSection.length,
        (index) => Dismissible(
          background: Container(
            color: Colors.red,
            child: const Icon(CupertinoIcons.delete),
          ),
          key: UniqueKey(),
          onDismissed: (DismissDirection direction) {
            setState(() {
              _subSection.removeAt(index);
            });
          },
          child: ListTile(
            onTap: () => popTextField(
                text: _subSection[index], index: index, title: title),
            key: Key('$index'),
            title: Text(_subSection[index].toCapitalized()),
            leading: const Icon(
              Icons.star,
              color: AppColor.accent,
              size: 20,
            ),
            trailing: const Icon(Icons.drag_handle_sharp),
          ),
        ),
      ),
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = _subSection.removeAt(oldIndex);

          _subSection.insert(newIndex, item);
        });
      },
    );
  }

  void popTextField({String? text, int? index, required String title}) {
    if (text != null) {
      _subTextcontroller.text = text;
    }
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: CupertinoAlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            content: Column(
              children: [
                MyTextField(
                  controller: _subTextcontroller,
                  placeholder: 'Your note',
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  if (_subTextcontroller.text != '') {
                    setState(() {
                      if (text == null) {
                        _subSection.add(_subTextcontroller.text);
                      } else {
                        _subSection[index!] = _subTextcontroller.text;
                      }
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: AppColor.accent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) => _subTextcontroller.clear());
  }

// Validation
  void showCupertinoDialogForValidation(String txt) {
    audioExperience(audioExperienceType: AudioExperienceType.error);
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return MyValidation(
          txt: txt,
        );
      },
    );
  }

  void _onSave() {
    if (_titleController.text.isEmpty) {
      showCupertinoDialogForValidation(
        'Please ensure that a valid title have been entered',
      );
      return;
    }

    if (_ordercontroller.text.isEmpty) {
      showCupertinoDialogForValidation(
        'Please ensure that a valid order have been entered',
      );
      return;
    }
    if (_subSection.isEmpty) {
      showCupertinoDialogForValidation(
        'Sub Items is empty',
      );
      return;
    }

    if (widget.value == null) {
      firestoreService.addTrainingSection(
        doc: getWeekDay(_selectedWeekDayIndex),
        title: _titleController.text,
        workout: _subSection,
        order: int.parse(_ordercontroller.text),
      );
    } else {
      firestoreService.updateTrainingSection(
        doc: getWeekDay(_selectedWeekDayIndex),
        title: _titleController.text,
        workout: _subSection,
        order: int.parse(_ordercontroller.text),
        id: widget.value!['id'],
      );
    }
    Navigator.pop(context);
  }
}
