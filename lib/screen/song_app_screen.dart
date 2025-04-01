class App extends StatelessWidget {
  const App({super.key});

  void _onAddPressed(BuildContext context) {
    final Pancakeprovider pancakeProvider = context.read<Pancakeprovider>();
    pancakeProvider.addPancake("blue", 3.1);
  }

  @override
  Widget build(BuildContext context) {
    final pancakeProvider = Provider.of<Pancakeprovider>(context);

    Widget content = Text('');
    if (pancakeProvider.isLoading) {
      content = CircularProgressIndicator();
    } else if (pancakeProvider.hasData) {
      List<Pancake> pancakes = pancakeProvider.pancakesState!.data!;

      if (pancakes.isEmpty) {
        content = Text("No data yet");
      } else {
        content = ListView.builder(
          itemCount: pancakes.length,
          itemBuilder:
              (context, index) => ListTile(
                title: Text(pancakes[index].color),
                subtitle: Text("${pancakes[index].price}"),
                trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => {}),
              ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [IconButton(onPressed: () => _onAddPressed(context), icon: const Icon(Icons.add))],
      ),
      body: Center(child: content),
    );
  }
}