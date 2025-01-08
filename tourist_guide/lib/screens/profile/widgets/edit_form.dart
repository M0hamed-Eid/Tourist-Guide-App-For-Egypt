import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tourist_guide/core/mixins/validation_mixin.dart';
import 'package:tourist_guide/core/theme/text_themes.dart';
import 'package:tourist_guide/screens/auth/widgets/custom_txt_field_auth.dart';

class EditForm extends StatelessWidget with ValidationMixin {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final VoidCallback onApply;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

   EditForm({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextFormFieldAuth(
                    hintText: "Enter your Full Name",
                    labalText: "Full Name",
                    iconData: Icons.person_outline,
                    mycontroller: fullNameController,
                    isNunmber: false,
                    valid: validateName),
                CustomTextFormFieldAuth(
                  hintText: "Enter your email",
                  labalText: "Email",
                  iconData: Icons.email_outlined,
                  mycontroller: emailController,
                  isNunmber: false,
                  valid: validateEmail,
                ),
                CustomTextFormFieldAuth(
                  hintText: "Enter your Password",
                  labalText: "Password",
                  iconData: Icons.lock_outline,
                  mycontroller: passwordController,
                  isNunmber: false,
                  valid: validatePassword,
                ),
                IntlPhoneField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                    labelText: 'Phone Number',
                    suffixIcon: Icon(Icons.phone),
                    hintText: "Enter your phone number",
                    hintStyle: const TextStyle(fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  // controller: phoneController,
                  // get the 4th value till the end
                  initialValue: phoneController.text.substring(3),
                  initialCountryCode: 'EG',
                  onChanged: (phone) {
                    phoneController.text = phone.completeNumber;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:()=>{ 
                    if(formKey.currentState!.validate()) onApply()
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'Apply Changes',
                    style: AppTextTheme.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
