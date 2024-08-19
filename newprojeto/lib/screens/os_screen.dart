import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'thank_you_screen.dart';

class OsScreen extends StatefulWidget {
  final String bairro;

  const OsScreen({required this.bairro, Key? key}) : super(key: key);

  @override
  _OsScreenState createState() => _OsScreenState();
}

class _OsScreenState extends State<OsScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  File? _videoFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await showDialog<XFile>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Escolha uma opção'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(await _picker.pickImage(source: ImageSource.camera));
              },
              child: Text('Tirar Foto'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(await _picker.pickImage(source: ImageSource.gallery));
              },
              child: Text('Escolher da Galeria'),
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await showDialog<XFile>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Escolha uma opção'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(await _picker.pickVideo(source: ImageSource.camera));
              },
              child: Text('Gravar Vídeo'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(await _picker.pickVideo(source: ImageSource.gallery));
              },
              child: Text('Escolher da Galeria'),
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ThankYouScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Bairro'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Detalhes para o bairro: ${widget.bairro}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Escolher Imagem'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _pickVideo,
                      child: Text('Escolher Vídeo'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(),
                _videoFile != null
                    ? Text('Vídeo Selecionado: ${_videoFile!.path}')
                    : Container(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Enviar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
