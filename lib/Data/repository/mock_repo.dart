class MockPancakeRepository extends PancakeRepository {
  final List<Pancake> pancakes = [];

  @override
  Future<Pancake> addPancake({required String color, required double price}) {
    return Future.delayed(Duration(seconds: 1), () {
      Pancake newPancake = Pancake(id: "0", color: color, price: 12);
      pancakes.add(newPancake);
      return newPancake;
    });
  }

  @override
  Future<List<Pancake>> getPancakes() {
    return Future.delayed(Duration(seconds: 1), () => pancakes);
  }
}