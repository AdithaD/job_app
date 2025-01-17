import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/models/business_details.dart';
import 'package:job_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessDetailsForm extends ConsumerStatefulWidget {
  final BusinessDetails? business;

  const BusinessDetailsForm({
    super.key,
    this.business,
  });

  @override
  ConsumerState<BusinessDetailsForm> createState() =>
      _BusinessDetailsFormState();
}

class _BusinessDetailsFormState extends ConsumerState<BusinessDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _businessNameController;
  late TextEditingController _businessEmailController;
  late TextEditingController _businessPhoneNumberController;
  late TextEditingController _businessABNController;

  late TextEditingController _businessAddressLine1Controller;
  late TextEditingController _businessAddressLine2Controller;
  late TextEditingController _businessAddressLine3Controller;

  File? logoFile;
  @override
  void initState() {
    super.initState();

    var business = widget.business;

    _businessNameController = TextEditingController(
      text: business?.name ?? "",
    );
    _businessEmailController = TextEditingController(
      text: business?.email ?? "",
    );
    _businessPhoneNumberController = TextEditingController(
      text: business?.phoneNumber ?? "",
    );

    _businessABNController = TextEditingController(
      text: business?.abn ?? "",
    );

    _businessAddressLine1Controller = TextEditingController(
      text: business?.addressLine1 ?? "",
    );
    _businessAddressLine2Controller = TextEditingController(
      text: business?.addressLine2 ?? "",
    );
    _businessAddressLine3Controller = TextEditingController(
      text: business?.addressLine3 ?? "",
    );
  }

  @override
  void dispose() {
    super.dispose();

    _businessNameController.dispose();

    _businessEmailController.dispose();
    _businessPhoneNumberController.dispose();
    _businessABNController.dispose();

    _businessAddressLine1Controller.dispose();
    _businessAddressLine2Controller.dispose();
    _businessAddressLine3Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Details",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Business Name',
                              ),
                              controller: _businessNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Name is required";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Business Email',
                              ),
                              controller: _businessEmailController,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Business Phone',
                              ),
                              controller: _businessPhoneNumberController,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Business ABN',
                              ),
                              controller: _businessABNController,
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Logo",
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                LogoPicker()
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Address",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Line 1',
                            ),
                            controller: _businessAddressLine1Controller,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Line 2',
                            ),
                            controller: _businessAddressLine2Controller,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Line 3',
                            ),
                            controller: _businessAddressLine3Controller,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _saveBusinessDetails(context),
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBusinessDetails(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await requestErrorHandler(
        context,
        () async {
          var userCollection =
              (await ref.read(pocketBasePod.future)).collection('users');

          var uId = await ref.read(userId.future);

          var newUser = User.fromRecord(await userCollection.getOne(uId));

          newUser.business = BusinessDetails(
            name: _businessNameController.text,
            email: _businessEmailController.text,
            phoneNumber: _businessPhoneNumberController.text,
            addressLine1: _businessAddressLine1Controller.text,
            addressLine2: _businessAddressLine2Controller.text,
            addressLine3: _businessAddressLine3Controller.text,
            abn: _businessABNController.text,
          );

          await userCollection.update(uId, body: newUser.toJson());

          ref.invalidate(userDetailsPod);
        },
        errorMessage: "Error saving business details",
        successMessage: "Details saved.",
      );
    }
  }
}

class LogoPicker extends StatefulWidget {
  const LogoPicker({
    super.key,
  });

  @override
  State<LogoPicker> createState() => _LogoPickerState();
}

class _LogoPickerState extends State<LogoPicker> {
  File? logo;

  @override
  void initState() {
    super.initState();

    loadLogo();
  }

  void loadLogo() async {
    var sp = await SharedPreferences.getInstance();

    var filePath = sp.getString("logoPath");
    if (filePath != null) {
      setState(() {
        logo = File(filePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            logo == null ? "No file selected." : logo!.path.split('/').last,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ElevatedButton(onPressed: _pickFile, child: Text("Select"))
      ],
    );
  }

  void _pickFile() async {
    var sp = await SharedPreferences.getInstance();
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      File file = File(result.files.single.path!);
      await sp.setString("logoPath", file.path);
      setState(() {
        logo = file;
      });
    }
  }
}
