import 'dart:convert';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:olympia/widgets/my_app_bar.dart';
import '../../utils/my_snack_bar.dart';
import 'widgets/my_tool_bar.dart';

class MyTextEditor extends StatefulWidget {
  const MyTextEditor({
    super.key,
    required this.title,
    this.currentText = '',
  });
  final String title;
  final String currentText;
  @override
  State<MyTextEditor> createState() => _MyTextEditorState();
}

class _MyTextEditorState extends State<MyTextEditor> {
  late QuillController _quillController;
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  String myPlan = '';
  @override
  void initState() {
    if (widget.currentText != '') {
      _quillController = QuillController(
        document: Document.fromJson(jsonDecode(widget.currentText)),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _quillController = QuillController.basic();
    }
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: DoubleBackToCloseApp(
        snackBar: mySnackBar(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              children: [
                ..._buildToolBar(),
                _buildEditor(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditor() {
    return Expanded(
      child: QuillEditor(
        focusNode: focusNode,
        scrollController: scrollController,
        configurations: QuillEditorConfigurations(
          controller: _quillController,
          scrollable: true,
          expands: false,
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
            bottom: 30,
          ),
          showCursor: true,
          enableScribble: true,
          placeholder: 'Your Plan',
        ),
      ),
    );
  }

  List<Widget> _buildToolBar() {
    return [
      SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, right: 10),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            MyToolBar(
              quillController: _quillController,
              showFontFamily: true,
              showFontSize: true,
              showHeaderStyle: true,
            ),
            const SizedBox(width: 15),
            MyToolBar(
              quillController: _quillController,
              showSmallButton: true,
            ),
            const SizedBox(width: 15),
            MyToolBar(
              quillController: _quillController,
              showColorButton: true,
              showBackgroundColorButton: true,
            ),
            const SizedBox(width: 15),
            MyToolBar(
              quillController: _quillController,
              showClearFormat: true,
            ),
            const SizedBox(width: 15),
            MyToolBar(
              quillController: _quillController,
              showDirection: true,
            ),
            const SizedBox(width: 15),
            MyToolBar(
              quillController: _quillController,
              showSearchButton: true,
            ),
          ],
        ),
      ),
      SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, right: 10),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            MyToolBar(
              showRedo: true,
              showUndo: true,
              quillController: _quillController,
            ),
            const SizedBox(width: 15),
            MyToolBar(
              showClipboardCopy: true,
              showClipboardCut: true,
              showClipboardPaste: true,
              quillController: _quillController,
            ),
            const SizedBox(width: 15),
            MyToolBar(
              quillController: _quillController,
              showItalicButton: true,
              showBoldButton: true,
              showStrikeThrough: true,
              showSubscript: true,
              showSuperscript: true,
              showUnderLineButton: true,
            ),
            const SizedBox(width: 15),
            MyToolBar(
              quillController: _quillController,
              showAlignmentButtons: true,
              showCenterAlignment: true,
              showRightAlignment: true,
              showLeftAlignment: true,
              showJustifyAlignment: true,
            ),
            const SizedBox(width: 15),
            MyToolBar(
              quillController: _quillController,
              showListBullets: true,
              showListCheck: true,
              showListNumbers: true,
            ),
            const SizedBox(width: 15),
            MyToolBar(
              quillController: _quillController,
              showIndent: true,
            ),
            const SizedBox(width: 15),
            MyToolBar(
              quillController: _quillController,
              showDividers: true,
            ),
            const SizedBox(width: 15),
            MyToolBar(
              quillController: _quillController,
              showCodeBlock: true,
              showInlineCode: true,
              showQuote: true,
            ),
            const SizedBox(width: 15),
            MyToolBar(
              quillController: _quillController,
              showLink: true,
            ),
          ],
        ),
      ),
    ];
  }

  MyAppBar _buildAppBar() {
    return MyAppBar(
      title: widget.title,
      trailing: TextButton(
        onPressed: _saveJournal,
        child: const Text('Save'),
      ),
    );
  }

  void _saveJournal() {
    String newPlan = jsonEncode(_quillController.document.toDelta().toJson());
    Navigator.pop(context, _isQuillEmpty ? myPlan : newPlan);
  }

  bool get _isQuillEmpty {
    final delta = _quillController.document.toDelta();
    // Check if delta is empty
    if (delta.isEmpty) {
      return true;
    }
    // Check if delta contains only a single newline
    if (delta.length == 1 && delta.first.data == '\n') {
      return true;
    }
    // Check if delta contains a single insert operation of a newline
    if (delta.length == 1 && delta.first.isInsert && delta.first.data == '\n') {
      return true;
    }
    return false;
  }
}
