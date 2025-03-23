import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scan_app/core/colors.dart';
import 'package:scan_app/core/spaces.dart';
import 'package:scan_app/data/datasources/document_local_datasource.dart';
import 'package:scan_app/data/models/document_model.dart';
import 'package:scan_app/pages/home_page.dart';

class DetailDocumentPage extends StatefulWidget {
  DocumentModel document;
  final VoidCallback onDelete;
  DetailDocumentPage(
      {super.key, required this.document, required this.onDelete});

  @override
  State<DetailDocumentPage> createState() => _DetailDocumentPageState();
}

class _DetailDocumentPageState extends State<DetailDocumentPage> {
  List<DocumentModel> documents = [];

  Future<void> loadData() async {
    List<DocumentModel> fetchDocuments =
        await DocumentLocalDatasource.instance.getAllDocuments();

    // print(
    //     "Fetched documents: ${fetchDocuments.map((doc) => doc.toJson()).toList()}");

    setState(() {
      documents = fetchDocuments;
    });

    // print(
    //     "Updated documents state: ${documents.map((doc) => doc.toJson()).toList()}");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.document);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.document.name!,
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy HH:mm')
                          .format(widget.document.createdAt!),
                      style: const TextStyle(
                          fontSize: 16, color: AppColors.primary),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Delete button
                    InkWell(
                        onTap: () async {
                          int id = widget.document.id!;
                          DocumentLocalDatasource.instance
                              .deleteDocumentById(id = id);

                          // Show the SnackBar first
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Document deleted'),
                              backgroundColor: AppColors.primary,
                              duration: Duration(milliseconds: 500),
                            ),
                          );

                          await Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (route) => false);
                        },
                        child: const Icon(
                          Icons.delete,
                          color: AppColors.primary,
                        )),

                    // Edit button
                    InkWell(
                      onTap: () async {
                        final TextEditingController nameController =
                            TextEditingController(text: widget.document.name);
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Edit Document Name'),
                              content: TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  labelText: 'New Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(
                                      context), // Close the dialog
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (nameController.text.isNotEmpty) {
                                      String newName = nameController.text;
                                      await DocumentLocalDatasource.instance
                                          .updateDocumentById(
                                        widget.document.id!,
                                        newName,
                                      );

                                      setState(() {
                                        widget.document = widget.document
                                            .copyWith(name: newName);
                                      });

                                      // Show the SnackBar
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Document updated'),
                                          backgroundColor: AppColors.primary,
                                          duration: Duration(milliseconds: 500),
                                        ),
                                      );
                                      Navigator.pop(
                                          context,
                                          widget.document.copyWith(
                                              name:
                                                  newName)); // Close the dialog after saving
                                    }
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.edit,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SpaceHeight(12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(widget.document.path!),
                width: double.infinity,
                fit: BoxFit.contain,
                colorBlendMode: BlendMode.colorBurn,
                color: AppColors.primary.withOpacity(0.2),
              ),
            )
          ],
        ),
      ),
    );
  }
}
