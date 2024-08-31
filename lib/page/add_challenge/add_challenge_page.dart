import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:olympia/model/my_challenge.dart';
import 'package:olympia/page/my_editor/my_editor_page.dart';
import 'package:olympia/services/challenge_firestore.dart';

import 'package:olympia/widgets/my_app_bar.dart';

import '../../utils/helper_fn.dart';
import '../../utils/my_snack_bar.dart';
import '../../utils/navigation_bar_color.dart';
import '../../utils/sound.dart';
import '../../widgets/my_validation.dart';

import 'widgets/my_day_picker.dart';
import '../../widgets/my_fab.dart';
import 'widgets/my_label_field.dart';
import '../../widgets/my_text_field.dart';

class AddChallengePage extends StatefulWidget {
  const AddChallengePage({
    super.key,
    this.challenge,
  });
  final MyChallenge? challenge;

  @override
  State<AddChallengePage> createState() => _AddChallengePageState();
}

class _AddChallengePageState extends State<AddChallengePage> {
  final _challengeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final fireStoreServices = ChallengeFirestoreService();
  DateTime now = DateTime.now();
  // For Start
  late DateTime _selectedStartDate;
  // For End
  late DateTime _selectedEndDate;
  late int _howManyDaysSelected;
  bool isEdit = false;
  String myPlan = '';
  @override
  void initState() {
    super.initState();
    _selectedStartDate = DateTime(now.year, now.month, now.day);
    _selectedEndDate = _selectedStartDate.add(const Duration(days: 29));
    _updateSelectedDays();
    _loadEditData();
  }

  _updateSelectedDays() {
    _howManyDaysSelected =
        _selectedEndDate.difference(_selectedStartDate).inDays + 1;
  }

  void _loadEditData() {
    if (widget.challenge != null) {
      isEdit = true;
      _challengeController.text = widget.challenge!.myChallenge;
      _descriptionController.text = widget.challenge!.description;
    }
  }

  @override
  void dispose() {
    super.dispose();

    _challengeController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Push Your Boundaries'),
      floatingActionButton: MyFAB(
        onTap: _onSave,
      ),
      body: DoubleBackToCloseApp(
        snackBar: mySnackBar(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MyTextField(
                    controller: _challengeController,
                    placeholder: 'Challenge',
                    autofocus: true,
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: _descriptionController,
                    placeholder: 'Description',
                  ),
                  if (!isEdit) ...[
                    const SizedBox(height: 40),
                    MyLabelField(
                      icon: CupertinoIcons.bookmark,
                      label: 'My Plan',
                      value: myPlan == '' ? 'Add' : 'Edit',
                      onTap: _myPlanView,
                    ),
                    const SizedBox(height: 25),
                    MyLabelField(
                      icon: Icons.today,
                      label: 'Start Date',
                      value: getDate(_selectedStartDate),
                      onTap: _myStartDatePicker,
                    ),
                    const SizedBox(height: 25),
                    MyLabelField(
                      icon: Icons.event,
                      label: 'End Date',
                      value: getDate(_selectedEndDate),
                      onTap: _myEndDatePicker,
                    ),
                    const SizedBox(height: 25),
                    MyLabelField(
                      icon: Icons.calendar_month,
                      label: 'Total Days',
                      value: _howManyDaysSelected.toString(),
                      onTap: _onSelectedEndDays,
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _myStartDatePicker() async {
    final DateTime now = DateTime.now();
    final DateTime? selectedStartDate = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (selectedStartDate != null) {
      setState(() {
        _selectedStartDate = selectedStartDate;
        _updateSelectedDays();
      });
    }
  }

  Future<void> _myEndDatePicker() async {
    final now = DateTime.now();

    final DateTime? selectedEndDate = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (selectedEndDate != null) {
      setState(() {
        _selectedEndDate = selectedEndDate;
        _updateSelectedDays();
      });
    }
  }

  void _onSelectedEndDays() {
    changeNavigationBarColor();
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return MyDayPicker(
          value: _howManyDaysSelected,
          onSelectedItemChanged: (value) {
            setState(() {
              _howManyDaysSelected = value + 1;

              _selectedEndDate = _selectedStartDate.add(
                Duration(days: value),
              );
            });
          },
        );
      },
    ).then((value) => normalNavigationBarColor());
  }

  void _onSave() {
    String challenge = _challengeController.text.trim();
    String description = _descriptionController.text.trim();
    if (challenge.isEmpty || description.isEmpty) {
      showCupertinoDialogForValidation(
        'Please ensure that a valid Challenge name and description have been entered',
      );
      return;
    }
    if (_howManyDaysSelected <= 0) {
      showCupertinoDialogForValidation('End date must be after start date');
      return;
    }
    if (_howManyDaysSelected >= 366) {
      showCupertinoDialogForValidation('Total days greater than 1 year');
      return;
    }

    if (!isEdit) {
      fireStoreServices.addChallenge(
        myChallenge: challenge,
        description: description,
        myPlan: myPlan,
        challengeStartDate: _selectedStartDate,
        challengeEndDate: _selectedEndDate,
        howManyDays: _howManyDaysSelected,
      );
    } else {
      fireStoreServices.editChallenge(
        myChallenge: challenge,
        description: description,
        docId: widget.challenge!.docId,
      );
    }
    Navigator.of(context).pop();
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

  void _myPlanView() {
    Navigator.of(context)
        .push(CupertinoPageRoute(
      builder: (context) => MyTextEditor(
        title: widget.challenge == null
            ? _challengeController.text == ''
                ? 'Your Challenge'
                : _challengeController.text
            : widget.challenge!.myChallenge,
        currentText: myPlan,
      ),
    ))
        .then((value) {
      if (value != null) {
        myPlan = value;
        setState(() {});
      }
    });
  }
}
