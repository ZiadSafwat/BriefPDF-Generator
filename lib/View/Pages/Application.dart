import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Core/Constants/strings.dart';
import '../../Core/ViewModel/application_form_provider.dart';
import '../HelperWidgets/form_section.dart';

class ApplicationForm extends StatelessWidget {
  const ApplicationForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApplicationFormProvider>(context);
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true, // Extends body behind the AppBar
      backgroundColor:
          Colors.transparent, // Makes the scaffold background transparent
      appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,foregroundColor:  Colors.white,  ),

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
                const SizedBox(height: 35),
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
                customContainer(
                  Column(
                    children: [
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
                      customTextFormField(
                        controller: provider.projectNameController,
                        labelText: 'نوع التطبيق  ويب - موبايل',
                        hintText: 'أدخل نوع التطبيق',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                customSectionTitle('بعض الملاحظات'),
                const SizedBox(height: 20),
                customTextField(
                  controller: provider.notesController,
                  hintText: 'اكتب ملاحظاتك هنا',
                  maxLines: 12,
                  maxLength: 300,

                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: MaterialButton(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    height: MediaQuery.of(context).size.height * 0.15,
                    color: const Color(0xff3c6394).withOpacity(0.9),
                    disabledColor: const Color(0xFF11111E).withOpacity(0.65),
                    onPressed: provider.canSubmit()
                        ? () {

                            provider.generatePDF(); // Call to export PDF
                          }
                        : null,
                    child: const Text(
                      'تصدير',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
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
}
