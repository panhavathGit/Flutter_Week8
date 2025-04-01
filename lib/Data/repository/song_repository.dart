abstract class PancakeRepository {
  Future<Pancake> addPancake({required String color, required double price});
  Future<List<Pancake>> getPancakes();
}