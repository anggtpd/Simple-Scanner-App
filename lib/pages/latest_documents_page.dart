import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scan_app/core/colors.dart';
import 'package:scan_app/core/spaces.dart';
import 'package:scan_app/data/datasources/document_local_datasource.dart';
import 'package:scan_app/data/models/document_model.dart';
import 'package:scan_app/pages/detail_document_page.dart';

class LatestDocumentsPage extends StatefulWidget {
  final List<DocumentModel> documents;
  const LatestDocumentsPage({super.key, required this.documents});

  @override
  State<LatestDocumentsPage> createState() => _LatestDocumentsPageState();
}

class _LatestDocumentsPageState extends State<LatestDocumentsPage> {
  List<DocumentModel> documents = [];
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(); // ✅ Initialize focus node
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        print("LatestDocumentsPage is back in focus! Reloading data...");
        loadData();
      }
    });

    loadData();
  }

  Future<void> loadData() async {
    print("Loading latest documents...");

    setState(() {
      documents.clear(); // ✅ Clearing previous state
    });

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
    debugPrint(
        'Displaying documents: ${documents.map((e) => e.toJson()).toList()}');

    return Focus(
      focusNode: focusNode,
      child: GridView.builder(
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
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailDocumentPage(
                        document: documents[index],
                        onDelete: () {
                          setState(() {
                            loadData(); // Refresh after deletion
                          });
                        },
                      ),
                    ),
                  ).then((updatedDocument) {
                    if (updatedDocument != null) {
                      setState(() {
                        int index = documents
                            .indexWhere((doc) => doc.id == updatedDocument.id);
                        if (index != -1) {
                          documents[index] = updatedDocument;
                        }
                        loadData();
                      });
                    }
                  });
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
                        colorBlendMode: BlendMode.colorBurn,
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    )),
                    const SpaceHeight(4),
                    Text(
                      documents[index].name!,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    focusNode.dispose(); // ✅ Don't forget to dispose the FocusNode
    super.dispose();
  }
}
