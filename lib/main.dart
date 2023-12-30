import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyForm(title: 'Form data'),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController textController = TextEditingController();
  List<File> imageFiles = [];
  File? documentFile;

  Future<void> _pickImages() async {
    List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        imageFiles = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc']);
    if (result != null) {
      setState(() {
        documentFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitForm() async {
    final url = Uri.parse('https://your-api-endpoint.com');

    final request = http.MultipartRequest('POST', url);
    request.fields['textData'] = textController.text;

    for (int i = 0; i < imageFiles.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
        'image$i',
        imageFiles[i].path,
      ));
    }

    if (documentFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('document', documentFile!.path),
      );
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Form submitted successfully');
      } else {
        print('Failed to submit form. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting form: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Form Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Text Data',
                border: OutlineInputBorder(),
                hintText: 'Enter text data',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text('Pick Images'),
            ),
            const SizedBox(height: 10),
            _buildImagePreviews(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickDocument,
              child: const Text('Pick Document'),
            ),
            const SizedBox(height: 10),
            _buildDocumentPreview(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit Form'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreviews() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: imageFiles.length,
      itemBuilder: (context, index) {
        return Image.file(
          imageFiles[index],
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildDocumentPreview() {
    return documentFile != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Document Preview:'),
              const SizedBox(height: 10),
              Text('File Name: ${documentFile!.path.split('/').last}'),
            ],
          )
        : Container();
  }
}
