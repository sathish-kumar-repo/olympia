import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olympia/page/add_section/add_section_page.dart';
import 'package:olympia/services/training_firestore.dart';

import '../../../../../utils/app_color.dart';
import '../../../../../widgets/confirmation.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({
    super.key,
    required this.map,
    this.selectedWeekDayIndex,
    required this.docName,
  });

  final Map<String, Map> map;

  final int? selectedWeekDayIndex;

  final String docName;

  @override
  State<TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends State<TrainingView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: widget.map.length,
        itemBuilder: (context, index) {
          final value = widget.map.values.elementAt(index);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onLongPress: () => _onShowAction(
                  doc: widget.docName,
                  value: value,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value['title'],
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 20,
                              color: AppColor.accent,
                            ),
                      ),
                    ),
                    Text(
                      value['order'].toString(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                    )
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 20),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value['section-training'].length,
                itemBuilder: (context, index) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.star,
                    color: AppColor.accent,
                  ),
                  title: Text(
                    value['section-training'][index],
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                          fontSize: 17,
                        ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Future<bool?> showDeleteConfirmationDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return const ConfirmDeletion(
          title: 'Confirm Deletion',
          onDeleteText: 'Delete',
          message: 'Are you sure to delete?',
        );
      },
    );
  }

  void _editSection(Map value) {
    Navigator.of(context).pushReplacement(CupertinoPageRoute(
      builder: (context) => AddSectionPage(
        selectedWeekDayIndex: widget.selectedWeekDayIndex,
        value: value,
      ),
    ));
  }

  void _onDelete(String doc, String id) async {
    bool? confirmDelete = await showDeleteConfirmationDialog();
    if (confirmDelete != null && confirmDelete) {
      TrainingFirestoreServices().deleteTrainingSection(
        doc: doc,
        id: id,
      );
    }
  }

  _onShowAction({
    required Map value,
    required String doc,
  }) {
    const TextStyle style = TextStyle(color: Colors.white);

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text(
              'Edit',
              style: style,
            ),
            onPressed: () => _editSection(value),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop();
              _onDelete(doc, value['id']);
            },
          ),
        ],
      ),
    );
  }
}
