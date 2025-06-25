import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edustore/providers/auth_provider.dart';
import 'package:edustore/providers/course_provider.dart';
import 'package:edustore/models/course_model.dart';
import 'package:edustore/widgets/common/custom_button.dart';
import 'package:edustore/widgets/common/custom_text_field.dart';
import 'package:edustore/widgets/common/loading_overlay.dart';
import 'package:file_picker/file_picker.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController(text: '5000');
  final _durationController = TextEditingController(text: '2h 30min');
  final _lessonsController = TextEditingController(text: '12');

  CourseFormat _selectedFormat = CourseFormat.pdf;
  CourseLevel _selectedLevel = CourseLevel.beginner;
  String _selectedCategory = 'Développement';
  bool _isFree = false;
  File? _selectedFile;

  final List<String> _categories = [
    'Développement',
    'Design',
    'Marketing',
    'Data Science',
    'Business',
    'Langues',
    'Musique',
    'Art',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _lessonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un cours'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer2<AuthProvider, CourseProvider>(
        builder: (context, authProvider, courseProvider, child) {
          return LoadingOverlay(
            isLoading: courseProvider.isLoading,
            message: 'Création du cours...',
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Titre
                    CustomTextField(
                      controller: _titleController,
                      label: 'Titre du cours *',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Requis' : null,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    CustomTextField(
                      controller: _descriptionController,
                      label: 'Description *',
                      maxLines: 3,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Requis' : null,
                    ),
                    const SizedBox(height: 16),

                    // Type: Gratuit ou Payant
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Gratuit',
                            icon: Icons.free_breakfast,
                            isOutlined: !_isFree,
                            onPressed: () {
                              setState(() {
                                _isFree = true;
                                _priceController.text = '0';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            text: 'Payant',
                            icon: Icons.attach_money,
                            isOutlined: _isFree,
                            onPressed: () {
                              setState(() {
                                _isFree = false;
                                if (_priceController.text == '0') {
                                  _priceController.text = '5000';
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Prix
                    CustomTextField(
                      controller: _priceController,
                      label: _isFree ? 'Prix (Gratuit)' : 'Prix (XAF) *',
                      keyboardType: TextInputType.number,
                      enabled: !_isFree,
                      prefixIcon: Icon(
                        _isFree ? Icons.free_breakfast : Icons.attach_money,
                        color: _isFree ? Colors.green : null,
                      ),
                      validator: (value) {
                        if (!_isFree) {
                          if (value == null || value.isEmpty) {
                            return 'Prix requis';
                          }
                          final parsed = double.tryParse(value);
                          if (parsed == null || parsed <= 0) {
                            return 'Prix invalide';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Catégorie
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Catégorie *',
                      ),
                      items: _categories
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedCategory = val!),
                    ),
                    const SizedBox(height: 16),

                    // Durée
                    CustomTextField(
                      controller: _durationController,
                      label: 'Durée estimée',
                      hint: 'Ex: 2h 30min',
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Requis' : null,
                    ),
                    const SizedBox(height: 16),

                    // Nombre de leçons
                    CustomTextField(
                      controller: _lessonsController,
                      label: 'Nombre de leçons',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requis';
                        }
                        final val = int.tryParse(value);
                        if (val == null || val <= 0) {
                          return 'Nombre invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Niveau
                    const Text('Niveau du cours *'),
                    const SizedBox(height: 8),
                    Row(
                      children: CourseLevel.values.map((level) {
                        final selected = _selectedLevel == level;
                        return Expanded(
                          child: CustomButton(
                            text: _getLevelText(level),
                            isOutlined: !selected,
                            onPressed: () =>
                                setState(() => _selectedLevel = level),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Format
                    const Text('Format du cours *'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'PDF',
                            icon: Icons.picture_as_pdf,
                            isOutlined: _selectedFormat != CourseFormat.pdf,
                            onPressed: () => setState(
                                () => _selectedFormat = CourseFormat.pdf),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            text: 'Vidéo',
                            icon: Icons.play_circle,
                            isOutlined: _selectedFormat != CourseFormat.video,
                            onPressed: () => setState(
                                () => _selectedFormat = CourseFormat.video),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sélecteur de fichier
                    const Text('Fichier du cours *'),
                    const SizedBox(height: 8),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isFree
                              ? Colors.green.shade300
                              : Colors.grey.shade400,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: _isFree ? Colors.green.shade50 : null,
                      ),
                      child: InkWell(
                        onTap: _pickFile,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud_upload, size: 30),
                            const SizedBox(height: 8),
                            Text(
                              _selectedFile != null
                                  ? 'Fichier : ${_selectedFile!.path.split('/').last} (${(_selectedFile!.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} Mo)'
                                  : 'Cliquez pour sélectionner un fichier',
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedFormat == CourseFormat.pdf
                                  ? 'PDF jusqu’à 50MB'
                                  : 'MP4 jusqu’à 500MB',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade500),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (_selectedFile != null)
                      TextButton.icon(
                        icon: const Icon(Icons.clear),
                        label: const Text('Supprimer le fichier'),
                        onPressed: () {
                          setState(() {
                            _selectedFile = null;
                          });
                        },
                      ),
                    const SizedBox(height: 32),

                    // Publier
                    CustomButton(
                      text: _isFree
                          ? 'Publier le cours gratuit'
                          : 'Publier le cours payant',
                      icon: Icons.publish,
                      onPressed: _createCourse,
                      isLoading: courseProvider.isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Note
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue.shade600),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _isFree
                                  ? 'Les cours gratuits sont immédiatement disponibles.'
                                  : 'Les cours payants nécessitent un achat.',
                              style: TextStyle(
                                  color: Colors.blue.shade700, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getLevelText(CourseLevel level) {
    switch (level) {
      case CourseLevel.beginner:
        return 'Débutant';
      case CourseLevel.intermediate:
        return 'Intermédiaire';
      case CourseLevel.advanced:
        return 'Avancé';
    }
  }

  Future<void> _pickFile() async {
    if (![
      _selectedFormat == CourseFormat.pdf,
      _selectedFormat == CourseFormat.video
    ].contains(true)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Veuillez sélectionner un format de cours valide avant de choisir un fichier'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: _selectedFormat == CourseFormat.pdf
          ? FileType.custom
          : FileType.video,
      allowedExtensions:
          _selectedFormat == CourseFormat.pdf ? ['pdf'] : ['mp4'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final maxSizeInBytes = _selectedFormat == CourseFormat.pdf
          ? 50 * 1024 * 1024
          : 500 * 1024 * 1024;

      if (file.lengthSync() > maxSizeInBytes) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Le fichier dépasse la taille maximale autorisée (${_selectedFormat == CourseFormat.pdf ? '50MB' : '500MB'})'),
          backgroundColor: Colors.red,
        ));
        return;
      }

      setState(() {
        _selectedFile = file;
      });
    }
  }

  Future<void> _createCourse() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Veuillez sélectionner un fichier'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);

    final course = CourseModel(
      id: 0,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      price: _isFree ? 0 : double.parse(_priceController.text),
      currency: 'XAF',
      format: _selectedFormat,
      teacher: authProvider.currentUser?.name ?? '',
      teacherId: authProvider.currentUser?.id ?? 0,
      image: 'https://via.placeholder.com/300x200',
      students: 0,
      revenue: 0,
      rating: 0,
      duration: _durationController.text.trim(),
      lessons: int.tryParse(_lessonsController.text) ?? 0,
      category: _selectedCategory,
      level: _selectedLevel,
      createdAt: DateTime.now(),
      isPublished: true,
    );

    final success = await courseProvider.createCourse(course);
    // TODO : Ajouter l'envoi de _selectedFile vers le backend si nécessaire

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          _isFree
              ? 'Cours gratuit créé avec succès !'
              : 'Cours payant créé avec succès !',
        ),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(courseProvider.errorMessage ?? 'Erreur lors de la création'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
