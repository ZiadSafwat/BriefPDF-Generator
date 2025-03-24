import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


// ✅ JavaScript Interop Function
@JS()
external void downloadPDF(JSString pdfBase64, JSString filename);

class ApplicationFormProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final clientNameController = TextEditingController();
  final companyNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final projectNameController = TextEditingController();
  final notesController = TextEditingController();

  double budget = 0;
  bool isPriceChanged = false;
  String? watermarkImage;

  ApplicationFormProvider() {
    _initialize();
  }

  void _initialize() {
    for (var controller in [
      clientNameController,
      companyNameController,
      mobileNumberController,
      projectNameController,
      notesController
    ]) {
      controller.addListener(_onFormChanged);
    }
    _loadWatermark();
  }

  void _onFormChanged() => notifyListeners();

  Future<void> _loadWatermark() async {
    watermarkImage = await rootBundle.loadString('assets/watermark.svg');
    notifyListeners();
  }

  void updateBudget(double newBudget) {
    budget = newBudget;
    isPriceChanged = true;
    notifyListeners();
  }

  bool canSubmit() {
    return budget >= 20 &&
        clientNameController.text.isNotEmpty &&
        companyNameController.text.isNotEmpty &&
        mobileNumberController.text.isNotEmpty &&
        projectNameController.text.isNotEmpty &&
        isPriceChanged ;
  }

  Future<void> generatePDF() async {
    final baseFont = pw.Font.ttf(await rootBundle.load("assets/fonts/Cairo-Medium.ttf"));
    final boldFont = pw.Font.ttf(await rootBundle.load("assets/fonts/Cairo-Bold.ttf"));

    final fontFallback = [
      pw.Font.ttf(await rootBundle.load("assets/fonts/NotoEmoji.ttf")),
      pw.Font.ttf(await rootBundle.load("assets/fonts/NotoSans.ttf")),
    ];

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        fontFallback: fontFallback,
        base: baseFont,
        bold: boldFont,
        italic: baseFont,
        boldItalic: boldFont,
      ),
    );

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
                      customFontLookup: (_, __, ___) => fontFallback[1],
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
                        _infoText("📌 اسم العميل", clientNameController.text, baseFont, boldFont),
                        _infoText("🏢 اسم المؤسسة", companyNameController.text, baseFont, boldFont),
                        _infoText("📞 رقم الهاتف", mobileNumberController.text, baseFont, boldFont),
                        _infoText("📌 نوع التطبيق", projectNameController.text, baseFont, boldFont),
                        _infoText("💰 ميزانية التصميم", "${budget.toInt()} دولار", baseFont, boldFont),
                        _infoText("📝 ملاحظات", notesController.text, baseFont, boldFont),
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
                          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 5),
                        pw.UrlLink(
                          destination: "https://yourwebsite.com",
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

  void triggerPDFDownload(Uint8List pdfFile) {
    try {
      final base64String = base64Encode(pdfFile);
      downloadPDF(base64String.toJS, 'application_form.pdf'.toJS);
    } catch (e) {
      debugPrint("Error downloading PDF: $e");
    }
  }

  pw.Widget _infoText(String label, String value, pw.Font baseFont, pw.Font boldFont) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "$label: ",
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue,
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(font: baseFont, fontSize: 16),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in [
      clientNameController,
      companyNameController,
      mobileNumberController,
      projectNameController,
      notesController
    ]) {
      controller.dispose();
    }
    super.dispose();
  }
}
