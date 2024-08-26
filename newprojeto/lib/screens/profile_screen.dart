import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  File? _videoFile;
  VideoPlayerController? _videoController;
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Nome do Usuário';
  }

  Future<void> _pickMedia() async {
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
              child: Text('Escolher Imagem da Galeria'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(await _picker.pickVideo(source: ImageSource.gallery));
              },
              child: Text('Escolher Vídeo da Galeria'),
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        if (pickedFile.path.endsWith('.mp4')) {
          _videoFile = File(pickedFile.path);
          _videoController?.dispose();
          _videoController = VideoPlayerController.file(_videoFile!)
            ..initialize().then((_) {
              setState(() {});
              _videoController!.setLooping(true);
            });
        } else {
          _imageFile = File(pickedFile.path);
          _videoFile = null;
          _videoController?.dispose();
          _videoController = null;
        }
        _hasUnsavedChanges = true;
      });

      if (_videoFile != null) {
        final videoDuration = await _getVideoDuration(_videoFile!);
        if (videoDuration > Duration(seconds: 5)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('O vídeo deve ter no máximo 5 segundos.')),
          );
          setState(() {
            _videoFile = null;
            _videoController?.dispose();
            _videoController = null;
          });
        }
      }
    }
  }

  Future<Duration> _getVideoDuration(File videoFile) async {
    final VideoPlayerController controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    final duration = controller.value.duration;
    controller.dispose();
    return duration;
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges) {
      return (await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmar Saída'),
            content: Text('Você tem alterações não salvas. Deseja sair sem salvar?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('Sair Sem Salvar'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      )) ?? false;
    }
    return true;
  }

  Future<void> _onSave() async {
    if (_hasUnsavedChanges) {
      final shouldSave = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmar Salvar'),
            content: Text('Você tem alterações não salvas. Deseja salvar?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('Salvar'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      ) ?? false;

      if (shouldSave) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alterações salvas com sucesso!')),
        );
        setState(() {
          _hasUnsavedChanges = false;
          _imageFile = null;
          _videoFile = null;
          _videoController?.dispose();
          _videoController = null;
          _nameController.clear();
          _passwordController.clear();
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhuma alteração para salvar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Perfil'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : NetworkImage('https://www.w3schools.com/w3images/avatar1.png'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickMedia,
                  child: Text('Escolher Imagem ou Vídeo'),
                ),
                SizedBox(height: 20),
                if (_videoFile != null && _videoController != null && _videoController!.value.isInitialized)
                  AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                else if (_imageFile != null)
                  Image.file(
                    _imageFile!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                else
                  Container(),
                SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _hasUnsavedChanges = true;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha Atual',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onSave,
                  child: Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
