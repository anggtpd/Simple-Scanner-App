import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scan_app/core/colors.dart';
import 'package:scan_app/data/datasources/document_local_datasource.dart';
import 'package:scan_app/data/models/document_model.dart';
import 'package:scan_app/pages/home_page.dart';

class SaveDocumentPage extends StatefulWidget {
  final String pathImage;
  const SaveDocumentPage({super.key, required this.pathImage});

  @override
  State<SaveDocumentPage> createState() => _SaveDocumentPageState();
}

class _SaveDocumentPageState extends State<SaveDocumentPage> {
  List<DocumentModel> documents = [];
  TextEditingController? nameController;
  String? selectCategory;

  final List<String> categories = ['Card', 'Receipt', 'File'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    loadData();
  }

  Future<void> loadData() async {
    List<DocumentModel> fetchDocuments =
        await DocumentLocalDatasource.instance.getAllDocuments();

    print(
        "Fetched documents: ${fetchDocuments.map((doc) => doc.toJson()).toList()}");

    setState(() {
      documents = fetchDocuments;
    });

    print(
        "Updated documents state: ${documents.map((doc) => doc.toJson()).toList()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Document'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
              width: double.infinity,
              height: 200,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(File(widget.pathImage)))),
          const SizedBox(
            height: 16.0,
          ),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          DropdownButtonFormField<String>(
            value: selectCategory,
            onChanged: (String? value) {
              setState(() {
                selectCategory = value;
              });
            },
            items: categories
                .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          DocumentModel model = DocumentModel(
              name: nameController!.text,
              category: selectCategory,
              path: widget.pathImage,
              createdAt: DateTime.now());
          DocumentLocalDatasource.instance.saveDocument(model);

// Show the SnackBar first
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Document saved'),
              backgroundColor: AppColors.primary,
              duration: Duration(milliseconds: 500),
            ),
          );

          await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 52,
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16)),
          child: const Center(
            child: Text(
              'Save',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white),
            ),
          ),
        ),
      ),
    );
  }
}
