import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class PdfFilePickerWidget extends StatefulWidget {
  const PdfFilePickerWidget({super.key});

  @override
  _PdfFilePickerWidgetState createState() => _PdfFilePickerWidgetState();
}

class _PdfFilePickerWidgetState extends State<PdfFilePickerWidget> {
  File? selectedPdfFile;

  _fetchPrice() async {
    print('fetching');
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'multipart/form-data'
    };
    var data = {'file_data': selectedPdfFile};

    var dio = Dio();
    var response = await dio.request(
      'https://printerapi-mmj4oydexa-uc.a.run.app/upload',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));
    } else {
      print(response.statusMessage);
    }
  }

  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selectedPdfFile = File(result.files.single.path!);
      });
      _fetchPrice();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _pickPdfFile,
            child: const Text('Pick a PDF File'),
          ),
          if (selectedPdfFile != null)
            Text('Selected PDF: ${selectedPdfFile!.path}'),
        ],
      ),
    );
  }
}
