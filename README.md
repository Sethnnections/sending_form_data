# Flutter Form Submission App

This Flutter application serves as a comprehensive form submission tool, allowing users to input text data, choose multiple images, pick documents, and submit the form to a designated API endpoint. The app utilizes the Flutter framework, providing a seamless cross-platform experience for both Android and iOS devices.

## Features

### 1. Text Input
The app includes a text input field where users can enter relevant data. This could be information such as names, descriptions, or any other textual content.

```dart
TextFormField(
  controller: textController,
  decoration: const InputDecoration(
    labelText: 'Text Data',
    border: OutlineInputBorder(),
    hintText: 'Enter text data',
  ),
)
```

### 2. Image Selection
Users can easily pick one or multiple images from their device's gallery. The selected images are then displayed as previews in a grid view within the app.

```dart
ElevatedButton(
  onPressed: _pickImages,
  child: const Text('Pick Images'),
)

GridView.builder(
  // ...
  itemBuilder: (context, index) {
    return Image.file(
      imageFiles[index],
      height: 100,
      width: 100,
      fit: BoxFit.cover,
    );
  },
)
```

### 3. Document Upload
The app allows users to select a document, typically in PDF or DOC format. Once chosen, the document's name is displayed as a preview.

```dart
ElevatedButton(
  onPressed: _pickDocument,
  child: const Text('Pick Document'),
)

Text('File Name: ${documentFile!.path.split('/').last}')
```

### 4. Form Submission
Upon completing the form, users can submit the data, including text, images, and documents, to a specified API endpoint.

```dart
ElevatedButton(
  onPressed: _submitForm,
  child: const Text('Submit Form'),
)
```

```dart
Future<void> _submitForm() async {
  // ...
  final response = await request.send();
  if (response.statusCode == 200) {
    print('Form submitted successfully');
  } else {
    print('Failed to submit form. Status code: ${response.statusCode}');
  }
}
```

## Getting Started

To run the app locally, ensure you have Flutter installed. Clone the repository, navigate to the project directory, and run:

```bash
flutter run
```

This command launches the app on an emulator or a connected device.

## Dependencies

The project relies on essential packages such as `http`, `file_picker`, and `image_picker` for handling HTTP requests, file picking, and image selection, respectively. Refer to the `pubspec.yaml` file for the complete list of dependencies.

## Contributions

Contributions are welcome! Feel free to open issues or submit pull requests to enhance the app's functionality or address any bugs.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

Special thanks to the Flutter and Dart communities for their continuous support and the open-source contributors of the used packages.

Happy coding!