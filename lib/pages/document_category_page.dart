import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scan_app/data/datasources/document_local_datasource.dart';
import 'package:scan_app/data/models/document_model.dart';
import 'package:scan_app/pages/detail_document_page.dart';

class DocumentCategoryPage extends StatefulWidget {
  final String categoryTitle;
  const DocumentCategoryPage({super.key, required this.categoryTitle});

  @override
  State<DocumentCategoryPage> createState() => _DocumentCategoryPageState();
}

class _DocumentCategoryPageState extends State<DocumentCategoryPage> {
  List<DocumentModel> documents = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    print("Fetching documents for category: ${widget.categoryTitle}");

    List<DocumentModel> fetchDocuments = await DocumentLocalDatasource.instance
        .getDocumentByCategory(widget.categoryTitle);

    print(
        "Fetched documents: ${fetchDocuments.map((doc) => doc.toJson()).toList()}");

    setState(() {
      documents = fetchDocuments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryTitle} Documents'),
      ),
      body: documents.isEmpty
          ? Center(child: Text('No documents found in this category'))
          : GridView.builder(
              itemCount: documents.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3 / 2),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[200],
                  ),
                  child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailDocumentPage(
                                    document: documents[index],
                                    onDelete: () => loadData(),
                                  )));
                      if (result == true) {
                        await loadData();
                      }
                    },
                    child: Column(
                      children: [
                        Expanded(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            width: double.infinity,
                            File(documents[index].path!),
                            fit: BoxFit.cover,
                          ),
                        )),
                        Text(
                          documents[index].name!,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
