import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../Constants/strings.dart';

// ✅ JavaScript Interop Functions
@JS()
external void showLoading();

@JS()
external void hideLoading();

@JS()
external void downloadPDF(String pdfBase64, String filename);

class SocialMediaFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final clientNameController = TextEditingController();
  final companyNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final projectNameController = TextEditingController();
  final projectDescriptionController = TextEditingController();
  final projectTypeController = TextEditingController();
  final favoriteColorsController = TextEditingController();
  final notesController = TextEditingController();

  double budget = 0;
  bool isPriceChanged = false;

  bool isKidsSelected = false;
  bool isYouthSelected = false;
  bool isWomenSelected = false;
  bool isGroupSelected = false;
  String? watermarkImage;

  bool get canSubmit {
    return budget >= 10 &&
        clientNameController.text.isNotEmpty &&
        companyNameController.text.isNotEmpty &&
        mobileNumberController.text.isNotEmpty &&
        projectNameController.text.isNotEmpty &&
        projectDescriptionController.text.isNotEmpty &&
        projectTypeController.text.isNotEmpty &&
        favoriteColorsController.text.isNotEmpty &&


        (isGroupSelected ||
            isWomenSelected ||
            isYouthSelected ||
            isKidsSelected);
  }

  SocialMediaFormProvider() {
    _loadWatermark();
    _addTextListeners();
  }

  void _addTextListeners() {
    clientNameController.addListener(_onTextChanged);
    companyNameController.addListener(_onTextChanged);
    mobileNumberController.addListener(_onTextChanged);
    projectNameController.addListener(_onTextChanged);
    projectDescriptionController.addListener(_onTextChanged);
    projectTypeController.addListener(_onTextChanged);
    favoriteColorsController.addListener(_onTextChanged);
    notesController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    notifyListeners();
  }

  void updateBudget(double value) {
    budget = value;
    isPriceChanged = true;
    notifyListeners();
  }

  Future<void> _loadWatermark() async {
    watermarkImage = await rootBundle.loadString('assets/watermark.svg');
    notifyListeners();
  }

  Future<void> generatePDF() async {
    showLoading(); // ✅ Show loading spinner before PDF generation

    final base =
    pw.Font.ttf(await rootBundle.load("assets/fonts/Cairo-Medium.ttf"));
    final boldFont =
    pw.Font.ttf(await rootBundle.load("assets/fonts/Cairo-Bold.ttf"));

    final fallbackFonts = [
      pw.Font.ttf(await rootBundle.load("assets/fonts/NotoEmoji.ttf")),
      pw.Font.ttf(await rootBundle.load("assets/fonts/NotoSans.ttf")),
    ];
    final myTheme = pw.ThemeData.withFont(
      fontFallback: fallbackFonts,
      base: base,
      bold: boldFont,
      italic: boldFont,
      boldItalic: boldFont,
    );

    final pdf = pw.Document(theme: myTheme);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              if (watermarkImage != null)
                pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Opacity(
                    opacity: 0.1,
                    child: pw.SvgImage(
                      customFontLookup: (fontFamily, fontStyle, fontWeight) {
                        return fallbackFonts[1];
                      },
                      width: 400,
                      height: 400,
                      svg: watermarkImage!,
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text(
                      "استمارة التقديم",
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.blue, width: 1.5),
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("📌 اسم العميل: ${clientNameController.text}"),
                        pw.Text("🏢 اسم المؤسسة: ${companyNameController.text}"),
                        pw.Text("📞 رقم الهاتف: ${mobileNumberController.text}"),
                        pw.Text("🎯 اسم المشروع: ${projectNameController.text}"),
                        pw.Text("📖 وصف المشروع: ${projectDescriptionController.text}"),
                        pw.Text("📌 نوع المشروع: ${projectTypeController.text}"),
                        pw.Text("🎨 الألوان المفضلة: ${favoriteColorsController.text}"),
                        pw.Text("💰 ميزانية المشروع: ${budget.toInt()} دولار"),
                        pw.Text("📝 ملاحظات: ${notesController.text}"),
                        pw.Text("👥 الفئة المستهدفة: ${_getSelectedAudience()}"),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          "شكراً لك على ثقتك بنا!",
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 5),
                        pw.UrlLink(
                          destination: AppString().url,
                          child: pw.Text(
                            "قم بزيارة موقعنا",
                            style: const pw.TextStyle(
                              fontSize: 14,
                              color: PdfColors.blue,
                              decoration: pw.TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final pdfFile = await pdf.save();
    triggerPDFDownload(pdfFile);
  }

  String _getSelectedAudience() {
    List<String> selected = [];
    if (isKidsSelected) selected.add("الأطفال");
    if (isYouthSelected) selected.add("الشباب");
    if (isWomenSelected) selected.add("النساء");
    if (isGroupSelected) selected.add("المجموعات");
    return selected.join(", ");
  }

  void triggerPDFDownload(Uint8List pdfFile) {
    final base64String = base64Encode(pdfFile);
    downloadPDF(base64String, 'application_form.pdf');
  }

  void toggleAudience(String type) {
    if (type == "kids") isKidsSelected = !isKidsSelected;
    if (type == "youth") isYouthSelected = !isYouthSelected;
    if (type == "women") isWomenSelected = !isWomenSelected;
    if (type == "group") isGroupSelected = !isGroupSelected;
    notifyListeners();
  }

  @override
  void dispose() {
    clientNameController.dispose();
    companyNameController.dispose();
    mobileNumberController.dispose();
    projectNameController.dispose();
    projectDescriptionController.dispose();
    projectTypeController.dispose();
    favoriteColorsController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
