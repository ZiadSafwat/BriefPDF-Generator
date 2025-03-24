import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/Constants/strings.dart';
import '../../Core/ViewModel/LogoSelectionProvider.dart';
import '../HelperWidgets/form_section.dart';

class LogoSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LogoSelectionProvider>();
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true, // Extends body behind the AppBar
      backgroundColor:
      Colors.transparent, // Makes the scaffold background transparent
      appBar: AppBar(title: Text("اختيار الشعار"),backgroundColor: Colors.transparent,elevation: 0,foregroundColor:  Colors.white,  ),

      body: Stack(
        children: [

          Positioned.fill(
            child: Image.network(
              'https://brief.pockethost.io/api/files/m645vzz2enc190w/wqyy33oipgobiww/background_lByOuzs2H6.png?token=',
              fit: BoxFit.cover,
            ),
          ),
          Form(
            key: provider.formKey,

            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.15,
                  vertical: 30),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildHeader(width),

                customContainer(
                  Column(
                    children: [
                      customSectionTitle('بيانات العميل'),
                      const SizedBox(height: 16),
                      customTextFormField(
                        controller: provider.clientNameController,
                        labelText: 'اسم العميل',
                        hintText: 'أدخل اسم العميل',
                      ),
                      const SizedBox(height: 8),
                      customTextFormField(
                        controller: provider.companyNameController,
                        labelText: 'اسم المؤسسة',
                        hintText: 'أدخل اسم المؤسسة',
                      ),
                      const SizedBox(height: 8),
                      customTextFormField(
                        controller: provider.mobileNumberController,
                        labelText: 'رقم الهاتف',
                        hintText: 'أدخل رقم الهاتف',
                        inputType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                  customSectionTitle('ميزانية التصميم'),
                  const SizedBox(height: 10),
                  Text(
                    "${provider.budget.toInt()} Dollar",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  customSlider(
                    value: provider.budget,
                    onChanged: (value) => provider.updateBudget(value),
                  ),
                  const SizedBox(height: 10),

                  Text("اختر نوع الشعار"),
                  Column(
                    children: provider.logoOptions.map((logo) {

                      return RadioListTile<String>(      secondary:
                      Image.asset(logo['image']!, width: width * 0.25),
                        title: Text(logo['title']!),
                        value: logo['value']!,
                        groupValue: provider.selectedLogo,
                        onChanged: (value) => provider.updateLogo(value),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 10),
                customSectionTitle('بعض الملاحظات'),
                const SizedBox(height: 20),
                customTextField(
                  controller: provider.notesController,
                  hintText: 'اكتب ملاحظاتك هنا',
                  maxLines: 12,
                  maxLength: 300,
                  onChanged: (value) {
                    // Optional: Update state if needed
                  },
                ),
                const SizedBox(height: 20),
                _buildSubmitButton(provider),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildHeader(double height) {
    return SizedBox(
      width: double.infinity,
      height: height * 0.2,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 70,
              fontFamily: 'Cairo',
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 7.0,
                  color: Colors.white,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                FlickerAnimatedText('Welcome',
                    speed: const Duration(seconds: 4)),
                FlickerAnimatedText('To', speed: const Duration(seconds: 4)),
                FlickerAnimatedText("Application Brief",
                    speed: const Duration(seconds: 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildSubmitButton(LogoSelectionProvider provider) {
    return Center(
      child: ElevatedButton(
        onPressed: provider.canSubmit()
            ? () {
          provider.formKey.currentState!.save();
          provider.exportToPDF();
        }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: provider.canSubmit() ? Colors.blue : Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        child: const Text('تصدير Pdf',
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

}
