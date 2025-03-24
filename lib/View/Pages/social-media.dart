import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Core/Constants/strings.dart';
import '../../Core/ViewModel/SocialMediaFormProvider.dart';
import '../HelperWidgets/form_section.dart';

class SocialMediaForm extends StatelessWidget {
  const SocialMediaForm();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SocialMediaFormProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
     extendBodyBehindAppBar: true,
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
              padding: EdgeInsets.symmetric(horizontal: width * 0.15, vertical: 30),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildHeader(width),
                customContainer(
                  FormSection(
                    title: 'بيانات العميل',
                    children: [
                      customTextFormField(
                          controller: provider.clientNameController,
                          labelText: 'اسم العميل',
                          hintText: ''),
                      customTextFormField(
                          controller: provider.companyNameController,
                          labelText: 'اسم المؤسسة',
                          hintText: ''),
                      customTextFormField(
                          controller: provider.mobileNumberController,
                          labelText: 'رقم الهاتف',
                          hintText: '',
                          inputType: TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                customContainer(
                  FormSection(
                    title: 'بيانات التصميم',
                    children: [
                      customTextFormField(
                          controller: provider.projectNameController,
                          labelText: 'اسم التصميم',
                          hintText: ''),
                      customTextFormField(
                          controller: provider.projectDescriptionController,
                          labelText: 'وصف التصميم',
                          hintText: ''),
                      customTextFormField(
                          controller: provider.projectTypeController,
                          labelText: 'نوع التصميم',
                          hintText: ''),
                      customTextFormField(
                          controller: provider.favoriteColorsController,
                          labelText: 'الألوان المفضلة',
                          hintText: ''),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                customContainer(
                  FormSection(
                    title: 'الفئة المستهدفة',
                    children: _buildTargetAudience(provider),
                  ),
                ),
                const SizedBox(height: 35),
                customContainer(
                  FormSection(
                    title: 'الميزانية والملاحظات',
                    children: [
                      Slider(
                        value: provider.budget,
                        min: 0,
                        max: 1000,
                        divisions: 100,
                        label: provider.budget.toStringAsFixed(2),
                        onChanged: provider.updateBudget,
                      ),
                      customTextFormField(
                          controller: provider.notesController,
                          labelText: 'ملاحظات إضافية',
                          hintText: ''),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: MaterialButton(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    height: MediaQuery.of(context).size.height * 0.15,
                    color: const Color(0xff3c6394).withOpacity(0.9),
                    disabledColor: const Color(0xFF11111E).withOpacity(0.65),
                    onPressed: provider.canSubmit
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
    TextStyle textStyle =
        const TextStyle(fontFamily: 'Cairo', overflow: TextOverflow.ellipsis);
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
                FlickerAnimatedText('Social',
                    textStyle: textStyle, speed: const Duration(seconds: 3)),
                FlickerAnimatedText('Media',
                    textStyle: textStyle, speed: const Duration(seconds: 3)),
                FlickerAnimatedText("Brief",
                    textStyle: textStyle, speed: const Duration(seconds: 3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTargetAudience(SocialMediaFormProvider provider) {
    return [
      FittedBox(
        child: Row(
          children: [
            _buildCheckbox(provider, 'أطفال', 'kids', provider.isKidsSelected),
            _buildCheckbox(provider, 'شباب', 'youth', provider.isYouthSelected),
            _buildCheckbox(provider, 'نساء', 'women', provider.isWomenSelected),
            _buildCheckbox(
                provider, 'الجميع', 'group', provider.isGroupSelected),
          ],
        ),
      ),
    ];
  }

  Widget _buildCheckbox(
      SocialMediaFormProvider provider, String title, String key, bool value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: value, onChanged: (_) => provider.toggleAudience(key)),
        Text(title, style: const TextStyle(color: Colors.white)),
      ],
    );
  }


}
