import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'pagination',
    theme: ThemeData(
      primaryColor: Colors.pink,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  List<String> items = [];
  bool loading = false, allLoaded = false;

  mockFetch() async {
    if (allLoaded) return;
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    List<String> newData = items.length >= 60
        ? []
        : List.generate(20, (index) => "List Item ${index + items.length + 1}");
    if (newData.isNotEmpty) {
      items.addAll(newData);
    }
    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    mockFetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        print('new data call');
        mockFetch();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination'),
        backgroundColor: Colors.purple,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (items.isNotEmpty) {
            return Stack(children: [
              ListView.separated(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (index < items.length) {
                      return ListTile(
                        title: Text(items[index]),
                      );
                    } else {
                      return SizedBox(
                        width: constraints.maxWidth,
                        height: 80,
                        child: const Center(child: Text('all loaded!')),
                      );
                    }
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 1,
                    );
                  },
                  itemCount: items.length + (allLoaded ? 1 : 0)),
              if (loading) ...{
                Positioned(
                    left: 0,
                    bottom: 0,
                    child: SizedBox(
                      height: 80,
                      width: constraints.maxWidth,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ))
              }
            ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
