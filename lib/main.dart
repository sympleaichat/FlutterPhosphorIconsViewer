import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'all_phosphor_icons.dart'; // 作成したPhosphor Iconsリストをインポート

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Phosphor Icons Viewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey[800],
          elevation: 1,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
      home: const IconViewerPage(),
    );
  }
}

class IconViewerPage extends StatefulWidget {
  const IconViewerPage({super.key});

  @override
  State<IconViewerPage> createState() => _IconViewerPageState();
}

class _IconViewerPageState extends State<IconViewerPage> {
  // 表示用のアイコンリスト
  List<IconDetail> _filteredIcons = allPhosphorIcons;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 検索テキストの変更を監視
    _searchController.addListener(_filterIcons);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 検索クエリに基づいてアイコンをフィルタリングするメソッド
  void _filterIcons() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredIcons = allPhosphorIcons;
      } else {
        _filteredIcons = allPhosphorIcons
            .where(
                (iconDetail) => iconDetail.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Phosphor Icons Viewer'),
        centerTitle: true,
        // 検索バー
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search icons (e.g., heart, camera)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body: _buildIconGrid(),
    );
  }

  // アイコンを表示するグリッドウィジェット
  Widget _buildIconGrid() {
    if (_filteredIcons.isEmpty) {
      return const Center(child: Text('No icons found.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150.0,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
      ),
      itemCount: _filteredIcons.length,
      itemBuilder: (context, index) {
        final iconDetail = _filteredIcons[index];
        final codeSnippet = iconDetail.name;

        return InkWell(
          onTap: () {
            // コードスニペットをクリップボードにコピー
            Clipboard.setData(ClipboardData(text: codeSnippet));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Copied "$codeSnippet" to clipboard!'),
                duration: const Duration(seconds: 1),
                backgroundColor: Colors.green,
              ),
            );
          },
          borderRadius: BorderRadius.circular(8.0),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // PhosphorIconウィジェットでアイコンを表示
                PhosphorIcon(
                  iconDetail.icon(PhosphorIconsStyle.regular),
                  size: 40,
                  color: Colors.deepPurple.shade700,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    iconDetail.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
