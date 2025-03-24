import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../Constants/strings.dart';

// ✅ Define JavaScript Interop Function
@JS()
external void downloadPDF(String pdfBase64, String filename);

class LogoSelectionProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? selectedLogo;
  double budget = 0;
  bool isPriceChanged = false;
  String? watermarkImage;

  final clientNameController = TextEditingController();
  final companyNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final notesController = TextEditingController();

  final List<Map<String, String>> logoOptions = [
    {'title': 'شعار أيقونة', 'image': 'assets/icon.png', 'value': 'icon'},
    {'title': 'شعار نصي', 'image': 'assets/typeface.png', 'value': 'text'},
    {
      'title': 'شعار ديناميكي',
      'image': 'assets/dynamic.png',
      'value': 'dynamic'
    },
    {'title': 'شعار مزيج', 'image': 'assets/mazeeg.png', 'value': 'mix'},
    {
      'title': 'شعار كاركتير',
      'image': 'assets/character.png',
      'value': 'cartoon'
    },
    {
      'title': 'شعار الخط العربي',
      'image': 'assets/arabic.png',
      'value': 'arabic'
    },
  ];

  LogoSelectionProvider() {
    _loadWatermark();
  }

  Future<void> _loadWatermark() async {
    watermarkImage = await rootBundle.loadString('assets/watermark.svg');
    notifyListeners();
  }

  bool canSubmit() =>
      selectedLogo != null &&
      budget >= 20 &&
      clientNameController.text.isNotEmpty &&
      companyNameController.text.isNotEmpty &&
      mobileNumberController.text.isNotEmpty;

  void updateLogo(String? logo) {
    selectedLogo = logo;
    notifyListeners();
  }

  void updateBudget(double newBudget) {
    budget = newBudget;
    isPriceChanged = true;
    notifyListeners();
  }

  Future<void> exportToPDF() async {
    final baseFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Cairo-Medium.ttf"));
    final boldFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Cairo-Bold.ttf"));

    final fontFallback = [
      pw.Font.ttf(await rootBundle.load("assets/fonts/NotoEmoji.ttf")),
      pw.Font.ttf(await rootBundle.load("assets/fonts/NotoSans.ttf")),
    ];

    final pdf = pw.Document();

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
                      customFontLookup: (fontFamily, fontStyle, fontWeight) =>
                          fontFallback[1],
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
                        font: boldFont,
                        fontFallback: fontFallback,
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
                        pw.Text(
                          "تقرير بيانات العميل",
                          style: pw.TextStyle(
                              font: boldFont,
                              fontFallback: fontFallback,
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Divider(),
                        _buildText("📌 اسم العميل", clientNameController.text,
                            baseFont, fontFallback),
                        _buildText("🏢 اسم المؤسسة", companyNameController.text,
                            baseFont, fontFallback),
                        _buildText("📞 رقم الهاتف", mobileNumberController.text,
                            baseFont, fontFallback),
                        _buildText("💰 ميزانية التصميم",
                            "${budget.toInt()} دولار", baseFont, fontFallback),
                        _buildText("🎨 نوع الشعار", selectedLogo ?? 'غير محدد',
                            baseFont, fontFallback),
                        _buildText("📝 ملاحظات", notesController.text, baseFont,
                            fontFallback),
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

  pw.Widget _buildText(
      String label, String value, pw.Font font, List<pw.Font> fontFallback) {
    return pw.Text(
      "$label: $value",
      style: pw.TextStyle(font: font, fontFallback: fontFallback),
    );
  }

  void triggerPDFDownload(Uint8List pdfFile) {
    final base64String = base64Encode(pdfFile);
    downloadPDF(base64String, 'application_form.pdf');
  }

  @override
  void dispose() {
    clientNameController.dispose();
    companyNameController.dispose();
    mobileNumberController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
