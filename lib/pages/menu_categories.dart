import 'package:flutter/material.dart';
import 'package:scan_app/pages/category_button.dart';
import 'package:scan_app/pages/document_category_page.dart';

class MenuCategories extends StatelessWidget {
  const MenuCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
            child: CategoryButton(
                imagePath: null,
                label: 'Card',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DocumentCategoryPage(
                              categoryTitle: 'Card')));
                })),
        Flexible(
            child: CategoryButton(
                imagePath: null,
                label: 'Receipt',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DocumentCategoryPage(
                              categoryTitle: 'Receipt')));
                })),
        Flexible(
            child: CategoryButton(
                imagePath: null,
                label: 'File',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DocumentCategoryPage(
                              categoryTitle: 'File')));
                }))
      ],
    );
  }
}
