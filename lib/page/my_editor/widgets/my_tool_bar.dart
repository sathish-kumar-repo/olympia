import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:olympia/utils/app_color.dart';
import 'package:olympia/widgets/my_shadow_container.dart';

import '../../../utils/font_size_values.dart';

class MyToolBar extends StatelessWidget {
  const MyToolBar({
    super.key,
    required this.quillController,
    this.showDividers = false,
    this.showFontFamily = false,
    this.showFontSize = false,
    this.showBoldButton = false,
    this.showItalicButton = false,
    this.showSmallButton = false,
    this.showUnderLineButton = false,
    this.showStrikeThrough = false,
    this.showInlineCode = false,
    this.showColorButton = false,
    this.showBackgroundColorButton = false,
    this.showClearFormat = false,
    this.showAlignmentButtons = false,
    this.showLeftAlignment = false,
    this.showCenterAlignment = false,
    this.showRightAlignment = false,
    this.showJustifyAlignment = false,
    this.showHeaderStyle = false,
    this.showListNumbers = false,
    this.showListBullets = false,
    this.showListCheck = false,
    this.showCodeBlock = false,
    this.showQuote = false,
    this.showIndent = false,
    this.showLink = false,
    this.showUndo = false,
    this.showRedo = false,
    this.showDirection = false,
    this.showSearchButton = false,
    this.showSubscript = false,
    this.showSuperscript = false,
    this.showClipboardCopy = false,
    this.showClipboardCut = false,
    this.showClipboardPaste = false,
  });
  final QuillController quillController;
  //
  final bool showUndo;
  final bool showRedo;
  //
  final bool showDividers;
  final bool showFontFamily;
  final bool showFontSize;
  final bool showBoldButton;
  final bool showItalicButton;
  final bool showSmallButton;
  final bool showUnderLineButton;
  final bool showStrikeThrough;
  final bool showInlineCode;
  final bool showColorButton;
  final bool showBackgroundColorButton;
  final bool showClearFormat;
  final bool showAlignmentButtons;
  final bool showLeftAlignment;
  final bool showCenterAlignment;
  final bool showRightAlignment;
  final bool showJustifyAlignment;
  final bool showHeaderStyle;
  final bool showListNumbers;
  final bool showListBullets;
  final bool showListCheck;
  final bool showCodeBlock;
  final bool showQuote;
  final bool showIndent;
  final bool showLink;
  final bool showDirection;
  final bool showSearchButton;
  final bool showSubscript;
  final bool showSuperscript;

  final bool showClipboardCopy;
  final bool showClipboardCut;
  final bool showClipboardPaste;
  @override
  Widget build(BuildContext context) {
    return MyShadowContainer(
      borderRadius: 15,
      child: QuillToolbar.simple(
        configurations: QuillSimpleToolbarConfigurations(
          showClipboardCopy: showClipboardCopy,
          showClipboardCut: showClipboardCut,
          showClipboardPaste: showClipboardPaste,
          controller: quillController,
          showDividers: showDividers,
          showFontFamily: showFontFamily,
          showFontSize: showFontSize,
          showBoldButton: showBoldButton,
          showItalicButton: showItalicButton,
          showSmallButton: showSmallButton,
          showUnderLineButton: showUnderLineButton,
          showStrikeThrough: showStrikeThrough,
          showInlineCode: showInlineCode,
          showColorButton: showColorButton,
          showBackgroundColorButton: showBackgroundColorButton,
          showClearFormat: showClearFormat,
          showAlignmentButtons: showAlignmentButtons,
          showLeftAlignment: showLeftAlignment,
          showCenterAlignment: showCenterAlignment,
          showRightAlignment: showRightAlignment,
          showJustifyAlignment: showJustifyAlignment,
          showHeaderStyle: showHeaderStyle,
          showListNumbers: showListNumbers,
          showListBullets: showListBullets,
          showListCheck: showListCheck,
          showCodeBlock: showCodeBlock,
          showQuote: showQuote,
          showIndent: showIndent,
          showLink: showLink,
          showUndo: showUndo,
          showRedo: showRedo,
          showDirection: showDirection,
          showSearchButton: showSearchButton,
          showSubscript: showSubscript,
          showSuperscript: showSuperscript,
          fontSizesValues: fontSizesValues,
          dialogTheme: QuillDialogTheme(
            inputTextStyle: Theme.of(context).textTheme.bodyMedium,
          ),
          axis: Axis.horizontal,
          buttonOptions: const QuillSimpleToolbarButtonOptions(
            undoHistory: QuillToolbarHistoryButtonOptions(
              iconTheme: QuillIconTheme(
                iconButtonUnselectedData: IconButtonData(
                  color: AppColor.accent,
                ),
              ),
            ),
            redoHistory: QuillToolbarHistoryButtonOptions(
              iconTheme: QuillIconTheme(
                iconButtonUnselectedData: IconButtonData(
                  color: AppColor.accent,
                ),
              ),
            ),
            base: QuillToolbarBaseButtonOptions(
              iconTheme: QuillIconTheme(
                iconButtonSelectedData: IconButtonData(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
