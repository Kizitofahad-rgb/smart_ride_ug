import 'package:flutter/material.dart';

import '../../../search/presentation/pages/destination_search_page.dart';

class DestinationSearch extends StatelessWidget {
  const DestinationSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Where do you want to go?',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DestinationSearchPage(),
          ),
        );
      },
    );
  }
}