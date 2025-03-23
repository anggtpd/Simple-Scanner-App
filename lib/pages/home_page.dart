import 'package:flutter/material.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:scan_app/core/colors.dart';
import 'package:scan_app/core/spaces.dart';
import 'package:scan_app/core/title_content.dart';
import 'package:scan_app/data/datasources/document_local_datasource.dart';
import 'package:scan_app/data/models/document_model.dart';
import 'package:scan_app/pages/latest_documents_page.dart';
import 'package:scan_app/pages/menu_categories.dart';
import 'package:scan_app/pages/save_document_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DocumentModel> documents = [];
  String? pathImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<DocumentModel> fetchDocuments =
        await DocumentLocalDatasource.instance.getAllDocuments();
    setState(() {
      documents = fetchDocuments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner App"),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Scan your card or document",
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                ElevatedButton(
                    onPressed: () async {
                      DocumentScannerOptions documentOptions =
                          DocumentScannerOptions(
                        documentFormat: DocumentFormat.jpeg,
                        mode: ScannerMode.filter,
                        pageLimit: 1,
                        isGalleryImport: true,
                      );

                      final documentScanner =
                          DocumentScanner(options: documentOptions);
                      DocumentScanningResult result =
                          await documentScanner.scanDocument();
                      final pdf = result.pdf;
                      final images = result.images;

                      pathImage = images[0];
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SaveDocumentPage(
                                    pathImage: pathImage!,
                                  )));
                      loadData();
                    },
                    child: const Text("Scan"))
              ],
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TitleContent(
              title: "Categories",
              onSeeAllTap: () {},
            ),
          ),
          const SpaceHeight(12.0),
          const MenuCategories(),
          const SpaceHeight(20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TitleContent(title: 'Latest Documents', onSeeAllTap: () {}),
          ),
          const SpaceHeight(12.0),
          Expanded(
              child: LatestDocumentsPage(
            documents: documents,
          ))
        ],
      ),
    );
  }
}
